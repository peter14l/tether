import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/linen_ember_theme.dart';

class OnboardingStep {
  final GlobalKey targetKey;
  final String title;
  final String body;

  OnboardingStep({
    required this.targetKey,
    required this.title,
    required this.body,
  });
}

class FeatureOnboardingOverlay extends StatefulWidget {
  final List<OnboardingStep> steps;
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  const FeatureOnboardingOverlay({
    super.key,
    required this.steps,
    required this.onComplete,
    required this.onSkip,
  });

  @override
  State<FeatureOnboardingOverlay> createState() => _FeatureOnboardingOverlayState();
}

class _FeatureOnboardingOverlayState extends State<FeatureOnboardingOverlay> {
  int _currentStep = 0;
  Rect? _targetRect;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateTargetRect());
  }

  void _calculateTargetRect() {
    final key = widget.steps[_currentStep].targetKey;
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final offset = renderBox.localToGlobal(Offset.zero);
      setState(() {
        _targetRect = offset & renderBox.size;
      });
    }
  }

  void _nextStep() {
    if (_currentStep < widget.steps.length - 1) {
      setState(() {
        _currentStep++;
      });
      _calculateTargetRect();
    } else {
      widget.onComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_targetRect == null) return const SizedBox.shrink();

    return Stack(
      children: [
        // Scrim with spotlight
        GestureDetector(
          onTap: _nextStep,
          child: CustomPaint(
            size: Size.infinite,
            painter: SpotlightPainter(
              rect: _targetRect!,
              scrimColor: const Color(0xD10D0A12), // rgba(13, 10, 18, 0.82)
            ),
          ),
        ),

        // Tooltip
        _buildTooltip(),
      ],
    );
  }

  Widget _buildTooltip() {
    final step = widget.steps[_currentStep];
    final isAbove = _targetRect!.top > MediaQuery.of(context).size.height / 2;
    
    return Positioned(
      left: 24,
      right: 24,
      top: isAbove ? null : _targetRect!.bottom + 12,
      bottom: isAbove ? (MediaQuery.of(context).size.height - _targetRect!.top) + 12 : null,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: LinenEmberTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(LinenEmberTheme.radiusLg),
          border: Border.all(color: LinenEmberTheme.borderSubtle),
          boxShadow: const [LinenEmberTheme.shadowLg],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${_currentStep + 1} of ${widget.steps.length}',
                  style: LinenEmberTheme.caption(color: LinenEmberTheme.textTertiary)
                      .copyWith(fontSize: 11),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.onSkip,
                  child: Text(
                    'Skip Tour',
                    style: LinenEmberTheme.body(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: LinenEmberTheme.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              step.title,
              style: LinenEmberTheme.body(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: LinenEmberTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              step.body,
              style: LinenEmberTheme.body(fontSize: 14).copyWith(height: 1.6),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: _nextStep,
                child: Text(
                  _currentStep == widget.steps.length - 1 ? 'Got it ✓' : 'Next →',
                  style: LinenEmberTheme.body(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: LinenEmberTheme.accentSunsetOrange,
                  ),
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.95, 0.95)),
    );
  }
}

class SpotlightPainter extends CustomPainter {
  final Rect rect;
  final Color scrimColor;

  SpotlightPainter({required this.rect, required this.scrimColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = scrimColor;
    
    // Scrim with hole
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(Offset.zero & size, paint);
    
    final spotlightRect = rect.inflate(8);
    final RRect rrect = RRect.fromRectAndRadius(
      spotlightRect,
      const Radius.circular(LinenEmberTheme.radiusMd),
    );
    
    canvas.drawRRect(rrect, Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant SpotlightPainter oldDelegate) {
    return oldDelegate.rect != rect;
  }
}
