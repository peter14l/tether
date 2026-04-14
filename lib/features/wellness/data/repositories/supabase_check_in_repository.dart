import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/check_in.dart';
import '../../domain/repositories/check_in_repository.dart';
import '../models/check_in_model.dart';

@LazySingleton(as: ICheckInRepository)
class SupabaseCheckInRepository implements ICheckInRepository {
  final SupabaseClient _client;

  SupabaseCheckInRepository(this._client);

  @override
  Future<Either<Failure, void>> checkIn(CheckInEntity checkIn) async {
    try {
      final model = CheckInModel(
        id: checkIn.id,
        userId: checkIn.userId,
        circleId: checkIn.circleId,
        checkedInAt: checkIn.checkedInAt,
      );
      await _client.from('check_ins').insert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CheckInEntity>>> getCircleCheckIns(String circleId) async {
    try {
      final response = await _client
          .from('check_ins')
          .select()
          .eq('circle_id', circleId)
          .order('checked_in_at', ascending: false);
      final checkIns = (response as List).map((json) => CheckInModel.fromJson(json)).toList();
      return Right(checkIns);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<CheckInEntity>> streamCircleCheckIns(String circleId) {
    return _client
        .from('check_ins')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .map((data) => data.map((json) => CheckInModel.fromJson(json)).toList());
  }
}
