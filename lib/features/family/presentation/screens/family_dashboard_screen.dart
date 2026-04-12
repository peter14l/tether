import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../bloc/family_safety_cubit.dart';
import '../bloc/family_safety_state.dart';
import '../widgets/sos_alert_overlay.dart';

class FamilyDashboardScreen extends StatelessWidget {
  final String circleId;
  const FamilyDashboardScreen({super.key, required this.circleId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FamilySafetyCubit>()..listenToSosAlerts(circleId)..loadSafetyChecks(circleId),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Family Circle', style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Members', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _buildMemberCard(context, 'Grandma', 'Need Quiet 🤫'),
                  _buildMemberCard(context, 'Dad', 'Happy 😊'),
                  const SizedBox(height: 32),
                  Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  _ActionTile(
                    icon: Icons.history_edu,
                    label: 'Heritage Corner',
                    onTap: () => context.push('/family/$circleId/heritage'),
                  ),
                  _ActionTile(
                    icon: Icons.auto_stories,
                    label: 'Bedtime Stories',
                    onTap: () => context.push('/family/$circleId/stories'),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<FamilySafetyCubit, FamilySafetyState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade50,
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () => context.read<FamilySafetyCubit>().triggerSos(circleId),
                          child: const Text('TRIGGER SOS (Triple-tap mock)'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<FamilySafetyCubit, FamilySafetyState>(
              builder: (context, state) {
                if (state.activeAlerts.isNotEmpty) {
                  return SosAlertOverlay(
                    alert: state.activeAlerts.first,
                    onResolve: () {
                      // Mock resolve
                    },
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

  Widget _buildMemberCard(BuildContext context, String name, String mood) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(name[0])),
        title: Text(name),
        subtitle: Text(mood),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        onTap: onTap,
      ),
    );
  }
}
