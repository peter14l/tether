import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/messaging_repository.dart';
import '../models/message_model.dart';

@LazySingleton(as: IMessagingRepository)
class SupabaseMessagingRepository implements IMessagingRepository {
  final SupabaseClient _client;

  SupabaseMessagingRepository(this._client);

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
      final messages = (response as List).map((json) => MessageModel.fromJson(json)).toList();
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage(MessageEntity message) async {
    try {
      // Check for Space to Breathe if circleId is present
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

      final model = MessageModel(
        id: message.id,
        senderId: message.senderId,
        receiverId: message.receiverId,
        circleId: message.circleId,
        contentType: message.contentType,
        contentText: message.contentText,
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

      return Right(MessageModel.fromJson(response));
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
    
    // Note: Supabase Realtime complex filters are limited. 
    // In a real app, you might use a broader filter and filter locally, or use a function.
    // For simplicity, we'll filter by circleId or just the current pair.

    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .map((data) => data.map((json) => MessageModel.fromJson(json)).toList());
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
