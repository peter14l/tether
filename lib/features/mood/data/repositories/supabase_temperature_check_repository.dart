import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/temperature_check.dart';
import '../../domain/repositories/temperature_check_repository.dart';
import '../models/temperature_check_model.dart';

@LazySingleton(as: ITemperatureCheckRepository)
class SupabaseTemperatureCheckRepository implements ITemperatureCheckRepository {
  final SupabaseClient _client;

  SupabaseTemperatureCheckRepository(this._client);

  @override
  Future<Either<Failure, List<TemperatureCheckEntity>>> getCircleTemperatureChecks(String circleId) async {
    try {
      final response = await _client
          .from('temperature_checks')
          .select()
          .eq('circle_id', circleId)
          .order('date', ascending: false);
      final checks = (response as List).map((json) => TemperatureCheckModel.fromJson(json)).toList();
      return Right(checks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> respondToTemperatureCheck(String circleId, String userId, String emojiKey) async {
    try {
      final dateStr = DateTime.now().toIso8601String().split('T')[0];
      
      // Try to find existing check for today
      final existing = await _client
          .from('temperature_checks')
          .select()
          .eq('circle_id', circleId)
          .eq('date', dateStr)
          .maybeSingle();

      if (existing != null) {
        final responses = Map<String, dynamic>.from(existing['responses'] as Map? ?? {});
        responses[userId] = emojiKey;
        await _client
            .from('temperature_checks')
            .update({'responses': responses})
            .eq('id', existing['id']);
      } else {
        final responses = {userId: emojiKey};
        await _client.from('temperature_checks').insert({
          'circle_id': circleId,
          'date': dateStr,
          'responses': responses,
        });
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<TemperatureCheckEntity>> streamCircleTemperatureChecks(String circleId) {
    return _client
        .from('temperature_checks')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .map((data) => data.map((json) => TemperatureCheckModel.fromJson(json)).toList());
  }
}
