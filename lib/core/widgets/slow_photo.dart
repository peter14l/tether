import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme_tokens.dart';
import '../theme/time_theme_cubit.dart';
import '../theme/time_theme_state.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';


class SlowPhoto extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double opacity;

  const SlowPhoto({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimeThemeCubit, TimeThemeState>(
      builder: (context, state) {
        final tokens = state.tokens;

        return Opacity(
          opacity: opacity,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: tokens.backgroundSecondary,
              borderRadius: borderRadius ?? BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: width,
                height: height,
                fit: fit,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) return child;
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeIn,
                    child: child,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2,
                      color: tokens.accentPrimary.withOpacity(0.5),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      FluentIcons.image_24_regular,
                      color: tokens.textSecondary.withOpacity(0.5),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
