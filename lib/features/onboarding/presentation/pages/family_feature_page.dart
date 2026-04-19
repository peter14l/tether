import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/linen_ember_theme.dart';
import '../widgets/ambient_blob.dart';
import '../widgets/bento_grid_illustration.dart';

class FamilyFeaturePage extends StatelessWidget {
  const FamilyFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LinenEmberTheme.backgroundPrimary,
      body: Stack(
        children: [
          const AmbientBlob(
            color: Color(0x1AF0A832), // rgba(240, 168, 50, 0.10)
            position: Offset(40, 400), // bottom-center approx
          ),
          Column(
            children: [
              const SizedBox(height: 60),
              const BentoGridIllustration(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Family life, beautifully organised.',
                      style: LinenEmberTheme.headingItalic(fontSize: 34),
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 16),
                    Text(
                      'The Family Bento brings your family\'s whole world into one modular, living dashboard. Memories, voices, check-ins — all in one beautiful place.',
                      style: LinenEmberTheme.body(),
                    ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
