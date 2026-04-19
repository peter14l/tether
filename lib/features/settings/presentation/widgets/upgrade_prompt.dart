import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tether/core/widgets/glass_panel.dart';
import 'package:tether/core/widgets/tether_button.dart';
import 'package:tether/core/widgets/whisper_text.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';


class UpgradePrompt extends StatelessWidget {
  final String featureName;
  final String description;

  const UpgradePrompt({
    super.key,
    required this.featureName,
    required this.description,
  });

  static void show(BuildContext context, {required String featureName, required String description}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => UpgradePrompt(
        featureName: featureName,
        description: description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GlassPanel(
      padding: const EdgeInsets.all(32),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(FluentIcons.star_24_regular, color: colorScheme.primary, size: 48),
          ),
          const SizedBox(height: 24),
          Text(
            'Unlock $featureName',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 40),
          TetherButton(
            onPressed: () {
              context.pop();
              context.push('/subscription');
            },
            isFullWidth: true,
            isHighPriority: true,
            child: const Text('View Membership Options'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.pop(),
            child: const WhisperText('Maybe later'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
