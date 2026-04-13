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
            border: Border.all(color: tokens.borderDefault),
            boxShadow: shadows ?? (isDark ? [] : [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]),
          ),
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(18),
            child: Stack(
              children: [
                // Inner glow for Dusk
                if (isDusk)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            tokens.accentPrimary.withOpacity(0.4),
                            tokens.accentPrimary.withOpacity(0),
                          ],
                        ),
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
