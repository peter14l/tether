import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme_tokens.dart';
import '../theme/time_theme_cubit.dart';
import '../theme/time_theme_state.dart';

class TetherCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? shadows;

  const TetherCard({
    super.key,
    required this.child,
    this.padding,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeThemeCubit, TimeThemeState>(
      builder: (context, state) {
        final tokens = ThemeTokens.getTokens(state.slot);
        final isDusk = state.slot == TimeSlot.dusk;
        final isDark = state.slot == TimeSlot.dusk || state.slot == TimeSlot.night;

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? tokens.backgroundElevated,
            borderRadius: borderRadius ?? BorderRadius.circular(18),
            boxShadow: shadows ?? [
              // Outer Halo
              BoxShadow(
                color: tokens.textPrimary.withOpacity(0.06),
                blurRadius: 40,
                offset: const Offset(0, 4),
              ),
              // Inner Bloom (Simulated with a second shadow or can be done with gradient)
              BoxShadow(
                color: tokens.accentPrimary.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: -5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(18),
            child: Stack(
              children: [
                // Inner Bloom Overlay (more precise than shadow for inner)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius ?? BorderRadius.circular(18),
                    border: Border.all(
                      color: tokens.accentPrimary.withOpacity(0.05),
                      width: 2,
                    ),
                  ),
                ),
                Padding(
                  padding: padding ?? const EdgeInsets.all(16),
                  child: child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
