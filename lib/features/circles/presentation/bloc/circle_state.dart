import 'package:equatable/equatable.dart';
import '../../domain/entities/circle_entity.dart';

abstract class CircleState extends Equatable {
  const CircleState();

  @override
  List<Object?> get props => [];
}

class CircleInitial extends CircleState {}

class CircleLoading extends CircleState {}

class CircleLoaded extends CircleState {
  final List<CircleEntity> circles;

  const CircleLoaded(this.circles);

  @override
  List<Object?> get props => [circles];
}

class CircleError extends CircleState {
  final String message;

  const CircleError(this.message);

  @override
  List<Object?> get props => [message];
}

class CircleCreated extends CircleState {
  final CircleEntity circle;

  const CircleCreated(this.circle);

  @override
  List<Object?> get props => [circle];
}
