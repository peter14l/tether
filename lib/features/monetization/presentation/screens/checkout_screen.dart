import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/repositories/billing_repository.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isLoading = false;
  PaymentMethod? _selectedMethod;

  Future<void> _handlePurchase(PaymentMethod method) async {
    setState(() {
      _isLoading = true;
      _selectedMethod = method;
    });

    try {
      final billing = GetIt.I<IBillingRepository>();
      final result = await billing.purchasePremium(method: method);

      if (!mounted) return;

      result.fold(
        (failure) => _showSnackBar(failure.message, isError: true),
        (_) => _showSnackBar('Welcome to Tether Plus! 🎉', isError: false),
      );
    } catch (e) {
      if (mounted) {
        _showSnackBar('Something went wrong. Please try again.', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Oasis Pro'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FluentIcons.star_24_filled, size: 80, color: cs.primary),
              const SizedBox(height: 24),
              Text(
                'Unlock Oasis Pro',
                style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'Get unlimited circles, advanced wellness tracking, and custom sanctuary themes.',
                textAlign: TextAlign.center,
                style: tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                ),
                onPressed: () => GetIt.I<IBillingRepository>().showPaywall(),
                child: const Text('View Plans'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Maybe Later'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final ColorScheme cs;
  final TextTheme tt;
  const _HeroSection({required this.cs, required this.tt});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cs.primary, cs.tertiary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(FluentIcons.heart_24_filled, color: cs.onPrimary, size: 36),
        ),
        const SizedBox(height: 16),
        Text(
          'Upgrade to Tether Plus',
          style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Deepen your connections with premium features designed for your closest relationships.',
          style: tt.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(0.7)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FeatureList extends StatelessWidget {
  final ColorScheme cs;
  const _FeatureList({required this.cs});

  static const _features = [
    (FluentIcons.alert_24_regular, 'Unlimited Circles & Canvas spaces'),
    (FluentIcons.emoji_24_regular, 'Advanced Mood Tracking & Wellness insights'),
    (FluentIcons.book_open_24_regular, 'Extended Story duration & memory archives'),
    (FluentIcons.person_support_24_regular, 'Priority support & early feature access'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _features
          .map(
            (f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Icon(f.$1, color: cs.primary, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      f.$2,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _PaymentButton extends StatelessWidget {
  final String label;
  final String sublabel;
  final IconData icon;
  final bool isPrimary;
  final bool isLoading;
  final bool disabled;
  final VoidCallback onTap;
  final ColorScheme cs;
  final TextTheme tt;

  const _PaymentButton({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.isPrimary,
    required this.isLoading,
    required this.disabled,
    required this.onTap,
    required this.cs,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: disabled && !isLoading ? 0.5 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: isPrimary ? cs.primary : cs.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: disabled ? null : onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isPrimary
                        ? cs.onPrimary.withOpacity(0.15)
                        : cs.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isPrimary ? cs.onPrimary : cs.primary,
                          ),
                        )
                      : Icon(
                          icon,
                          color: isPrimary ? cs.onPrimary : cs.primary,
                          size: 20,
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isPrimary ? cs.onPrimary : cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        sublabel,
                        style: tt.bodySmall?.copyWith(
                          color: isPrimary
                              ? cs.onPrimary.withOpacity(0.75)
                              : cs.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  FluentIcons.chevron_right_24_regular,
                  size: 14,
                  color: isPrimary
                      ? cs.onPrimary.withOpacity(0.7)
                      : cs.onSurface.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
