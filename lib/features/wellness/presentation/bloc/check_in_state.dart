import 'package:equatable/equatable.dart';
import '../../domain/entities/check_in.dart';

abstract class CheckInState extends Equatable {
  const CheckInState();

  @override
  List<Object?> get props => [];
}

class CheckInInitial extends CheckInState {}

class CheckInLoading extends CheckInState {}

class CheckInSuccess extends CheckInState {}

class CheckInLoaded extends CheckInState {
  final List<CheckInEntity> checkIns;
  const CheckInLoaded(this.checkIns);

  @override
  List<Object?> get props => [checkIns];
}

class CheckInError extends CheckInState {
  final String message;
  const CheckInError(this.message);

  @override
  List<Object?> get props => [message];
}
