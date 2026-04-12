import 'package:equatable/equatable.dart';

abstract class SpaceToBreatheState extends Equatable {
  const SpaceToBreatheState();

  @override
  List<Object?> get props => [];
}

class SpaceToBreatheInitial extends SpaceToBreatheState {}

class SpaceToBreatheLoading extends SpaceToBreatheState {}

class SpaceToBreatheStatus extends SpaceToBreatheState {
  final bool isActive;
  final DateTime? until;
  final String? activeBy;

  const SpaceToBreatheStatus({required this.isActive, this.until, this.activeBy});

  @override
  List<Object?> get props => [isActive, until, activeBy];
}

class SpaceToBreatheError extends SpaceToBreatheState {
  final String message;

  const SpaceToBreatheError(this.message);

  @override
  List<Object?> get props => [message];
}
