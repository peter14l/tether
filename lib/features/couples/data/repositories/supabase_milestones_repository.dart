import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/milestone.dart';
import '../../domain/repositories/milestones_repository.dart';
import '../models/milestone_model.dart';

@LazySingleton(as: IMilestonesRepository)
class SupabaseMilestonesRepository implements IMilestonesRepository {
  final SupabaseClient _client;

  SupabaseMilestonesRepository(this._client);

  @override
  Future<Either<Failure, List<MilestoneEntity>>> getMilestones(String circleId) async {
    try {
      final response = await _client
          .from('relationship_milestones')
          .select()
          .eq('circle_id', circleId)
          .order('event_date', ascending: true);

      final milestones = (response as List).map((json) => MilestoneModel.fromJson(json)).toList();
      return Right(milestones);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addMilestone(MilestoneEntity milestone) async {
    try {
      final model = MilestoneModel(
        id: milestone.id,
        circleId: milestone.circleId,
        eventDate: milestone.eventDate,
        title: milestone.title,
        description: milestone.description,
        category: milestone.category,
        createdAt: milestone.createdAt,
      );

      await _client.from('relationship_milestones').insert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
