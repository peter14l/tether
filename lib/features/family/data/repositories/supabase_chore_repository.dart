import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/chore.dart';
import '../../domain/repositories/chore_repository.dart';
import '../models/chore_model.dart';

@LazySingleton(as: IChoreRepository)
class SupabaseChoreRepository implements IChoreRepository {
  final SupabaseClient _client;

  SupabaseChoreRepository(this._client);

  @override
  Future<Either<Failure, List<ChoreEntity>>> getCircleChores(String circleId) async {
    try {
      final response = await _client
          .from('chore_chart')
          .select()
          .eq('circle_id', circleId)
          .order('created_at', ascending: false);
      final chores = (response as List).map((json) => ChoreModel.fromJson(json)).toList();
      return Right(chores);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createChore(ChoreEntity chore) async {
    try {
      final model = ChoreModel(
        id: chore.id,
        circleId: chore.circleId,
        assignedTo: chore.assignedTo,
        title: chore.title,
        seedsValue: chore.seedsValue,
        createdAt: chore.createdAt,
      );
      await _client.from('chore_chart').insert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> completeChore(String choreId) async {
    try {
      await _client.from('chore_chart').update({
        'is_completed': true,
        'completed_at': DateTime.now().toIso8601String(),
      }).eq('id', choreId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<ChoreEntity>> streamCircleChores(String circleId) {
    return _client
        .from('chore_chart')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .map((data) => data.map((json) => ChoreModel.fromJson(json)).toList());
  }
}
