import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme_tokens.dart';
import '../theme/time_theme_cubit.dart';
import '../theme/time_theme_state.dart';

class TetherButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String? tooltip;
  final String? semanticsLabel;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;

  const TetherButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.tooltip,
    this.semanticsLabel,
    this.isFullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeThemeCubit, TimeThemeState>(
      builder: (context, state) {
        final tokens = ThemeTokens.getTokens(state.slot);
        final isDark = state.slot == TimeSlot.dusk || state.slot == TimeSlot.night;

        Widget button = ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? tokens.accentPrimary,
            foregroundColor: foregroundColor ?? tokens.textOnAccent,
            elevation: 0, // Elevation is handled by glowShadows
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: child,
        );

        // Apply glow effect for dusk/night
        if (isDark && onPressed != null) {
          button = Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: tokens.glowShadows,
            ),
            child: button,
          );
        }

        if (isFullWidth || width != null || height != null) {
          button = SizedBox(
            width: isFullWidth ? double.infinity : width,
            height: height,
            child: button,
          );
        }

        if (tooltip != null) {
          button = Tooltip(
            message: tooltip!,
            child: button,
          );
        }

        if (semanticsLabel != null) {
          button = Semantics(
            label: semanticsLabel,
            button: true,
            enabled: onPressed != null,
            child: button,
          );
        }

        return button;
      },
    );
  }
}
