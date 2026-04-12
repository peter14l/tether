import 'package:equatable/equatable.dart';
import '../../domain/entities/couple_bubble.dart';
import '../../domain/entities/digital_hug.dart';
import '../../domain/entities/heartbeat.dart';

abstract class CoupleBubbleState extends Equatable {
  const CoupleBubbleState();

  @override
  List<Object?> get props => [];
}

class CoupleBubbleInitial extends CoupleBubbleState {}

class CoupleBubbleLoading extends CoupleBubbleState {}

class CoupleBubbleLoaded extends CoupleBubbleState {
  final CoupleBubbleEntity bubble;
  final List<dynamic> interactions; // Recent hugs/heartbeats

  const CoupleBubbleLoaded({required this.bubble, this.interactions = const []});

  @override
  List<Object?> get props => [bubble, interactions];
}

class CoupleBubbleError extends CoupleBubbleState {
  final String message;

  const CoupleBubbleError(this.message);

  @override
  List<Object?> get props => [message];
}

class InteractionReceived extends CoupleBubbleState {
  final dynamic interaction;

  const InteractionReceived(this.interaction);

  @override
  List<Object?> get props => [interaction];
}
