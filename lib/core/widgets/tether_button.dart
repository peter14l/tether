import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme_tokens.dart';
import '../theme/time_theme_cubit.dart';
import '../theme/time_theme_state.dart';

enum TetherButtonStyle { primary, secondary }

class TetherButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final String? tooltip;
  final String? semanticsLabel;
  final bool isFullWidth;
  final bool isHighPriority;
  final TetherButtonStyle style;
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
    this.isHighPriority = false,
    this.style = TetherButtonStyle.primary,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
  });

  @override
  State<TetherButton> createState() => _TetherButtonState();
}

class _TetherButtonState extends State<TetherButton> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isHighPriority && widget.style == TetherButtonStyle.primary) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TetherButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHighPriority != oldWidget.isHighPriority || widget.style != oldWidget.style) {
      if (widget.isHighPriority && widget.style == TetherButtonStyle.primary) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeThemeCubit, TimeThemeState>(
      builder: (context, state) {
        final tokens = ThemeTokens.getTokens(state.slot);
        final isDark = state.slot == TimeSlot.dusk || state.slot == TimeSlot.night;

        Decoration? decoration;
        if (widget.style == TetherButtonStyle.primary) {
          decoration = BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: widget.backgroundColor == null
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      tokens.accentPrimary,
                      tokens.accentPrimary.withOpacity(0.8),
                    ],
                  )
                : null,
            color: widget.backgroundColor,
            boxShadow: isDark && widget.onPressed != null ? tokens.glowShadows : null,
          );
        } else {
          decoration = BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: tokens.surfaceContainerHigh.withOpacity(0.5),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.18),
              width: 1,
            ),
          );
        }

        Widget buttonContent = Container(
          decoration: decoration,
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: widget.style == TetherButtonStyle.primary
                  ? (widget.foregroundColor ?? tokens.textOnAccent)
                  : (widget.foregroundColor ?? tokens.textPrimary),
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: widget.child,
          ),
        );

        if (widget.isHighPriority && widget.style == TetherButtonStyle.primary) {
          buttonContent = ScaleTransition(
            scale: _scaleAnimation,
            child: buttonContent,
          );
        }

        Widget button = buttonContent;

        if (widget.isFullWidth || widget.width != null || widget.height != null) {
          button = SizedBox(
            width: widget.isFullWidth ? double.infinity : widget.width,
            height: widget.height,
            child: button,
          );
        }

        if (widget.tooltip != null) {
          button = Tooltip(
            message: widget.tooltip!,
            child: button,
          );
        }

        if (widget.semanticsLabel != null) {
          button = Semantics(
            label: widget.semanticsLabel,
            button: true,
            enabled: widget.onPressed != null,
            child: button,
          );
        }

        return button;
      },
    );
  }
}
