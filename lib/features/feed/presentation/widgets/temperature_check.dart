import 'package:flutter/material.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/whisper_text.dart';

class TemperatureCheck extends StatelessWidget {
  const TemperatureCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GlassPanel(
      padding: const EdgeInsets.all(24),
      border: Border(
        left: BorderSide(color: colorScheme.secondary, width: 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Temperature Check',
                    style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  WhisperText(
                    'How are we all actually doing right now?',
                    fontSize: 13,
                  ),
                ],
              ),
              Icon(
                Icons.thermostat,
                size: 40,
                color: colorScheme.onSurface.withOpacity(0.1),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _MemberStatus(
            avatars: const [
              'https://lh3.googleusercontent.com/aida-public/AB6AXuD_jM2NQheNMKfJQatIhoWh5GEt3llpbhlvKfR4KsmjIJ5fMISmkH_OfyFEGhdpzy3W8YTjaNLQEg-vuSJYO-LdfnARnu43uYWrTn-uxgdYZXjmgV64AgepKwp7WsvmRvBRHD6PUm1-1xvZEuMfgiqa4By5L-AKKKD_PXu-MVZqAFsje6DOFfhJ8z0IqbJ_r3oPWU9qEhr221spRqUFmTJKHHo_qt7APzB1t4U58kxFlGYQaoQ4WZZ5nUEdyse3xEEKpGrHXNnj5SYW',
              'https://lh3.googleusercontent.com/aida-public/AB6AXuD3w3m8_yoUpAYcmBwP9LjnZugq7ead6fMu0xsOH3tQEdtAqKdKH5vN-Op395R4sW3yoWiJ-fTGFiCjF39ZY_l-QkSDXqI6v6D4nJ_jq-ij3wZmeJGtSzkq7Vuee2lMHyRMvWXzcMGdLNVkH_ooiVna8sL9rgIo3XkSnOGvh6BnfpcfHpd-sPyEqJNwGA63zSitD5uq7fUlanj-iv08zZqJVxw-32PYPgftVrBUxYk8W_uF_yModpg4enJ8TL_8PfE2Rziixon0RVPk',
            ],
            extraCount: 3,
            emoji: '🌊',
            dots: 4,
            filledDots: 2,
            accentColor: colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          _MemberStatus(
            avatars: const [
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCjj6e-ZnkN8HnBwYW7F-zRWpyP5Z3OrdNpOHFuRU6LwV6A1U34Jh7txxSYoJJcVXUX7s5qIFX215a1QyPckH7T-SWFYHLgbA3ImilrDb2CWfPz4EY6KFvmeDgDGzwHKDtdbC6eV_fWnAYFuHq-I4EpO8WVWDckPcXa7rWwYpeWkzIHRYc11pKzWhk2RVQSMHWl_qSOKELto67tV-GysiGPtEGlMyUM6TdeIRc8Mi4c5lbhnPQ0vK727nAtnlDEQHnAl7vNtYaTG44D',
            ],
            emoji: '☁️',
            dots: 2,
            filledDots: 1,
            accentColor: colorScheme.tertiary,
          ),
        ],
      ),
    );
  }
}

class _MemberStatus extends StatelessWidget {
  final List<String> avatars;
  final int extraCount;
  final String emoji;
  final int dots;
  final int filledDots;
  final Color accentColor;

  const _MemberStatus({
    required this.avatars,
    this.extraCount = 0,
    required this.emoji,
    required this.dots,
    required this.filledDots,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            for (int i = 0; i < avatars.length; i++)
              Transform.translate(
                offset: Offset(i * -12.0, 0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: colorScheme.surface,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(avatars[i]),
                  ),
                ),
              ),
            if (extraCount > 0)
              Transform.translate(
                offset: Offset(avatars.length * -12.0, 0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: colorScheme.surface,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: colorScheme.secondaryContainer,
                    child: Text(
                      '+$extraCount',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Row(
                children: List.generate(dots, (index) {
                  return Container(
                    margin: const EdgeInsets.only(left: 4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: index < filledDots ? accentColor : accentColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
