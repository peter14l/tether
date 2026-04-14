import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../models/calendar_event_model.dart';

@LazySingleton(as: ICalendarRepository)
class SupabaseCalendarRepository implements ICalendarRepository {
  final SupabaseClient _client;

  SupabaseCalendarRepository(this._client);

  @override
  Future<Either<Failure, List<CalendarEventEntity>>> getCircleEvents(String circleId) async {
    try {
      final response = await _client
          .from('shared_calendar')
          .select()
          .eq('circle_id', circleId)
          .order('event_date', ascending: true);
      final events = (response as List).map((json) => CalendarEventModel.fromJson(json)).toList();
      return Right(events);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createEvent(CalendarEventEntity event) async {
    try {
      final model = CalendarEventModel(
        id: event.id,
        circleId: event.circleId,
        createdBy: event.createdBy,
        title: event.title,
        description: event.description,
        eventDate: event.eventDate,
        isRecurring: event.isRecurring,
        recurrenceRule: event.recurrenceRule,
        createdAt: event.createdAt,
      );
      await _client.from('shared_calendar').insert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEvent(String eventId) async {
    try {
      await _client.from('shared_calendar').delete().eq('id', eventId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<CalendarEventEntity>> streamCircleEvents(String circleId) {
    return _client
        .from('shared_calendar')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .map((data) => data.map((json) => CalendarEventModel.fromJson(json)).toList());
  }
}
