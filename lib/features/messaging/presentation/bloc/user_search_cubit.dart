import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/repositories/messaging_repository.dart';

abstract class UserSearchState extends Equatable {
  const UserSearchState();
  @override
  List<Object?> get props => [];
}

class UserSearchInitial extends UserSearchState {}
class UserSearchLoading extends UserSearchState {}
class UserSearchLoaded extends UserSearchState {
  final List<UserEntity> users;
  const UserSearchLoaded(this.users);
  @override
  List<Object?> get props => [users];
}
class UserSearchError extends UserSearchState {
  final String message;
  const UserSearchError(this.message);
  @override
  List<Object?> get props => [message];
}
class UserSearchRoomCreated extends UserSearchState {
  final String roomId;
  final String otherUserId;
  const UserSearchRoomCreated(this.roomId, this.otherUserId);
  @override
  List<Object?> get props => [roomId, otherUserId];
}

@injectable
class UserSearchCubit extends Cubit<UserSearchState> {
  final IAuthRepository _authRepository;
  final IMessagingRepository _messagingRepository;

  UserSearchCubit(this._authRepository, this._messagingRepository) : super(UserSearchInitial());

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      emit(UserSearchInitial());
      return;
    }
    emit(UserSearchLoading());
    final result = await _authRepository.searchUsers(query);
    result.fold(
      (failure) => emit(UserSearchError(failure.message)),
      (users) => emit(UserSearchLoaded(users)),
    );
  }

  Future<void> startConversation(String otherUserId) async {
    emit(UserSearchLoading());
    final result = await _messagingRepository.getOrCreateRoom(otherUserId);
    result.fold(
      (failure) => emit(UserSearchError(failure.message)),
      (roomId) => emit(UserSearchRoomCreated(roomId, otherUserId)),
    );
  }
}
