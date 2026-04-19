import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/circle_entity.dart';

abstract class ICircleRepository {
  Future<Either<Failure, List<CircleEntity>>> getMyCircles();
  Future<Either<Failure, List<Map<String, dynamic>>>> getCircleMembers(String circleId);
  Future<Either<Failure, CircleEntity>> createCircle(CircleEntity circle);
  Future<Either<Failure, void>> deleteCircle(String circleId);
  Future<Either<Failure, void>> addMember(String circleId, String userId, String role);
}
