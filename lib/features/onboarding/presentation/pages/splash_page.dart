import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/linen_ember_theme.dart';

class SplashPage extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashPage({super.key, required this.onComplete});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2800), widget.onComplete);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _timer?.cancel();
        widget.onComplete();
      },
      child: Scaffold(
        backgroundColor: LinenEmberTheme.backgroundPrimary,
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Radial glow
              Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0x1FE8692A), // rgba(232,105,42,0.12)
                      Colors.transparent,
                    ],
                  ),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.85, 0.85),
                    end: const Offset(1.0, 1.0),
                    delay: 1000.ms,
                    duration: 200.ms,
                    curve: Curves.easeOut,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(0.95, 0.95),
                    duration: 200.ms,
                    curve: Curves.easeInOut,
                  ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tether',
                    style: LinenEmberTheme.displayHero(fontSize: 48),
                  )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 400.ms)
                      .slideY(begin: 0.25, end: 0, duration: 400.ms),
                  const SizedBox(height: 16),
                  Text(
                    'Come home to your circle.',
                    style: LinenEmberTheme.body(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: LinenEmberTheme.textSecondary,
                    ).copyWith(letterSpacing: 0.12),
                  ).animate().fadeIn(delay: 600.ms, duration: 300.ms),
                ],
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 400.ms),
    );
  }
}
