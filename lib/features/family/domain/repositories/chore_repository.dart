import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/chore.dart';

abstract class IChoreRepository {
  Future<Either<Failure, List<ChoreEntity>>> getCircleChores(String circleId);
  Future<Either<Failure, void>> createChore(ChoreEntity chore);
  Future<Either<Failure, void>> completeChore(String choreId);
  Stream<List<ChoreEntity>> streamCircleChores(String circleId);
}
