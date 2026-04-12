import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/family_safety_check.dart';
import '../../domain/entities/sos_alert.dart';
import '../../domain/repositories/family_repository.dart';
import '../models/family_safety_check_model.dart';
import '../models/sos_alert_model.dart';

@LazySingleton(as: IFamilyRepository)
class SupabaseFamilyRepository implements IFamilyRepository {
  final SupabaseClient _client;

  SupabaseFamilyRepository(this._client);

  @override
  Future<Either<Failure, void>> triggerSos(SosAlertEntity alert) async {
    try {
      final model = SosAlertModel(
        id: alert.id,
        userId: alert.userId,
        circleId: alert.circleId,
        lat: alert.lat,
        lng: alert.lng,
        accuracy: alert.accuracy,
        sentAt: alert.sentAt,
      );

      await _client.from('sos_alerts').insert(model.toJson());
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resolveSos(String alertId) async {
    try {
      await _client.from('sos_alerts').update({'resolved_at': DateTime.now().toIso8601String()}).eq('id', alertId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<SosAlertEntity>> listenToSosAlerts(String circleId) {
    return _client
        .from('sos_alerts')
        .stream(primaryKey: ['id'])
        .eq('circle_id', circleId)
        .map((data) => data.map((json) => SosAlertModel.fromJson(json)).toList());
  }

  @override
  Future<Either<Failure, FamilySafetyCheckEntity>> triggerSafetyCheck(String circleId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return const Left(AuthFailure('User not logged in'));

      final model = FamilySafetyCheckModel(
        id: '',
        circleId: circleId,
        triggeredBy: userId,
        timeoutMinutes: 30,
        status: 'pending',
        createdAt: DateTime.now(),
      );

      final response = await _client
          .from('family_safety_checks')
          .insert(model.toJson())
          .select()
          .single();

      return Right(FamilySafetyCheckModel.fromJson(response));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> respondToSafetyCheck(String checkId, String status) async {
    try {
      await _client.from('family_safety_checks').update({
        'status': status,
        'responded_at': DateTime.now().toIso8601String(),
      }).eq('id', checkId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FamilySafetyCheckEntity>>> getSafetyChecks(String circleId) async {
    try {
      final response = await _client
          .from('family_safety_checks')
          .select()
          .eq('circle_id', circleId)
          .order('created_at', ascending: false);

      final checks = (response as List).map((json) => FamilySafetyCheckModel.fromJson(json)).toList();
      return Right(checks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
