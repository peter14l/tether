import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/milestone.dart';

abstract class IMilestonesRepository {
  Future<Either<Failure, List<MilestoneEntity>>> getMilestones(String circleId);
  Future<Either<Failure, void>> addMilestone(MilestoneEntity milestone);
}
