import 'package:equatable/equatable.dart';
import '../../domain/entities/family_safety_check.dart';
import '../../domain/entities/sos_alert.dart';

class FamilySafetyState extends Equatable {
  final List<SosAlertEntity> activeAlerts;
  final List<FamilySafetyCheckEntity> pendingSafetyChecks;
  final bool isSendingSos;
  final String? errorMessage;

  const FamilySafetyState({
    this.activeAlerts = const [],
    this.pendingSafetyChecks = const [],
    this.isSendingSos = false,
    this.errorMessage,
  });

  FamilySafetyState copyWith({
    List<SosAlertEntity>? activeAlerts,
    List<FamilySafetyCheckEntity>? pendingSafetyChecks,
    bool? isSendingSos,
    String? errorMessage,
  }) {
    return FamilySafetyState(
      activeAlerts: activeAlerts ?? this.activeAlerts,
      pendingSafetyChecks: pendingSafetyChecks ?? this.pendingSafetyChecks,
      isSendingSos: isSendingSos ?? this.isSendingSos,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [activeAlerts, pendingSafetyChecks, isSendingSos, errorMessage];
}
