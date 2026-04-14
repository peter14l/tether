import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/quiet_hours.dart';

abstract class IQuietHoursRepository {
  Future<Either<Failure, QuietHoursEntity>> getQuietHours(String userId);
  Future<Either<Failure, void>> setQuietHours(QuietHoursEntity quietHours);
  Stream<QuietHoursEntity> streamQuietHours(String userId);
}
