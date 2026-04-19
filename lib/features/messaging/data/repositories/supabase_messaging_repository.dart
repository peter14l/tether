import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/messaging_repository.dart';
import '../models/message_model.dart';
import '../../../../core/security/e2ee_service.dart';

@LazySingleton(as: IMessagingRepository)
class SupabaseMessagingRepository implements IMessagingRepository {
  final SupabaseClient _client;
  final IE2EEService _e2eeService;

  SupabaseMessagingRepository(this._client, this._e2eeService);

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessageThreads() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Left(AuthFailure('User not logged in'));

      final response = await _client
          .from('messages')
          .select()
          .or('sender_id.eq.$userId,receiver_id.eq.$userId')
          .order('created_at', ascending: false);

      final List<MessageEntity> allMessages = [];
      for (final json in (response as List)) {
        var model = MessageModel.fromJson(json);
        if (model.contentText != null && model.contentText!.isNotEmpty) {
           final otherId = model.senderId == userId ? model.receiverId : model.senderId;
           final decryptedText = await _e2eeService.decryptMessage(model.contentText!, otherId);
           model = model.copyWith(contentText: decryptedText) as MessageModel;
        }
        allMessages.add(model);
      }
      
      final Map<String, MessageEntity> threadsMap = {};
      for (final msg in allMessages) {
        final otherId = msg.senderId == userId ? msg.receiverId : msg.senderId;
        if (!threadsMap.containsKey(otherId)) {
          threadsMap[otherId] = msg;
        }
      }

      return Right(threadsMap.values.toList());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(String receiverId, {String? circleId}) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Left(AuthFailure('User not logged in'));

      var query = _client.from('messages').select();
      
      if (circleId != null) {
        query = query.eq('circle_id', circleId);
      } else {
        query = query.or('and(sender_id.eq.$userId,receiver_id.eq.$receiverId),and(sender_id.eq.$receiverId,receiver_id.eq.$userId)');
      }

      final response = await query.order('created_at', ascending: true);
      
      final List<MessageEntity> messages = [];
      for (final json in (response as List)) {
        var model = MessageModel.fromJson(json);
        if (model.contentText != null && model.contentText!.isNotEmpty) {
           final otherId = model.senderId == userId ? model.receiverId : model.senderId;
           final decryptedText = await _e2eeService.decryptMessage(model.contentText!, otherId);
           model = model.copyWith(contentText: decryptedText) as MessageModel;
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

      if (message.circleId != null) {
        final bubbleResponse = await _client
            .from('couple_bubble')
            .select('space_to_breathe_active')
            .eq('circle_id', message.circleId!)
            .maybeSingle();

        if (bubbleResponse != null && bubbleResponse['space_to_breathe_active'] == true) {
          return const Left(EncryptionFailure('Space to Breathe is active. Messaging is paused.'));
        }
      }

      String? encryptedText;
      if (message.contentText != null && message.contentText!.isNotEmpty) {
        final otherId = message.senderId == userId ? message.receiverId : message.senderId;
        encryptedText = await _e2eeService.encryptMessage(message.contentText!, otherId);
      }

      final model = MessageModel(
        id: message.id,
        senderId: message.senderId,
        receiverId: message.receiverId,
        circleId: message.circleId,
        contentType: message.contentType,
        contentText: encryptedText ?? message.contentText,
        mediaUrl: message.mediaUrl,
        isRead: message.isRead,
        readAt: message.readAt,
        createdAt: message.createdAt,
      );

      final response = await _client
          .from('messages')
          .insert(model.toJson())
          .select()
          .single();

      var savedModel = MessageModel.fromJson(response);
      if (message.contentText != null && message.contentText!.isNotEmpty) {
         savedModel = savedModel.copyWith(contentText: message.contentText) as MessageModel;
      }

      return Right(savedModel);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<MessageEntity>> streamMessages(String receiverId, {String? circleId}) {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return Stream.value([]);

    var filter = circleId != null 
      ? 'circle_id=eq.$circleId' 
      : 'sender_id=eq.$userId,receiver_id=eq.$receiverId';

    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .asyncMap((data) async {
          final List<MessageEntity> messages = [];
          for (final json in data) {
            var model = MessageModel.fromJson(json);
            if (model.contentText != null && model.contentText!.isNotEmpty) {
               final otherId = model.senderId == userId ? model.receiverId : model.senderId;
               final decryptedText = await _e2eeService.decryptMessage(model.contentText!, otherId);
               model = model.copyWith(contentText: decryptedText) as MessageModel;
            }
            messages.add(model);
          }
          return messages;
        });
  }

  @override
  Future<Either<Failure, String>> uploadVoiceNote(File file) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.m4a';
      final path = 'voice-notes/$fileName';
      await _client.storage.from('voice-notes').upload(path, file);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
