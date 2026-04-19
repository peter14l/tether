import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'core/config/env_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/time_theme_cubit.dart';
import 'core/theme/time_theme_state.dart';
import 'core/telemetry/telemetry_service.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/settings/presentation/bloc/settings_cubit.dart';
import 'injection_container.dart';

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
      getIt<ITelemetryService>().logError(
        details.exception,
        details.stack ?? StackTrace.empty,
      );
    } catch (e) {
      debugPrint('Telemetry error: $e');
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    try {
      getIt<ITelemetryService>().logError(error, stack);
    } catch (e) {
      debugPrint('Telemetry error: $e');
    }
    return true;
  };

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://bc1753eb3948e1640ebca0654b5a7bce@o4511214683881472.ingest.us.sentry.io/4511214685388800';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      SentryWidget(
        child: BlocProvider(
          create: (context) => getIt<AuthBloc>()..add(AuthCheckRequested()),
          child: const MyApp(),
        ),
      ),
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
