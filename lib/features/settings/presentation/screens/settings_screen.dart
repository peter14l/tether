import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tether/core/widgets/squircle_avatar.dart';
import 'package:tether/core/widgets/whisper_text.dart';
import 'package:tether/core/widgets/glass_panel.dart';
import 'package:tether/core/widgets/tether_button.dart';
import 'package:tether/core/widgets/tether_card.dart';
import 'package:tether/injection_container.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tether/features/monetization/domain/repositories/billing_repository.dart';
import 'package:tether/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:tether/features/settings/presentation/bloc/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingsCubit>()..loadSettings(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            backgroundColor: colorScheme.surface.withOpacity(0.01),
            surfaceTintColor: Colors.transparent,
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ColorFilter.mode(colorScheme.surface.withOpacity(0.8), BlendMode.srcOver),
                child: Container(color: Colors.transparent),
              ),
            ),
            title: Text(
              'Sanctuary Settings',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
                fontStyle: FontStyle.italic,
                fontSize: 24,
                letterSpacing: -0.5,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) {
                    return SquircleAvatar(
                      imageUrl: state.user?.avatarUrl ?? '',
                      size: 36,
                      borderColor: colorScheme.primary.withOpacity(0.2),
                      borderWidth: 2,
                    );
                  },
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                if (state.isLoading && state.user == null) {
                  return const Center(child: Padding(
                    padding: EdgeInsets.all(64.0),
                    child: CircularProgressIndicator(),
                  ));
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _ProfileSection(),
                      const SizedBox(height: 48),
                      const _NotificationSection(),
                      const SizedBox(height: 48),
                      const _WellnessInterfaceSection(),
                      const SizedBox(height: 48),
                      const _PrivacySecuritySection(),
                      const SizedBox(height: 48),
                      const _SubscriptionSection(),
                      const SizedBox(height: 64),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Sign Out'),
                                content: const Text('Are you sure you want to leave your Sanctuary?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Stay'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true && context.mounted) {
                              await context.read<SettingsCubit>().signOut();
                              if (context.mounted) {
                                context.go('/login');
                              }
                            }
                          },
                          child: Text(
                            'Sign Out',
                            style: TextStyle(color: colorScheme.error),
                          ),
                        ),
                      ),
                      const SizedBox(height: 120),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsCubit>().state;
    final user = state.user;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WhisperText('ACCOUNT & PROFILE'),
        const SizedBox(height: 24),
        TetherCard(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  try {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                    if (image != null && context.mounted) {
                      final bytes = await image.readAsBytes();
                      final fileExt = image.path.split('.').last;
                      final fileName = '${user?.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExt';
                      
                      // Show loading snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Uploading avatar...')),
                      );

                      final supabase = Supabase.instance.client;
                      await supabase.storage
                          .from('avatars')
                          .uploadBinary(fileName, bytes);
                      
                      final imageUrl = supabase.storage
                          .from('avatars')
                          .getPublicUrl(fileName);

                      if (context.mounted) {
                        context.read<SettingsCubit>().updateProfile(avatarUrl: imageUrl);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Avatar updated successfully')),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update avatar: $e')),
                      );
                    }
                  }
                },
                child: Stack(
                  children: [
                    SquircleAvatar(
                      imageUrl: user?.avatarUrl ?? '',
                      size: 80,
                      borderColor: colorScheme.primary.withOpacity(0.2),
                      borderWidth: 2,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.edit, size: 12, color: colorScheme.onPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => _editField(context, 'Display Name', user?.displayName, (val) {
                        context.read<SettingsCubit>().updateProfile(displayName: val);
                      }),
                      child: Text(
                        user?.displayName ?? 'Anonymous',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        WhisperText('@${user?.username ?? 'user'}'),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => _editField(context, 'Pronouns', user?.pronouns, (val) {
                            context.read<SettingsCubit>().updateProfile(pronouns: val);
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              user?.pronouns ?? 'add pronouns',
                              style: TextStyle(
                                fontSize: 10,
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _editField(context, 'Bio', user?.bio, (val) {
                        context.read<SettingsCubit>().updateProfile(bio: val);
                      }),
                      child: Text(
                        user?.bio ?? 'No bio yet. Tap to add one.',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _editField(BuildContext context, String label, String? current, Function(String) onSave) {
    final controller = TextEditingController(text: current);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
        child: GlassPanel(
          padding: const EdgeInsets.all(32),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Edit $label', style: Theme.of(sheetContext).textTheme.headlineSmall),
              const SizedBox(height: 24),
              TextField(
                controller: controller,
                maxLines: label == 'Bio' ? 3 : 1,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter your $label...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 24),
              TetherButton(
                onPressed: () {
                  onSave(controller.text);
                  Navigator.pop(sheetContext);
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationSection extends StatelessWidget {
  const _NotificationSection();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsCubit>().state;
    final cubit = context.read<SettingsCubit>();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WhisperText('NOTIFICATIONS'),
        const SizedBox(height: 24),
        _SwitchTile(
          label: 'Reflection Reminders',
          subtitle: 'Daily nudge to look back.',
          value: state.reflectionReminders,
          onChanged: cubit.toggleReflectionReminders,
        ),
        const SizedBox(height: 12),
        _SwitchTile(
          label: 'Gratitude Prompts',
          subtitle: 'Thoughtful questions to start your day.',
          value: state.gratitudePrompts,
          onChanged: cubit.toggleGratitudePrompts,
        ),
        const SizedBox(height: 12),
        _SwitchTile(
          label: 'Emergency SOS Alerts',
          subtitle: 'Bypass Do Not Disturb for critical safety.',
          value: state.sosAlerts,
          onChanged: cubit.toggleSosAlerts,
          isCritical: true,
        ),
      ],
    );
  }
}

class _WellnessInterfaceSection extends StatelessWidget {
  const _WellnessInterfaceSection();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsCubit>().state;
    final cubit = context.read<SettingsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WhisperText('WELLNESS & INTERFACE'),
        const SizedBox(height: 24),
        _SwitchTile(
          label: 'Night Mode',
          subtitle: 'Force dark theme or follow time of day.',
          value: state.isDarkMode,
          onChanged: (val) {
            cubit.toggleDarkMode(val);
            if (val) {
              context.read<TimeThemeCubit>().toggleDarkMode(enabled: true);
            } else {
              context.read<TimeThemeCubit>().clearDarkModeOverride();
            }
          },
        ),
        const SizedBox(height: 12),
        _SwitchTile(
          label: 'Haptic Breathing',
          subtitle: 'Physical pulses during exercises.',
          value: state.hapticBreathing,
          onChanged: cubit.toggleHapticBreathing,
        ),
      ],
    );
  }
}

class _PrivacySecuritySection extends StatelessWidget {
  const _PrivacySecuritySection();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsCubit>().state;
    final cubit = context.read<SettingsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WhisperText('PRIVACY & SECURITY'),
        const SizedBox(height: 24),
        _SwitchTile(
          label: 'Biometric Lock',
          subtitle: 'Require Face ID or PIN to open.',
          value: state.biometricLock,
          onChanged: cubit.toggleBiometricLock,
        ),
        const SizedBox(height: 12),
        TetherCard(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              const Icon(Icons.enhanced_encryption_outlined, color: Colors.green),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('End-to-End Encryption', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    WhisperText('All private entries are secured on-device.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SubscriptionSection extends StatelessWidget {
  const _SubscriptionSection();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WhisperText('SUBSCRIPTION'),
        const SizedBox(height: 24),
        StreamBuilder<CustomerInfo>(
          stream: getIt<IBillingRepository>().customerInfoStream,
          builder: (context, snapshot) {
            final isPro = snapshot.data?.entitlements.all['Oasis Pro']?.isActive ?? false;
            
            return TetherCard(
              padding: const EdgeInsets.all(24),
              backgroundColor: isPro ? Colors.amber.withOpacity(0.05) : null,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        isPro ? Icons.verified_rounded : Icons.star_outline,
                        color: isPro ? Colors.amber : colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isPro ? 'Oasis Pro Active' : 'Tether Basic',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            WhisperText(isPro 
                              ? 'Thank you for supporting Sanctuary.'
                              : 'Unlock unlimited circles & advanced wellness.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (isPro)
                    TetherButton(
                      style: TetherButtonStyle.secondary,
                      isFullWidth: true,
                      onPressed: () => getIt<IBillingRepository>().showCustomerCenter(),
                      child: const Text('Manage Subscription'),
                    )
                  else
                    TetherButton(
                      isHighPriority: true,
                      isFullWidth: true,
                      onPressed: () => getIt<IBillingRepository>().showPaywall(),
                      child: const Text('Upgrade to Oasis Pro'),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final Function(bool) onChanged;
  final bool isCritical;

  const _SwitchTile({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isCritical = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TetherCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                WhisperText(subtitle),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: isCritical ? colorScheme.error : colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
