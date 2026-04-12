import 'dart:async';
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

  Future<void> loadMessages(String receiverId, {String? circleId}) async {
    emit(MessagingLoading());
    final result = await _messagingRepository.getMessages(receiverId, circleId: circleId);
    result.fold(
      (failure) => emit(MessagingError(failure.message)),
      (messages) {
        emit(MessagingLoaded(messages));
        _subscribeToMessages(receiverId, circleId: circleId);
      },
    );
  }

  void _subscribeToMessages(String receiverId, {String? circleId}) {
    _messagesSubscription?.cancel();
    _messagesSubscription = _messagingRepository
        .streamMessages(receiverId, circleId: circleId)
        .listen((messages) {
      emit(MessagingLoaded(messages));
    });
  }

  Future<void> sendMessage({
    required String receiverId,
    String? circleId,
    required String contentType,
    String? contentText,
    String? mediaUrl,
  }) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) {
      emit(const MessagingError('User not authenticated'));
      return;
    }

    final newMessage = MessageEntity(
      id: '',
      senderId: userId,
      receiverId: receiverId,
      circleId: circleId,
      contentType: contentType,
      contentText: contentText,
      mediaUrl: mediaUrl,
      isRead: false,
      createdAt: DateTime.now(),
    );

    final result = await _messagingRepository.sendMessage(newMessage);
    result.fold(
      (failure) => emit(MessagingError(failure.message)),
      (_) => null, // Stream will update the UI
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
