import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/family_reminder.dart';
import '../../domain/repositories/family_reminder_repository.dart';
import '../models/family_reminder_model.dart';

@LazySingleton(as: IFamilyReminderRepository)
class SupabaseFamilyReminderRepository implements IFamilyReminderRepository {
  final SupabaseClient _client;

  SupabaseFamilyReminderRepository(this._client);

  @override
  Future<Either<Failure, List<FamilyReminderEntity>>> getCircleReminders(String circleId) async {
    try {
      final response = await _client
          .from('reminder_board')
          .select()
          .eq('circle_id', circleId)
          .order('created_at', ascending: false);
      final reminders = (response as List).map((json) => FamilyReminderModel.fromJson(json)).toList();
      return Right(reminders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createReminder(FamilyReminderEntity reminder) async {
    try {
      final model = FamilyReminderModel(
        id: reminder.id,
        circleId: reminder.circleId,
        createdBy: reminder.createdBy,
        assignedTo: reminder.assignedTo,
        title: reminder.title,
        description: reminder.description,
        createdAt: reminder.createdAt,
      );
      await _client.from('reminder_board').insert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> completeReminder(String reminderId) async {
    try {
      await _client.from('reminder_board').update({
        'is_completed': true,
        'completed_at': DateTime.now().toIso8601String(),
      }).eq('id', reminderId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<FamilyReminderEntity>> streamCircleReminders(String circleId) {
    return _client
        .from('reminder_board')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .map((data) => data.map((json) => FamilyReminderModel.fromJson(json)).toList());
  }
}
