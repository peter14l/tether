import 'package:equatable/equatable.dart';
import 'theme_tokens.dart';

class TimeThemeState extends Equatable {
  final TimeSlot slot;

  const TimeThemeState(this.slot);

  @override
  List<Object?> get props => [slot];
}
