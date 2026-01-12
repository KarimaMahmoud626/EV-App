import 'package:ev_app/core/config/env_config.dart';
import 'package:ev_app/core/di/injection_container.dart';
import 'package:ev_app/core/routes/app_routes.dart';
import 'package:ev_app/core/routes/route_generator.dart';
import 'package:ev_app/core/theme/app_theme.dart';
import 'package:ev_app/core/theme/theme_cubit.dart';
import 'package:ev_app/features/battery_monitoring/presentation/view_model/cubit/battery_cubit.dart';
import 'package:ev_app/features/charging_stations/presentation/view_model/cubit/charging_station_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Main entry point of the EV-App application.
///
/// Initializes Firebase, loads environment variables, sets up dependency injection,
/// and runs the app.
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  // Validate required environment variables
  EnvConfig.validate();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize dependency injection
  await initializeDependencies();

  // Run the app
  runApp(const EvApp());
}

/// Root widget of the application.
///
/// Provides global BLoCs and sets up theming and routing.
/// BLoCs are provided at the app level to ensure proper lifecycle management
/// and state persistence across navigation.
class EvApp extends StatelessWidget {
  const EvApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Theme management - global
        BlocProvider(create: (context) => sl<ThemeCubit>()),
        // Battery monitoring - global (persists across navigation)
        BlocProvider(
          create: (context) => sl<BatteryCubit>()..startMonitoring(),
        ),
        // Charging stations - global (persists across navigation)
        BlocProvider(
          create: (context) => sl<ChargingStationCubit>()..getStations(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'EV Companion',

            // Theme configuration
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: mode,

            // Navigation configuration
            initialRoute: AppRoutes.initialRoute,
            onGenerateRoute: RouteGenerator.generateRoute,

            // Navigation observer for analytics (optional)
            // navigatorObservers: [
            //   // Add analytics observer here if needed
            // ],
          );
        },
      ),
    );
  }
}
