import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/quiet_hours.dart';
import '../../domain/repositories/quiet_hours_repository.dart';
import '../models/quiet_hours_model.dart';

@LazySingleton(as: IQuietHoursRepository)
class SupabaseQuietHoursRepository implements IQuietHoursRepository {
  final SupabaseClient _client;

  SupabaseQuietHoursRepository(this._client);

  @override
  Future<Either<Failure, QuietHoursEntity>> getQuietHours(String userId) async {
    try {
      final response = await _client
          .from('quiet_hours')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      
      if (response == null) {
        return Left(ServerFailure('Quiet hours not found for user $userId'));
      }
      
      return Right(QuietHoursModel.fromJson(response));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setQuietHours(QuietHoursEntity quietHours) async {
    try {
      final model = QuietHoursModel(
        id: quietHours.id,
        userId: quietHours.userId,
        enabled: quietHours.enabled,
        startTime: quietHours.startTime,
        endTime: quietHours.endTime,
        windDownStart: quietHours.windDownStart,
        daysActive: quietHours.daysActive,
      );
      await _client.from('quiet_hours').upsert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<QuietHoursEntity> streamQuietHours(String userId) {
    return _client
        .from('quiet_hours')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) => data.isNotEmpty ? QuietHoursModel.fromJson(data.first) : throw 'No quiet hours');
  }
}
