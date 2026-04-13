import 'package:equatable/equatable.dart';
import 'theme_tokens.dart';

class TimeThemeState extends Equatable {
  final TimeSlot slot;
  final bool? isDarkModeOverride;

  const TimeThemeState(this.slot, {this.isDarkModeOverride});

  TimeThemeState copyWith({TimeSlot? slot, bool? isDarkModeOverride}) {
    return TimeThemeState(
      slot ?? this.slot,
      isDarkModeOverride: isDarkModeOverride ?? this.isDarkModeOverride,
    );
  }

  bool get isDark =>
      isDarkModeOverride ?? (slot == TimeSlot.dusk || slot == TimeSlot.night);

  @override
  List<Object?> get props => [slot, isDarkModeOverride];
}
