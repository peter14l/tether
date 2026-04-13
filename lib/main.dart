import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/env_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/time_theme_cubit.dart';
import 'core/theme/time_theme_state.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'injection_container.dart';

import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'core/telemetry/telemetry_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try to initialize Firebase
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase not configured, skipping initialization.');
  }

  // Initialize Supabase
  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabasePublishableKey,
  );

  // Initialize Dependency Injection
  await configureDependencies();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    try {
      getIt<ITelemetryService>().logError(details.exception, details.stack ?? StackTrace.empty);
    } catch (_) {}
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    try {
      getIt<ITelemetryService>().logError(error, stack);
    } catch (_) {}
    return true;
  };

  runApp(
    BlocProvider(
      create: (context) => getIt<AuthBloc>()..add(AuthCheckRequested()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => getIt<TimeThemeCubit>())],
      child: BlocBuilder<TimeThemeCubit, TimeThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            title: 'Tether',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getTheme(
              state.slot,
              isDarkModeOverride: state.isDarkModeOverride,
            ),
            routerConfig: goRouter,
          );
        },
      ),
    );
  }
}
