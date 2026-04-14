import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/check_in.dart';

abstract class ICheckInRepository {
  Future<Either<Failure, void>> checkIn(CheckInEntity checkIn);
  Future<Either<Failure, List<CheckInEntity>>> getCircleCheckIns(String circleId);
  Stream<List<CheckInEntity>> streamCircleCheckIns(String circleId);
}
