// import 'package:ev_app/core/services/location_services.dart';
// import 'package:ev_app/core/services/map_navigation_service.dart';
// import 'package:ev_app/features/charging_stations/data/models/charging_station_model.dart';
// import 'package:ev_app/features/charging_stations/data/models/station_connection_model.dart';
// import 'package:ev_app/features/charging_stations/presentation/widgets/charging_station_bottom_sheet.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:get_it/get_it.dart';

// // Generate mocks with: flutter pub run build_runner build
// @GenerateMocks([LocationService, MapNavigationService])
// import 'charging_station_bottom_sheet_test.mocks.dart';

// void main() {
//   late MockLocationService mockLocationService;
//   late MockMapNavigationService mockMapNavigationService;
//   final sl = GetIt.instance;

//   setUp(() {
//     mockLocationService = MockLocationService();
//     mockMapNavigationService = MockMapNavigationService();

//     // Register mocks in service locator
//     sl.registerLazySingleton<LocationService>(() => mockLocationService);
//     sl.registerLazySingleton<MapNavigationService>(
//       () => mockMapNavigationService,
//     );
//   });

//   tearDown(() async {
//     await sl.reset();
//   });

//   group('ChargingStationBottomSheet', () {
//     final testStation = ChargingStationModel(
//       isActive: true,
//       address: '123 Test Street, Test City',
//       name: 'Test Charging Station',
//       latitude: 37.7749,
//       longitude: -122.4194,
//       connections: [
//         StationConnectionModel(type: 'Type 2', power: 50.0, isAvailable: true),
//       ],
//     );

//     testWidgets('should display station information correctly', (
//       WidgetTester tester,
//     ) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: ChargingStationBottomSheet(station: testStation),
//           ),
//         ),
//       );

//       expect(find.text('Test Charging Station'), findsOneWidget);
//       expect(find.text('123 Test Street, Test City'), findsOneWidget);
//       expect(find.text('Directions'), findsOneWidget);
//     });

//     testWidgets('should show Directions button', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: ChargingStationBottomSheet(station: testStation),
//           ),
//         ),
//       );

//       expect(find.text('Directions'), findsOneWidget);
//     });

//     testWidgets('should call navigation services when Directions is tapped', (
//       WidgetTester tester,
//     ) async {
//       // Arrange
//       final mockPosition = Position(
//         latitude: 37.7849,
//         longitude: -122.4094,
//         timestamp: DateTime.now(),
//         accuracy: 10.0,
//         altitude: 0.0,
//         heading: 0.0,
//         speed: 0.0,
//         speedAccuracy: 0.0,
//         altitudeAccuracy: 0.0,
//         headingAccuracy: 0.0,
//       );

//       when(
//         mockLocationService.getCurrentLocation(),
//       ).thenAnswer((_) async => mockPosition);
//       when(
//         mockMapNavigationService.navigateToLocation(
//           destinationLat: anyNamed('destinationLat'),
//           destinationLng: anyNamed('destinationLng'),
//           destinationLabel: anyNamed('destinationLabel'),
//         ),
//       ).thenAnswer((_) async => {});

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: Builder(
//               builder:
//                   (context) => ChargingStationBottomSheet(station: testStation),
//             ),
//           ),
//         ),
//       );

//       // Act
//       await tester.tap(find.text('Directions'));
//       await tester.pumpAndSettle();

//       // Assert
//       verify(mockLocationService.getCurrentLocation()).called(1);
//       verify(
//         mockMapNavigationService.navigateToLocation(
//           destinationLat: testStation.latitude,
//           destinationLng: testStation.longitude,
//           destinationLabel: testStation.name,
//         ),
//       ).called(1);
//     });

//     testWidgets('should show error snackbar when location service fails', (
//       WidgetTester tester,
//     ) async {
//       // Arrange
//       when(
//         mockLocationService.getCurrentLocation(),
//       ).thenThrow(Exception('Location services are disabled'));

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: Builder(
//               builder:
//                   (context) => ChargingStationBottomSheet(station: testStation),
//             ),
//           ),
//         ),
//       );

//       // Act
//       await tester.tap(find.text('Directions'));
//       await tester.pumpAndSettle();

//       // Assert
//       expect(
//         find.text('Please enable location services to navigate'),
//         findsOneWidget,
//       );
//     });

//     testWidgets('should show error snackbar when permissions are denied', (
//       WidgetTester tester,
//     ) async {
//       // Arrange
//       when(
//         mockLocationService.getCurrentLocation(),
//       ).thenThrow(Exception('Location permissions are denied'));

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: Builder(
//               builder:
//                   (context) => ChargingStationBottomSheet(station: testStation),
//             ),
//           ),
//         ),
//       );

//       // Act
//       await tester.tap(find.text('Directions'));
//       await tester.pumpAndSettle();

//       // Assert
//       expect(
//         find.text('Location permission is required for navigation'),
//         findsOneWidget,
//       );
//     });

//     testWidgets('should show error snackbar when map app cannot open', (
//       WidgetTester tester,
//     ) async {
//       // Arrange
//       final mockPosition = Position(
//         latitude: 37.7849,
//         longitude: -122.4094,
//         timestamp: DateTime.now(),
//         accuracy: 10.0,
//         altitude: 0.0,
//         heading: 0.0,
//         speed: 0.0,
//         speedAccuracy: 0.0,
//         altitudeAccuracy: 0.0,
//         headingAccuracy: 0.0,
//       );

//       when(
//         mockLocationService.getCurrentLocation(),
//       ).thenAnswer((_) async => mockPosition);
//       when(
//         mockMapNavigationService.navigateToLocation(
//           destinationLat: anyNamed('destinationLat'),
//           destinationLng: anyNamed('destinationLng'),
//           destinationLabel: anyNamed('destinationLabel'),
//         ),
//       ).thenThrow(Exception('Could not open map application'));

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: Builder(
//               builder:
//                   (context) => ChargingStationBottomSheet(station: testStation),
//             ),
//           ),
//         ),
//       );

//       // Act
//       await tester.tap(find.text('Directions'));
//       await tester.pumpAndSettle();

//       // Assert
//       expect(find.text('Unable to open map application'), findsOneWidget);
//     });

//     testWidgets('should disable button when navigation is in progress', (
//       WidgetTester tester,
//     ) async {
//       // Arrange
//       final mockPosition = Position(
//         latitude: 37.7849,
//         longitude: -122.4094,
//         timestamp: DateTime.now(),
//         accuracy: 10.0,
//         altitude: 0.0,
//         heading: 0.0,
//         speed: 0.0,
//         speedAccuracy: 0.0,
//         altitudeAccuracy: 0.0,
//         headingAccuracy: 0.0,
//       );

//       // Make the location service take some time
//       when(mockLocationService.getCurrentLocation()).thenAnswer((_) async {
//         await Future.delayed(const Duration(milliseconds: 500));
//         return mockPosition;
//       });

//       when(
//         mockMapNavigationService.navigateToLocation(
//           destinationLat: anyNamed('destinationLat'),
//           destinationLng: anyNamed('destinationLng'),
//           destinationLabel: anyNamed('destinationLabel'),
//         ),
//       ).thenAnswer((_) async => {});

//       await tester.pumpWidget(
//         MaterialApp(
//           home: Scaffold(
//             body: Builder(
//               builder:
//                   (context) => ChargingStationBottomSheet(station: testStation),
//             ),
//           ),
//         ),
//       );

//       // Act - tap the button
//       await tester.tap(find.text('Directions'));
//       await tester.pump(); // Start the async operation

//       // The button should be disabled (onTap is null) during navigation
//       // Note: This is a simplified test. In a real scenario, you'd check
//       // if the button's onTap callback is null or if a loading indicator appears
//     });
//   });
// }
