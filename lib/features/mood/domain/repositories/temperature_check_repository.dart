import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/temperature_check.dart';

abstract class ITemperatureCheckRepository {
  Future<Either<Failure, List<TemperatureCheckEntity>>> getCircleTemperatureChecks(String circleId);
  Future<Either<Failure, void>> respondToTemperatureCheck(String circleId, String userId, String emojiKey);
  Stream<List<TemperatureCheckEntity>> streamCircleTemperatureChecks(String circleId);
}
