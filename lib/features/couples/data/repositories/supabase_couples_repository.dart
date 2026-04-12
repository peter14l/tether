import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/couple_bubble.dart';
import '../../domain/entities/digital_hug.dart';
import '../../domain/entities/heartbeat.dart';
import '../../domain/repositories/couples_repository.dart';
import '../models/couple_bubble_model.dart';
import '../models/digital_hug_model.dart';
import '../models/heartbeat_model.dart';

@LazySingleton(as: ICouplesRepository)
class SupabaseCouplesRepository implements ICouplesRepository {
  final SupabaseClient _client;

  SupabaseCouplesRepository(this._client);

  @override
  Future<Either<Failure, CoupleBubbleEntity>> getCoupleBubble(String circleId) async {
    try {
      final response = await _client
          .from('couple_bubble')
          .select()
          .eq('circle_id', circleId)
          .maybeSingle();

      if (response == null) {
        return Left(ServerFailure('Couple bubble not found for circle $circleId'));
      }

      return Right(CoupleBubbleModel.fromJson(response));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCoupleBubble(CoupleBubbleEntity bubble) async {
    try {
      final model = CoupleBubbleModel(
        id: bubble.id,
        circleId: bubble.circleId,
        ourSongUrl: bubble.ourSongUrl,
        ourSongTitle: bubble.ourSongTitle,
        anniversaryDate: bubble.anniversaryDate,
        promiseRingSetAt: bubble.promiseRingSetAt,
        promiseRingText: bubble.promiseRingText,
        spaceToBreatheActive: bubble.spaceToBreatheActive,
        spaceToBreatheUntil: bubble.spaceToBreatheUntil,
        spaceToBreatheBy: bubble.spaceToBreatheBy,
        createdAt: bubble.createdAt,
      );

      await _client.from('couple_bubble').upsert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendDigitalHug(DigitalHugEntity hug) async {
    try {
      final model = DigitalHugModel(
        id: hug.id,
        senderId: hug.senderId,
        receiverId: hug.receiverId,
        circleId: hug.circleId,
        sentAt: hug.sentAt,
        returnedAt: hug.returnedAt,
      );

      await _client.from('digital_hugs').insert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendHeartbeat(HeartbeatEntity heartbeat) async {
    try {
      final model = HeartbeatModel(
        id: heartbeat.id,
        senderId: heartbeat.senderId,
        receiverId: heartbeat.receiverId,
        sentAt: heartbeat.sentAt,
      );

      await _client.from('heartbeats').insert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<DigitalHugEntity> streamDigitalHugs(String circleId) {
    return _client
        .from('digital_hugs')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .map((data) => data.isNotEmpty ? DigitalHugModel.fromJson(data.first) : throw 'No hug');
  }

  @override
  Stream<HeartbeatEntity> streamHeartbeats(String circleId) {
    // Note: heartbeats table doesn't have circle_id, but DMs are between users.
    // In a real app, you'd filter by the users in the circle.
    return _client
        .from('heartbeats')
        .stream(primaryKey: ['id'])
        .map((data) => data.isNotEmpty ? HeartbeatModel.fromJson(data.first) : throw 'No heartbeat');
  }
}
