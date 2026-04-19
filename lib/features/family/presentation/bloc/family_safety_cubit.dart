import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/subscription/subscription_service.dart';
import '../../domain/entities/sos_alert.dart';
import '../../domain/repositories/family_repository.dart';
import 'family_safety_state.dart';

@injectable
class FamilySafetyCubit extends Cubit<FamilySafetyState> {
  final IFamilyRepository _familyRepository;
  final SupabaseClient _supabaseClient;
  final ISubscriptionService _subscriptionService;
  StreamSubscription? _sosSubscription;

  FamilySafetyCubit(
    this._familyRepository, 
    this._supabaseClient,
    this._subscriptionService,
  ) : super(const FamilySafetyState());

  Future<void> triggerSos(String circleId) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    if (userId == null) return;

    final isEntitled = await _subscriptionService.checkEntitlement('family_features');
    if (!isEntitled) {
      emit(state.copyWith(errorMessage: 'Tether Plus or Family required for SOS alerts.'));
      return;
    }

    emit(state.copyWith(isSendingSos: true));

    double? lat;
    double? lng;
    double? accuracy;

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );
        lat = position.latitude;
        lng = position.longitude;
        accuracy = position.accuracy;
      }
    } catch (e) {
      // If location fails, we still send SOS but without coordinates
    }

    final alert = SosAlertEntity(
      id: '',
      userId: userId,
      circleId: circleId,
      lat: lat,
      lng: lng,
      accuracy: accuracy,
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

  Future<void> resolveSos(String alertId) async {
    await _familyRepository.resolveSos(alertId);
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
