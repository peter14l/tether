import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/linen_ember_theme.dart';
import '../widgets/ambient_blob.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LinenEmberTheme.backgroundPrimary,
      body: Stack(
        children: [
          const AmbientBlob(
            color: Color(0x24E8692A), // rgba(232, 105, 42, 0.14)
            position: Offset(0, -100), // top-center approx
          ),
          const AmbientBlob(
            color: Color(0x1FC2527A), // rgba(194, 82, 122, 0.12)
            position: Offset(40, 500), // bottom-left approx
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Text(
                  'Ready to come home?',
                  style: LinenEmberTheme.headingItalic(fontSize: 42),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack),
                const SizedBox(height: 16),
                Text(
                  'Tether is free to start. No algorithms. No ads. Just the people you love.',
                  style: LinenEmberTheme.body(),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                const Spacer(flex: 1),
                
                // Primary CTA
                GestureDetector(
                  onTapDown: (_) {
                    setState(() => _scale = 0.97);
                    HapticFeedback.mediumImpact();
                  },
                  onTapUp: (_) => setState(() => _scale = 1.0),
                  onTapCancel: () => setState(() => _scale = 1.0),
                  onTap: () {
                    context.push('/signup');
                  },
                  child: AnimatedScale(
                    scale: _scale,
                    duration: const Duration(milliseconds: 100),
                    child: Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(LinenEmberTheme.radiusFull),
                        gradient: const LinearGradient(
                          colors: [LinenEmberTheme.accentSunsetOrange, LinenEmberTheme.accentGoldenAmber],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33E8692A),
                            blurRadius: 32,
                            offset: Offset(0, 8),
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Sign Up',
                        style: LinenEmberTheme.body(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: LinenEmberTheme.backgroundPrimary,
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 24),
                
                // Secondary CTA
                TextButton(
                  onPressed: () {
                    context.push('/login');
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'I already have an account — ',
                          style: LinenEmberTheme.body(fontSize: 14),
                        ),
                        TextSpan(
                          text: 'Sign In',
                          style: LinenEmberTheme.body(
                            fontSize: 14,
                            color: LinenEmberTheme.accentSunsetOrange,
                          ).copyWith(decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
                
                SizedBox(height: MediaQuery.of(context).padding.bottom + 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
