import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/shared_playlist.dart';

abstract class IPlaylistRepository {
  Future<Either<Failure, List<SharedPlaylistEntity>>> getCirclePlaylists(String circleId);
  Future<Either<Failure, void>> sharePlaylist(SharedPlaylistEntity playlist);
  Stream<List<SharedPlaylistEntity>> streamCirclePlaylists(String circleId);
}
