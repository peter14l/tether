import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../../../../core/widgets/squircle_avatar.dart';
import '../../../../core/widgets/whisper_text.dart';
import '../../../circles/presentation/bloc/circle_member_cubit.dart';
import '../../../circles/presentation/bloc/circle_member_state.dart';
import '../bloc/family_safety_cubit.dart';
import '../bloc/family_safety_state.dart';
import '../widgets/sos_alert_overlay.dart';

class FamilyDashboardScreen extends StatelessWidget {
  final String circleId;
  const FamilyDashboardScreen({super.key, required this.circleId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<FamilySafetyCubit>()..listenToSosAlerts(circleId)..loadSafetyChecks(circleId)),
        BlocProvider(create: (context) => getIt<CircleMemberCubit>()..loadMembers(circleId)),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.surface.withOpacity(0.8),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorScheme.primary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Tether',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.primary,
              fontSize: 24,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SquircleAvatar(
                imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAFZi4AMlXlcZsUsGOSehPSf0Hzi7jA-7Xn18nzU-iBOqly34PpcHperzFKdfcYbR6mukDLBTxGTnkazJbNmm4kE9TGC4fec1pnrLesabuJBhrNtk5AehvALUtu1aee1qH3Z2HpW0mFNbJprR0pF9M-n9iyUVljo0gCwibTQ03uk4hMcrJvQ-AlZB0ayG_2wt2dCR9opnUg2LTew9UH032_JtWg4Vs5uZrg2JS1f-v0B5jhR-zf29WmVjUGhPRGYsN164ThQn23shLq',
                size: 40,
                borderColor: colorScheme.primary.withOpacity(0.2),
                borderWidth: 2,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const WhisperText('FAMILY SANCTUARY', uppercase: true),
                          const SizedBox(height: 4),
                          Text('The Thompson Circle', style: theme.textTheme.headlineLarge?.copyWith(fontSize: 32)),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: const Text("I'm Okay ✓"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _FamilyBentoGrid(circleId: circleId),
                  const SizedBox(height: 48),
                  _SafetyCheckSection(),
                  const SizedBox(height: 48),
                  _EmergencySOS(circleId: circleId),
                  const SizedBox(height: 48),
                  _HeritageCornerPreview(),
                  const SizedBox(height: 48),
                  _GrandparentEasyView(),
                ],
              ),
            ),
            BlocBuilder<FamilySafetyCubit, FamilySafetyState>(
              builder: (context, state) {
                if (state.activeAlerts.isNotEmpty) {
                  return SosAlertOverlay(
                    alert: state.activeAlerts.first,
                    onResolve: () {},
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FamilyBentoGrid extends StatelessWidget {
  final String circleId;
  const _FamilyBentoGrid({required this.circleId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _BentoTile(
          icon: Icons.rss_feed,
          title: 'Recent Feed',
          subtitle: '12 new moments',
          color: colorScheme.primary,
          onTap: () {},
        ),
        _BentoTile(
          icon: Icons.health_and_safety,
          title: 'Safety Check',
          color: colorScheme.tertiary,
          onTap: () {},
        ),
        _BentoTile(
          icon: Icons.notifications_active,
          title: 'Reminders',
          color: colorScheme.secondary,
          onTap: () {},
        ),
        _BentoTile(
          icon: Icons.history_edu,
          title: 'Heritage',
          color: colorScheme.primary,
          onTap: () => context.push('/family/$circleId/heritage'),
        ),
        _BentoTile(
          icon: Icons.location_on,
          title: 'Location',
          color: colorScheme.tertiary,
          onTap: () {},
        ),
      ],
    );
  }
}

class _BentoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color color;
  final VoidCallback onTap;

  const _BentoTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                if (subtitle != null)
                  WhisperText(subtitle!, fontSize: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyCheckSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1A10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.tertiary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: colorScheme.tertiary, size: 32),
              const SizedBox(width: 12),
              Text('Safety Check Active', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20, color: colorScheme.tertiary)),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Unusual activity detected near the coast. Please confirm your status to reassure the circle.',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.check),
                  label: const Text("I'm Safe ✓"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D4A3E),
                    foregroundColor: const Color(0xFF86EFAC),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Need Help'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmergencySOS extends StatelessWidget {
  final String circleId;
  const _EmergencySOS({required this.circleId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.primary.withOpacity(0.2), width: 4),
                ),
              ),
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withOpacity(0.1),
                ),
                child: Center(
                  child: Text(
                    'SOS',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Send SOS to Family?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const WhisperText('This will alert all circle members', textAlign: TextAlign.center),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => context.read<FamilySafetyCubit>().triggerSos(circleId),
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            child: const Text('Send Now'),
          ),
        ],
      ),
    );
  }
}

class _HeritageCornerPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WhisperText('PRESERVING LEGACY', uppercase: true),
        const SizedBox(height: 4),
        Text('Heritage Corner', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 28)),
        const SizedBox(height: 24),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              _HeritageCard(
                title: 'Nana’s first piano recital, 1954',
                subtitle: 'Before I was born',
                imageUrl: 'https://via.placeholder.com/300x400',
                rotation: -0.02,
              ),
              _HeritageCard(
                title: 'The old farmhouse in Cork',
                subtitle: 'Family Roots',
                imageUrl: 'https://via.placeholder.com/300x400',
                rotation: 0.04,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeritageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final double rotation;

  const _HeritageCard({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 24),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF2D2420),
          boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, 10))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 0.8,
              child: Container(
                color: Colors.black,
                child: ColorFiltered(
                  colorFilter: const ColorFilter.matrix([
                    0.393, 0.769, 0.189, 0, 0,
                    0.349, 0.686, 0.168, 0, 0,
                    0.272, 0.534, 0.131, 0, 0,
                    0, 0, 0, 1, 0,
                  ]),
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(subtitle, style: const TextStyle(color: Colors.white24, fontSize: 10, fontStyle: FontStyle.italic)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16, fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}

class _GrandparentEasyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text('Hello, Martha', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _EasyButton(icon: Icons.groups, label: 'See Family', color: colorScheme.primaryContainer),
              _EasyButton(icon: Icons.call, label: 'Call Someone', color: colorScheme.secondary),
              _EasyButton(icon: Icons.photo_library, label: 'New Photo', color: colorScheme.tertiary),
              _EasyButton(icon: Icons.check_circle, label: "I'm Okay", color: const Color(0xFF86EFAC)),
            ],
          ),
        ],
      ),
    );
  }
}

class _EasyButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _EasyButton({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.black87),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
        ],
      ),
    );
  }
}
