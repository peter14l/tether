import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../domain/repositories/billing_repository.dart';

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
        title: const Text('Tether Plus'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero section
              _HeroSection(cs: cs, tt: tt),

              const SizedBox(height: 32),

              // Feature pills
              _FeatureList(cs: cs),

              const Spacer(),

              // Pricing
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cs.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.outline.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Text(
                      '₹499 / month',
                      style: tt.headlineMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Cancel anytime · No hidden fees',
                      style: tt.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Primary: App Store / Google Play button
              _PaymentButton(
                label: 'Pay via App Store / Google Play',
                sublabel: 'Managed by Apple or Google',
                icon: Icons.shop_outlined,
                isPrimary: true,
                isLoading: _isLoading && _selectedMethod == PaymentMethod.native,
                disabled: _isLoading,
                onTap: () => _handlePurchase(PaymentMethod.native),
                cs: cs,
                tt: tt,
              ),

              const SizedBox(height: 12),

              // Alternative: Razorpay
              _PaymentButton(
                label: 'Alternative Checkout',
                sublabel: 'Pay with UPI, Cards, Net Banking via Razorpay',
                icon: Icons.payment_outlined,
                isPrimary: false,
                isLoading: _isLoading && _selectedMethod == PaymentMethod.razorpay,
                disabled: _isLoading,
                onTap: () => _handlePurchase(PaymentMethod.razorpay),
                cs: cs,
                tt: tt,
              ),

              const SizedBox(height: 20),

              Text(
                'By subscribing, you agree to our Terms of Service and Privacy Policy.',
                textAlign: TextAlign.center,
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurface.withOpacity(0.45),
                ),
              ),

              const SizedBox(height: 8),
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
          child: Icon(Icons.favorite_rounded, color: cs.onPrimary, size: 36),
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
    (Icons.circle_notifications_outlined, 'Unlimited Circles & Canvas spaces'),
    (Icons.mood_outlined, 'Advanced Mood Tracking & Wellness insights'),
    (Icons.auto_stories_outlined, 'Extended Story duration & memory archives'),
    (Icons.support_agent_outlined, 'Priority support & early feature access'),
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
                  Icons.arrow_forward_ios_rounded,
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
