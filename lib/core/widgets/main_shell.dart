import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottom_nav_bar.dart';
import 'biometric_guard.dart';
import '../../features/settings/presentation/bloc/settings_cubit.dart';
import '../../features/settings/presentation/bloc/settings_state.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        Widget content = Scaffold(
          body: child,
          extendBody: true,
          bottomNavigationBar: const TetherBottomNavBar(),
        );

        if (state.biometricLock) {
          content = BiometricGuard(child: content);
        }

        return content;
      },
    );
  }
}
