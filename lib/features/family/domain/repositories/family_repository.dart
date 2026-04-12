import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/family_safety_check.dart';
import '../entities/sos_alert.dart';

abstract class IFamilyRepository {
  Future<Either<Failure, void>> triggerSos(SosAlertEntity alert);
  Future<Either<Failure, void>> resolveSos(String alertId);
  Stream<List<SosAlertEntity>> listenToSosAlerts(String circleId);
  
  Future<Either<Failure, FamilySafetyCheckEntity>> triggerSafetyCheck(String circleId);
  Future<Either<Failure, void>> respondToSafetyCheck(String checkId, String status);
  Future<Either<Failure, List<FamilySafetyCheckEntity>>> getSafetyChecks(String circleId);
}
