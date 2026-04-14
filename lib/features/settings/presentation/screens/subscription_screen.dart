import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../../../../core/subscription/subscription_service.dart';
import '../../../../core/subscription/pricing_display.dart';
import '../../../../core/widgets/glass_panel.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../../../core/widgets/tether_button.dart';
import '../../../../core/widgets/tether_card.dart';
import '../../../../injection_container.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sanctuary Membership'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<EntitlementStatus>(
        future: getIt<ISubscriptionService>().getStatus(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final status = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCurrentTierCard(context, status),
                const SizedBox(height: 48),
                if (status.tier == EntitlementTier.free) ...[
                  Text(
                    'Deepen your connection',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const WhisperText('Unlock the full Tether experience for your Circle.'),
                  const SizedBox(height: 32),
                  _buildPricingOptions(context),
                ] else ...[
                  Text(
                    'Your Membership',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildProBenefits(context),
                  const SizedBox(height: 48),
                  TetherButton(
                    onPressed: () => Purchases.showManageSubscriptions(),
                    style: TetherButtonStyle.secondary,
                    isFullWidth: true,
                    child: const Text('Manage Subscription'),
                  ),
                ],
                const SizedBox(height: 64),
                const Center(
                  child: WhisperText('Tether uses Purchasing Power Parity (PPP)\nto ensure fair global pricing.'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentTierCard(BuildContext context, EntitlementStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    final isPro = status.tier != EntitlementTier.free;

    return TetherCard(
      padding: const EdgeInsets.all(32),
      backgroundColor: isPro ? colorScheme.primary.withOpacity(0.1) : colorScheme.surfaceContainerLow,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isPro ? colorScheme.primary : colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPro ? Icons.verified_user : Icons.person_outline,
              color: isPro ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
              size: 32,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isPro ? 'Oasis Pro' : 'Free Member',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                WhisperText(status.status.toUpperCase()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingOptions(BuildContext context) {
    return Column(
      children: [
        _PricingCard(
          title: 'Monthly Sanctuary',
          productId: 'tether_plus_monthly',
          onTap: () => _purchase('tether_plus_monthly'),
        ),
        const SizedBox(height: 16),
        _PricingCard(
          title: 'Annual Retreat',
          productId: 'tether_plus_annual',
          subtitle: 'Save 33%',
          isHighlighted: true,
          onTap: () => _purchase('tether_plus_annual'),
        ),
      ],
    );
  }

  Widget _buildProBenefits(BuildContext context) {
    return Column(
      children: const [
        _BenefitRow(icon: Icons.all_inclusive, label: 'Unlimited Circles'),
        _BenefitRow(icon: Icons.favorite, label: 'Full Couples Features'),
        _BenefitRow(icon: Icons.family_restroom, label: 'Advanced Family Safety'),
        _BenefitRow(icon: Icons.mic, label: 'Voice Notes & Slow Chat'),
        _BenefitRow(icon: Icons.history, label: 'Extended Memories Lane'),
      ],
    );
  }

  Future<void> _purchase(String productId) async {
    try {
      final offerings = await Purchases.getOfferings();
      final package = offerings.all.values
          .expand((o) => o.availablePackages)
          .firstWhere((p) => p.storeProduct.identifier == productId);
      
      if (package != null) {
        await Purchases.purchasePackage(package);
        getIt<ISubscriptionService>().syncWithProvider();
      }
    } catch (e) {
      // Handle error
    }
  }
}

class _PricingCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String productId;
  final bool isHighlighted;
  final VoidCallback onTap;

  const _PricingCard({
    required this.title,
    this.subtitle,
    required this.productId,
    this.isHighlighted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: GlassPanel(
        padding: const EdgeInsets.all(24),
        opacity: isHighlighted ? 0.15 : 0.05,
        border: isHighlighted ? Border.all(color: colorScheme.primary.withOpacity(0.4), width: 2) : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(subtitle!, style: TextStyle(color: colorScheme.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ],
            ),
            FutureBuilder<String>(
              future: PricingDisplay.getFormattedPrice(productId),
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ?? '...',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BenefitRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
