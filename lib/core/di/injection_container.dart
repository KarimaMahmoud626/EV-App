import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/core/services/battery_data_simulator.dart';
import 'package:ev_app/core/services/location_services.dart';
import 'package:ev_app/core/services/map_navigation_service.dart';
import 'package:ev_app/core/theme/theme_cubit.dart';
import 'package:ev_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ev_app/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:ev_app/features/auth/data/repos/auth_repo.dart';
import 'package:ev_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:ev_app/features/auth/presentation/view_model/bloc/auth_bloc.dart';
import 'package:ev_app/features/battery_monitoring/data/repos/battery_data_repo.dart';
import 'package:ev_app/features/battery_monitoring/data/repos/battery_data_repo_impl.dart';
import 'package:ev_app/features/battery_monitoring/presentation/view_model/cubit/battery_cubit.dart';
import 'package:ev_app/features/charging_stations/data/dataSources/charging_station_remote_ds.dart';
import 'package:ev_app/features/charging_stations/data/dataSources/charging_station_remote_ds_impl.dart';
import 'package:ev_app/features/charging_stations/data/repos/charging_station_repo.dart';
import 'package:ev_app/features/charging_stations/data/repos/charging_station_repo_impl.dart';
import 'package:ev_app/features/charging_stations/presentation/view_model/cubit/charging_station_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

/// Service Locator instance for dependency injection.
///
/// This is the single source of truth for all dependencies in the app.
/// Use `sl<Type>()` to retrieve registered dependencies.
final sl = GetIt.instance;

/// Initializes all dependencies for the application.
///
/// This function should be called once during app startup, before runApp().
/// It registers all services, data sources, repositories, and BLoCs/Cubits
/// in the correct order (dependencies first, dependents later).
///
/// Registration types:
/// - `registerLazySingleton`: Creates instance on first use, keeps same instance
/// - `registerFactory`: Creates new instance every time
///
/// Example usage:
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await initializeDependencies();
///   runApp(MyApp());
/// }
/// ```
Future<void> initializeDependencies() async {
  // ==================== External Dependencies ====================
  // These are third-party services that we don't own

  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => http.Client());

  // ==================== Core Services ====================
  // Shared services used across multiple features

  sl.registerLazySingleton(() => LocationService());
  sl.registerLazySingleton(() => MapNavigationService());
  sl.registerLazySingleton(() => BatteryDataSimulator());

  // ==================== Authentication Feature ====================

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl(), sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(dataSource: sl()));

  // BLoC (Factory - new instance each time it's requested)
  sl.registerFactory(() => AuthBloc(repo: sl()));

  // ==================== Battery Monitoring Feature ====================

  // Repository
  sl.registerLazySingleton<BatteryDataRepo>(() => BatteryDataRepoImpl(sl()));

  // Cubit (Factory - new instance each time)
  sl.registerFactory(() => BatteryCubit(sl()));

  // ==================== Charging Stations Feature ====================

  // Data Source
  sl.registerLazySingleton<ChargingStationRemoteDs>(
    () => ChargingStationRemoteDsImpl(locationService: sl(), client: sl()),
  );

  // Repository
  sl.registerLazySingleton<ChargingStationRepo>(
    () => ChargingStationRepoImpl(remoteDs: sl()),
  );

  // Cubit (Factory - new instance each time)
  sl.registerFactory(() => ChargingStationCubit(sl()));

  // ==================== Global State ====================
  // These are singletons that persist throughout the app lifecycle

  sl.registerLazySingleton(() => ThemeCubit());
}

/// Resets all registered dependencies.
///
/// Useful for testing to ensure a clean state between tests.
/// Should NOT be called in production code.
Future<void> resetDependencies() async {
  await sl.reset();
}
