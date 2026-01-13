import 'package:ev_app/features/auth/data/models/user_model.dart';
import 'package:ev_app/features/battery_monitoring/presentation/pages/home/home_view.dart';
import 'package:ev_app/features/charging_stations/presentation/pages/station_view.dart';
import 'package:ev_app/features/history/presentation/pages/history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Main navigation shell using Material 3 NavigationBar.
///
/// This widget provides the primary navigation structure for the app,
/// managing navigation between main feature screens using a bottom navigation bar.
///
/// Features:
/// - Material 3 NavigationBar for modern, accessible navigation
/// - IndexedStack for efficient screen management (only builds visible screen)
/// - Proper BLoC lifecycle management
/// - Semantic labels for accessibility
/// - Haptic feedback on navigation
/// - Smooth animations
/// - Persistent state across tab switches
class NavigationShell extends StatefulWidget {
  const NavigationShell({
    super.key,
    required this.user,
    this.initialIndex = 1, // Default to Battery Status screen
  });

  final UserModel user;
  final int initialIndex;

  @override
  State<NavigationShell> createState() => _NavigationShellState();
}

class _NavigationShellState extends State<NavigationShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  /// Handles navigation item tap with haptic feedback.
  void _onDestinationSelected(int index) {
    if (_currentIndex != index) {
      // Provide haptic feedback for better UX
      HapticFeedback.selectionClick();

      setState(() {
        _currentIndex = index;
      });
    }
  }

  /// Builds the list of navigation destinations.
  List<NavigationDestination> _buildDestinations(ColorScheme colorScheme) {
    return [
      NavigationDestination(
        icon: const Icon(Icons.location_on_outlined),
        selectedIcon: Icon(
          Icons.location_on,
          color: colorScheme.onPrimaryContainer,
        ),
        label: 'Stations',
        tooltip: 'Find nearby charging stations',
      ),
      NavigationDestination(
        icon: const Icon(Icons.battery_charging_full_outlined),
        selectedIcon: Icon(
          Icons.battery_charging_full,
          color: colorScheme.onPrimaryContainer,
        ),
        label: 'Status',
        tooltip: 'View battery status and health',
      ),
      NavigationDestination(
        icon: const Icon(Icons.history_outlined),
        selectedIcon: Icon(
          Icons.history,
          color: colorScheme.onPrimaryContainer,
        ),
        label: 'History',
        tooltip: 'View charging history',
      ),
    ];
  }

  /// Builds the list of screens.
  ///
  /// Uses keys to preserve state across rebuilds.
  List<Widget> _buildScreens() {
    return [
      const StationView(key: ValueKey('station_view')),
      HomeView(key: const ValueKey('home_view'), user: widget.user),
      const HistoryView(key: ValueKey('history_view')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screens = _buildScreens();

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _buildDestinations(colorScheme),
        elevation: 3,
        // Material 3 styling
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primaryContainer,
        surfaceTintColor: colorScheme.surface,
        // Accessibility
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
