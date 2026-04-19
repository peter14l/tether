import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/messaging_repository.dart';
import 'messaging_state.dart';

@injectable
class MessagingCubit extends Cubit<MessagingState> {
  final IMessagingRepository _messagingRepository;
  final SupabaseClient _supabaseClient;
  StreamSubscription? _messagesSubscription;

  MessagingCubit(this._messagingRepository, this._supabaseClient) : super(MessagingInitial());

  Future<void> loadMessages(String roomId) async {
    emit(MessagingLoading());
    final result = await _messagingRepository.getMessages(roomId);
    result.fold(
      (failure) => emit(MessagingError(failure.message)),
      (messages) {
        emit(MessagingLoaded(messages));
        _subscribeToMessages(roomId);
      },
    );
  }

  void _subscribeToMessages(String roomId) {
    _messagesSubscription?.cancel();
    _messagesSubscription = _messagingRepository
        .streamMessages(roomId)
        .listen((messages) {
      emit(MessagingLoaded(messages));
    });
  }

  Future<void> sendMessage({
    required String roomId,
    required String messageType,
    String? contentText,
    String? r2ObjectKey,
    String? mediaKey,
  }) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      emit(const MessagingError('User not authenticated'));
      return;
    }

    final newMessage = MessageEntity(
      id: '',
      roomId: roomId,
      senderId: userId,
      messageType: messageType,
      encryptedText: contentText, // This will be encrypted by the repository
      r2ObjectKey: r2ObjectKey,
      mediaKey: mediaKey,
      createdAt: DateTime.now(),
    );

    final result = await _messagingRepository.sendMessage(newMessage);
    result.fold(
      (failure) => emit(MessagingError(failure.message)),
      (_) => null,
    );
  }

  Future<void> sendMediaMessage({
    required String roomId,
    required String messageType,
    required File file,
  }) async {
    final uploadResult = await _messagingRepository.uploadMedia(file, roomId);
    
    uploadResult.fold(
      (failure) => emit(MessagingError(failure.message)),
      (mediaData) {
        sendMessage(
          roomId: roomId,
          messageType: messageType,
          r2ObjectKey: mediaData.objectKey,
          mediaKey: mediaData.mediaKey,
        );
      },
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
