import 'package:equatable/equatable.dart';
import '../../domain/entities/mood_status.dart';

abstract class MoodState extends Equatable {
  const MoodState();

  @override
  List<Object?> get props => [];
}

class MoodInitial extends MoodState {}

class MoodLoading extends MoodState {}

class MoodLoaded extends MoodState {
  final MoodStatusEntity status;

  const MoodLoaded(this.status);

  @override
  List<Object?> get props => [status];
}

class MoodError extends MoodState {
  final String message;

  const MoodError(this.message);

  @override
  List<Object?> get props => [message];
}
