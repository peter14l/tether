import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/sos_alert.dart';
import '../../domain/repositories/family_repository.dart';
import 'family_safety_state.dart';

@injectable
class FamilySafetyCubit extends Cubit<FamilySafetyState> {
  final IFamilyRepository _familyRepository;
  final SupabaseClient _supabaseClient;
  StreamSubscription? _sosSubscription;

  FamilySafetyCubit(this._familyRepository, this._supabaseClient) : super(const FamilySafetyState());

  Future<void> triggerSos(String circleId, {double? lat, double? lng}) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    emit(state.copyWith(isSendingSos: true));
    final alert = SosAlertEntity(
      id: '',
      userId: userId,
      circleId: circleId,
      lat: lat,
      lng: lng,
      sentAt: DateTime.now(),
    );

    final result = await _familyRepository.triggerSos(alert);
    result.fold(
      (failure) => emit(state.copyWith(isSendingSos: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isSendingSos: false)),
    );
  }

  void listenToSosAlerts(String circleId) {
    _sosSubscription?.cancel();
    _sosSubscription = _familyRepository.listenToSosAlerts(circleId).listen((alerts) {
      final active = alerts.where((a) => a.resolvedAt == null).toList();
      emit(state.copyWith(activeAlerts: active));
    });
  }

  Future<void> loadSafetyChecks(String circleId) async {
    final result = await _familyRepository.getSafetyChecks(circleId);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (checks) {
        final pending = checks.where((c) => c.status == 'pending').toList();
        emit(state.copyWith(pendingSafetyChecks: pending));
      },
    );
  }

  Future<void> respondToSafetyCheck(String circleId, String checkId, String status) async {
    final result = await _familyRepository.respondToSafetyCheck(checkId, status);
    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) => loadSafetyChecks(circleId),
    );
  }

  @override
  Future<void> close() {
    _sosSubscription?.cancel();
    return super.close();
  }
}
