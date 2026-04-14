import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/family_reminder.dart';

abstract class IFamilyReminderRepository {
  Future<Either<Failure, List<FamilyReminderEntity>>> getCircleReminders(String circleId);
  Future<Either<Failure, void>> createReminder(FamilyReminderEntity reminder);
  Future<Either<Failure, void>> completeReminder(String reminderId);
  Stream<List<FamilyReminderEntity>> streamCircleReminders(String circleId);
}
