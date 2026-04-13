import 'package:equatable/equatable.dart';

abstract class CircleMemberState extends Equatable {
  const CircleMemberState();

  @override
  List<Object?> get props => [];
}

class CircleMemberInitial extends CircleMemberState {}

class CircleMemberLoading extends CircleMemberState {}

class CircleMemberLoaded extends CircleMemberState {
  final List<Map<String, dynamic>> members;
  const CircleMemberLoaded(this.members);

  @override
  List<Object?> get props => [members];
}

class CircleMemberError extends CircleMemberState {
  final String message;
  const CircleMemberError(this.message);

  @override
  List<Object?> get props => [message];
}
