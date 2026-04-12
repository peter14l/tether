import 'package:equatable/equatable.dart';
import '../../domain/entities/message_entity.dart';

abstract class MessagingState extends Equatable {
  const MessagingState();

  @override
  List<Object?> get props => [];
}

class MessagingInitial extends MessagingState {}

class MessagingLoading extends MessagingState {}

class MessagingLoaded extends MessagingState {
  final List<MessageEntity> messages;

  const MessagingLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class MessagingError extends MessagingState {
  final String message;

  const MessagingError(this.message);

  @override
  List<Object?> get props => [message];
}
