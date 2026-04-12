import 'package:equatable/equatable.dart';
import '../../domain/entities/reflection.dart';

abstract class ReflectionState extends Equatable {
  const ReflectionState();

  @override
  List<Object?> get props => [];
}

class ReflectionInitial extends ReflectionState {}

class ReflectionLoading extends ReflectionState {}

class ReflectionLoaded extends ReflectionState {
  final List<ReflectionEntity> reflections;

  const ReflectionLoaded(this.reflections);

  @override
  List<Object?> get props => [reflections];
}

class ReflectionError extends ReflectionState {
  final String message;

  const ReflectionError(this.message);

  @override
  List<Object?> get props => [message];
}

class ReflectionAdded extends ReflectionState {}
