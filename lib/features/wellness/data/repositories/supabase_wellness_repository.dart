import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/digital_hug.dart';
import '../../domain/entities/kindness_streak.dart';
import '../../domain/repositories/wellness_repository.dart';
import '../models/digital_hug_model.dart';
import '../models/kindness_streak_model.dart';

@LazySingleton(as: IWellnessRepository)
class SupabaseWellnessRepository implements IWellnessRepository {
  final SupabaseClient _client;

  SupabaseWellnessRepository(this._client);

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
  Stream<List<DigitalHugEntity>> streamDigitalHugs(String circleId) {
    return _client
        .from('digital_hugs')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .map((data) => data.map((json) => DigitalHugModel.fromJson(json)).toList());
  }

  @override
  Future<Either<Failure, List<KindnessStreakEntity>>> getKindnessStreaks(String circleId) async {
    try {
      final response = await _client
          .from('kindness_streaks')
          .select()
          .eq('circle_id', circleId)
          .order('logged_at', ascending: false);
      final streaks = (response as List).map((json) => KindnessStreakModel.fromJson(json)).toList();
      return Right(streaks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logKindnessAction(KindnessStreakEntity streak) async {
    try {
      final model = KindnessStreakModel(
        id: streak.id,
        userId: streak.userId,
        circleId: streak.circleId,
        actionType: streak.actionType,
        loggedAt: streak.loggedAt,
      );
      await _client.from('kindness_streaks').insert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
