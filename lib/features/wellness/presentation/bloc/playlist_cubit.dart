import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/shared_playlist.dart';
import '../../domain/repositories/playlist_repository.dart';
import 'package:equatable/equatable.dart';

abstract class PlaylistState extends Equatable {
  const PlaylistState();
  @override
  List<Object?> get props => [];
}

class PlaylistInitial extends PlaylistState {}
class PlaylistLoading extends PlaylistState {}
class PlaylistLoaded extends PlaylistState {
  final List<SharedPlaylistEntity> playlists;
  const PlaylistLoaded(this.playlists);
  @override
  List<Object?> get props => [playlists];
}
class PlaylistError extends PlaylistState {
  final String message;
  const PlaylistError(this.message);
  @override
  List<Object?> get props => [message];
}

@injectable
class PlaylistCubit extends Cubit<PlaylistState> {
  final IPlaylistRepository _repository;

  PlaylistCubit(this._repository) : super(PlaylistInitial());

  Future<void> loadPlaylists(String circleId) async {
    emit(PlaylistLoading());
    final result = await _repository.getCirclePlaylists(circleId);
    result.fold(
      (failure) => emit(PlaylistError(failure.message)),
      (playlists) => emit(PlaylistLoaded(playlists)),
    );
  }
}
