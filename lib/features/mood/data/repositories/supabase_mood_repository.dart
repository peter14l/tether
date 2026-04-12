import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/mood_status.dart';
import '../../domain/repositories/mood_repository.dart';
import '../models/mood_model.dart';

@LazySingleton(as: IMoodRepository)
class SupabaseMoodRepository implements IMoodRepository {
  final SupabaseClient _client;

  SupabaseMoodRepository(this._client);

  @override
  Future<Either<Failure, MoodStatusEntity>> getMoodStatus(String userId) async {
    try {
      final response = await _client
          .from('mood_rooms')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        // Return a default status if none exists
        return Right(MoodStatusEntity(
          id: '',
          userId: userId,
          status: MoodType.happy,
          updatedAt: DateTime.now(),
        ));
      }

      return Right(MoodModel.fromJson(response));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setMoodStatus(MoodStatusEntity status) async {
    try {
      final model = MoodModel(
        id: status.id,
        userId: status.userId,
        status: status.status,
        label: status.label,
        colorKey: status.colorKey,
        updatedAt: status.updatedAt,
      );

      await _client.from('mood_rooms').upsert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
