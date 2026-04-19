import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import 'settings_state.dart';

@injectable
class SettingsCubit extends Cubit<SettingsState> {
  final IAuthRepository _authRepository;
  final ISettingsRepository _settingsRepository;

  SettingsCubit(this._authRepository, this._settingsRepository)
      : super(const SettingsState());

  static const String keyReflectionReminders = 'reflection_reminders';
  static const String keyGratitudePrompts = 'gratitude_prompts';
  static const String keySosAlerts = 'sos_alerts';
  static const String keyBiometricLock = 'biometric_lock';
  static const String keyHapticBreathing = 'haptic_breathing';
  static const String keyDarkMode = 'is_dark_mode';

  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true));

    final userResult = await _authRepository.getCurrentUser();
    
    final reflection = await _settingsRepository.getBool(keyReflectionReminders);
    final gratitude = await _settingsRepository.getBool(keyGratitudePrompts);
    final sos = await _settingsRepository.getBool(keySosAlerts);
    final bio = await _settingsRepository.getBool(keyBiometricLock);
    final haptic = await _settingsRepository.getBool(keyHapticBreathing);
    final dark = await _settingsRepository.getBool(keyDarkMode);

    userResult.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (user) => emit(state.copyWith(
        isLoading: false,
        user: user,
        reflectionReminders: reflection.getOrElse((_) => true) ?? true,
        gratitudePrompts: gratitude.getOrElse((_) => true) ?? true,
        sosAlerts: sos.getOrElse((_) => true) ?? true,
        biometricLock: bio.getOrElse((_) => false) ?? false,
        hapticBreathing: haptic.getOrElse((_) => true) ?? true,
        isDarkMode: dark.getOrElse((_) => false) ?? false,
      )),
    );
  }

  Future<void> updateProfile({
    String? displayName,
    String? bio,
    String? pronouns,
    String? avatarUrl,
  }) async {
    if (state.user == null) return;

    final updatedUser = state.user!.copyWith(
      displayName: displayName ?? state.user!.displayName,
      bio: bio ?? state.user!.bio,
      pronouns: pronouns ?? state.user!.pronouns,
      avatarUrl: avatarUrl ?? state.user!.avatarUrl,
    );

    emit(state.copyWith(isLoading: true));
    final result = await _authRepository.updateProfile(updatedUser);

    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (_) => emit(state.copyWith(isLoading: false, user: updatedUser)),
    );
  }

  Future<void> toggleReflectionReminders(bool value) async {
    await _settingsRepository.setBool(keyReflectionReminders, value);
    emit(state.copyWith(reflectionReminders: value));
  }

  Future<void> toggleGratitudePrompts(bool value) async {
    await _settingsRepository.setBool(keyGratitudePrompts, value);
    emit(state.copyWith(gratitudePrompts: value));
  }

  Future<void> toggleSosAlerts(bool value) async {
    await _settingsRepository.setBool(keySosAlerts, value);
    emit(state.copyWith(sosAlerts: value));
  }

  Future<void> toggleBiometricLock(bool value) async {
    await _settingsRepository.setBool(keyBiometricLock, value);
    emit(state.copyWith(biometricLock: value));
  }

  Future<void> toggleHapticBreathing(bool value) async {
    await _settingsRepository.setBool(keyHapticBreathing, value);
    emit(state.copyWith(hapticBreathing: value));
  }

  Future<void> toggleDarkMode(bool value) async {
    await _settingsRepository.setBool(keyDarkMode, value);
    emit(state.copyWith(isDarkMode: value));
  }

  Future<void> signOut() async {
    emit(state.copyWith(isLoading: true));
    final result = await _authRepository.signOut();
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (_) => emit(const SettingsState()), // Reset state
    );
  }
}

extension on UserEntity {
  UserEntity copyWith({
    String? displayName,
    String? bio,
    String? pronouns,
    String? avatarUrl,
  }) {
    return UserEntity(
      id: id,
      email: email,
      username: username,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      pronouns: pronouns ?? this.pronouns,
      moodStatus: moodStatus,
      isQuiet: isQuiet,
      quietUntil: quietUntil,
      timezone: timezone,
      subscriptionTier: subscriptionTier,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
