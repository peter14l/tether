import 'package:equatable/equatable.dart';
import '../../domain/entities/message_entity.dart';

abstract class MessagingThreadState extends Equatable {
  const MessagingThreadState();

  @override
  List<Object?> get props => [];
}

class MessagingThreadInitial extends MessagingThreadState {}

class MessagingThreadLoading extends MessagingThreadState {}

class MessagingThreadLoaded extends MessagingThreadState {
  final List<MessageEntity> threads;
  const MessagingThreadLoaded(this.threads);

  @override
  List<Object?> get props => [threads];
}

class MessagingThreadError extends MessagingThreadState {
  final String message;
  const MessagingThreadError(this.message);

  @override
  List<Object?> get props => [message];
}
