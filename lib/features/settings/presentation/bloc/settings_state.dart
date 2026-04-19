import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user_entity.dart';

class SettingsState extends Equatable {
  final UserEntity? user;
  final bool isLoading;
  final String? error;
  final bool reflectionReminders;
  final bool gratitudePrompts;
  final bool sosAlerts;
  final bool biometricLock;
  final bool hapticBreathing;
  final bool isDarkMode;

  const SettingsState({
    this.user,
    this.isLoading = false,
    this.error,
    this.reflectionReminders = true,
    this.gratitudePrompts = true,
    this.sosAlerts = true,
    this.biometricLock = false,
    this.hapticBreathing = true,
    this.isDarkMode = false,
  });

  SettingsState copyWith({
    UserEntity? user,
    bool? isLoading,
    String? error,
    bool? reflectionReminders,
    bool? gratitudePrompts,
    bool? sosAlerts,
    bool? biometricLock,
    bool? hapticBreathing,
    bool? isDarkMode,
  }) {
    return SettingsState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      reflectionReminders: reflectionReminders ?? this.reflectionReminders,
      gratitudePrompts: gratitudePrompts ?? this.gratitudePrompts,
      sosAlerts: sosAlerts ?? this.sosAlerts,
      biometricLock: biometricLock ?? this.biometricLock,
      hapticBreathing: hapticBreathing ?? this.hapticBreathing,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object?> get props => [
        user,
        isLoading,
        error,
        reflectionReminders,
        gratitudePrompts,
        sosAlerts,
        biometricLock,
        hapticBreathing,
        isDarkMode,
      ];
}
