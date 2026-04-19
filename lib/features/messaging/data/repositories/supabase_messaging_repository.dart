import 'dart:convert';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/messaging_repository.dart';
import '../models/message_model.dart';
import '../../../../core/security/e2ee_service.dart';
import '../../../../core/network/r2_storage_service.dart';

@LazySingleton(as: IMessagingRepository)
class SupabaseMessagingRepository implements IMessagingRepository {
  final SupabaseClient _client;
  final IE2EEService _e2eeService;
  final R2StorageService _r2StorageService;

  SupabaseMessagingRepository(this._client, this._e2eeService, this._r2StorageService);

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessageThreads() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Left(AuthFailure('User not logged in'));

      // Get rooms the user is a participant of
      final roomsResponse = await _client
          .from('participants')
          .select('room_id, rooms(*)')
          .eq('user_id', userId);

      final List<MessageEntity> latestMessages = [];
      for (final row in (roomsResponse as List)) {
        final roomId = row['room_id'];
        final messageResponse = await _client
            .from('messages')
            .select()
            .eq('room_id', roomId)
            .order('created_at', ascending: false)
            .limit(1)
            .maybeSingle();

        if (messageResponse != null) {
          var model = MessageModel.fromJson(messageResponse);
          if (model.messageType == 'text' && model.encryptedText != null) {
             final otherParticipant = await _getOtherParticipant(roomId, userId);
             if (otherParticipant != null) {
               final decryptedText = await _e2eeService.decryptMessage(model.encryptedText!, otherParticipant);
               model = model.copyWith(encryptedText: decryptedText) as MessageModel;
             }
          }
          latestMessages.add(model);
        }
      }

      return Right(latestMessages);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(String roomId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Left(AuthFailure('User not logged in'));

      final response = await _client
          .from('messages')
          .select()
          .eq('room_id', roomId)
          .order('created_at', ascending: true);
      
      final otherParticipant = await _getOtherParticipant(roomId, userId);

      final List<MessageEntity> messages = [];
      for (final json in (response as List)) {
        var model = MessageModel.fromJson(json);
        if (model.messageType == 'text' && model.encryptedText != null && otherParticipant != null) {
           final decryptedText = await _e2eeService.decryptMessage(model.encryptedText!, otherParticipant);
           model = model.copyWith(encryptedText: decryptedText) as MessageModel;
        }
        messages.add(model);
      }
      
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(MessageEntity message) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Left(AuthFailure('User not logged in'));

      final otherParticipant = await _getOtherParticipant(message.roomId, userId);
      if (otherParticipant == null) return const Left(ServerFailure('No other participant found in room'));

      String? encryptedText = message.encryptedText;
      if (message.messageType == 'text' && message.encryptedText != null) {
        encryptedText = await _e2eeService.encryptMessage(message.encryptedText!, otherParticipant);
      }

      final model = MessageModel(
        id: message.id,
        roomId: message.roomId,
        senderId: userId,
        messageType: message.messageType,
        encryptedText: encryptedText,
        r2ObjectKey: message.r2ObjectKey,
        mediaKey: message.mediaKey,
        createdAt: message.createdAt,
      );

      final response = await _client
          .from('messages')
          .insert(model.toJson())
          .select()
          .single();

      var savedModel = MessageModel.fromJson(response);
      if (message.messageType == 'text') {
         savedModel = savedModel.copyWith(encryptedText: message.encryptedText) as MessageModel;
      }

      return Right(savedModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<MessageEntity>> streamMessages(String roomId) {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return Stream.value([]);

    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .asyncMap((data) async {
          final otherParticipant = await _getOtherParticipant(roomId, userId);
          final List<MessageEntity> messages = [];
          for (final json in data) {
            var model = MessageModel.fromJson(json);
            if (model.messageType == 'text' && model.encryptedText != null && otherParticipant != null) {
               final decryptedText = await _e2eeService.decryptMessage(model.encryptedText!, otherParticipant);
               model = model.copyWith(encryptedText: decryptedText) as MessageModel;
            }
            messages.add(model);
          }
          return messages;
        });
  }

  @override
  Future<Either<Failure, ({String objectKey, String mediaKey})>> uploadMedia(File file, String roomId) async {
    try {
      // 1. Encrypt file
      final encryptionResult = await _r2StorageService.encryptFile(file);
      
      // 2. Upload to R2
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final objectKey = await _r2StorageService.uploadEncryptedFile(
        encryptionResult.encryptedBytes, 
        fileName
      );

      return Right((
        objectKey: objectKey, 
        mediaKey: base64Encode(encryptionResult.mediaKey)
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getOrCreateRoom(String otherUserId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Left(AuthFailure('User not logged in'));

      // 1. Check if a 1:1 room already exists
      // We look for rooms where BOTH users are participants and it's not a group
      final response = await _client.rpc('get_or_create_1to1_room', params: {
        'user1_id': userId,
        'user2_id': otherUserId,
      });

      if (response != null) {
        return Right(response as String);
      }

      return const Left(ServerFailure('Failed to get or create room'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<String?> _getOtherParticipant(String roomId, String userId) async {
    final response = await _client
        .from('participants')
        .select('user_id')
        .eq('room_id', roomId)
        .neq('user_id', userId)
        .maybeSingle();
    
    return response?['user_id'] as String?;
  }
}
