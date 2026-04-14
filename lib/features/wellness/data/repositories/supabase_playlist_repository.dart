import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/shared_playlist.dart';
import '../../domain/repositories/playlist_repository.dart';
import '../models/shared_playlist_model.dart';

@LazySingleton(as: IPlaylistRepository)
class SupabasePlaylistRepository implements IPlaylistRepository {
  final SupabaseClient _client;

  SupabasePlaylistRepository(this._client);

  @override
  Future<Either<Failure, List<SharedPlaylistEntity>>> getCirclePlaylists(String circleId) async {
    try {
      final response = await _client
          .from('shared_playlists')
          .select()
          .eq('circle_id', circleId)
          .order('created_at', ascending: false);
      final playlists = (response as List).map((json) => SharedPlaylistModel.fromJson(json)).toList();
      return Right(playlists);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sharePlaylist(SharedPlaylistEntity playlist) async {
    try {
      final model = SharedPlaylistModel(
        id: playlist.id,
        circleId: playlist.circleId,
        createdBy: playlist.createdBy,
        title: playlist.title,
        type: playlist.type,
        tracks: playlist.tracks,
      );
      await _client.from('shared_playlists').insert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<SharedPlaylistEntity>> streamCirclePlaylists(String circleId) {
    return _client
        .from('shared_playlists')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .map((data) => data.map((json) => SharedPlaylistModel.fromJson(json)).toList());
  }
}
