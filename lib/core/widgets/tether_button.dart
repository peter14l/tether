import 'package:flutter/material.dart' hide ButtonStyle;
import 'package:fluent_ui/fluent_ui.dart' as fluent;
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
  final bool loading;
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
    this.loading = false,
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

        final fgColor = widget.style == TetherButtonStyle.primary
            ? (widget.foregroundColor ?? tokens.textOnAccent)
            : (widget.foregroundColor ?? tokens.textPrimary);
        
        final bgColor = widget.style == TetherButtonStyle.primary
            ? (widget.backgroundColor ?? tokens.accentPrimary)
            : tokens.surfaceContainerHigh;

        final buttonChild = widget.loading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                ),
              )
            : widget.child;

        // Use Fluent UI buttons
        Widget buttonContent = fluent.FluentTheme(
          data: fluent.FluentThemeData(
            accentColor: widget.style == TetherButtonStyle.primary 
              ? fluent.AccentColor('custom', {
                  'darkest': bgColor,
                  'darker': bgColor,
                  'dark': bgColor,
                  'normal': bgColor,
                  'light': bgColor,
                  'lighter': bgColor,
                  'lightest': bgColor,
                })
              : fluent.Colors.blue,
          ),
          child: widget.style == TetherButtonStyle.primary
              ? fluent.FilledButton(
                  onPressed: widget.loading ? null : widget.onPressed,
                  style: fluent.ButtonStyle(
                    padding: fluent.WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    ),
                    backgroundColor: fluent.WidgetStateProperty.resolveWith((states) {
                      if (states.isDisabled) return bgColor.withOpacity(0.5);
                      if (states.isPressing) return bgColor.withOpacity(0.8);
                      if (states.isHovering) return bgColor.withOpacity(0.9);
                      return bgColor;
                    }),
                    foregroundColor: fluent.WidgetStateProperty.all(fgColor),
                  ),
                  child: buttonChild,
                )
              : fluent.Button(
                  onPressed: widget.loading ? null : widget.onPressed,
                  style: fluent.ButtonStyle(
                    padding: fluent.WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    ),
                    backgroundColor: fluent.WidgetStateProperty.resolveWith((states) {
                      if (states.isDisabled) return bgColor.withOpacity(0.5);
                      if (states.isPressing) return bgColor.withOpacity(0.8);
                      if (states.isHovering) return bgColor.withOpacity(0.9);
                      return bgColor;
                    }),
                    foregroundColor: fluent.WidgetStateProperty.all(fgColor),
                  ),
                  child: buttonChild,
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
