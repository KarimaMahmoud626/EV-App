import 'package:ev_app/core/theme/theme_cubit.dart';
import 'package:ev_app/features/auth/data/models/user_model.dart';
import 'package:ev_app/features/auth/presentation/view_model/bloc/auth_bloc.dart';
import 'package:ev_app/features/settings/presentation/view_model/cubit/settings_cubit.dart';
import 'package:ev_app/features/settings/presentation/view_model/cubit/settings_state.dart';
import 'package:ev_app/features/settings/presentation/widgets/profile_header.dart';
import 'package:ev_app/features/settings/presentation/widgets/settings_item.dart';
import 'package:ev_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main settings screen displaying user profile and app settings.
///
/// Features:
/// - User profile information
/// - App preferences (notifications, units)
/// - Theme selection
/// - Account management (logout)
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingsCubit()..loadPreferences(),
      child: _SettingsViewBody(user: user),
    );
  }
}

class _SettingsViewBody extends StatelessWidget {
  const _SettingsViewBody({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface.withValues(alpha: 0.5),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SettingsError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: colorScheme.error),
              ),
            );
          }

          if (state is SettingsLoaded) {
            return _buildContent(context, state);
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, SettingsLoaded state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header
          ProfileHeader(user: user),

          // Preferences Section
          SettingsSection(
            title: 'PREFERENCES',
            children: [
              _buildNotificationsToggle(context, state),
              _buildDivider(context),
              _buildThemeSelector(context),
            ],
          ),

          // Units Section
          SettingsSection(
            title: 'UNITS',
            children: [
              _buildDistanceUnitSelector(context, state),
              _buildDivider(context),
              _buildTemperatureUnitSelector(context, state),
            ],
          ),

          // Account Section
          SettingsSection(
            title: 'ACCOUNT',
            children: [
              _buildAboutItem(context),
              _buildDivider(context),
              _buildLogoutItem(context),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildNotificationsToggle(BuildContext context, SettingsLoaded state) {
    return SettingsItem(
      icon: Icons.notifications_outlined,
      title: 'Notifications',
      subtitle: 'Battery alerts and charging reminders',
      trailing: Switch(
        value: state.preferences.notificationsEnabled,
        onChanged: (value) {
          context.read<SettingsCubit>().toggleNotifications(value);
        },
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return SettingsItem(
          icon: Icons.palette_outlined,
          title: 'Theme',
          subtitle: _getThemeLabel(themeMode),
          trailing: Icon(Icons.chevron_right),
          onTap: () => _showThemeDialog(context, themeMode),
        );
      },
    );
  }

  Widget _buildDistanceUnitSelector(
    BuildContext context,
    SettingsLoaded state,
  ) {
    return SettingsItem(
      icon: Icons.straighten_outlined,
      title: 'Distance Unit',
      subtitle: state.preferences.distanceUnit.toUpperCase(),
      trailing: Icon(Icons.chevron_right),
      onTap: () => _showDistanceUnitDialog(context, state),
    );
  }

  Widget _buildTemperatureUnitSelector(
    BuildContext context,
    SettingsLoaded state,
  ) {
    return SettingsItem(
      icon: Icons.thermostat_outlined,
      title: 'Temperature Unit',
      subtitle: state.preferences.temperatureUnit == 'celsius' ? '°C' : '°F',
      trailing: Icon(Icons.chevron_right),
      onTap: () => _showTemperatureUnitDialog(context, state),
    );
  }

  Widget _buildAboutItem(BuildContext context) {
    return SettingsItem(
      icon: Icons.info_outline,
      title: 'About',
      subtitle: 'Version 1.0.0',
      trailing: Icon(Icons.chevron_right),
      onTap: () => _showAboutDialog(context),
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SettingsItem(
      icon: Icons.logout,
      title: 'Logout',
      subtitle: 'Sign out of your account',
      trailing: Icon(Icons.chevron_right, color: colorScheme.error),
      onTap: () => _showLogoutDialog(context),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      indent: 56,
      endIndent: 16,
      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
    );
  }

  String _getThemeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  void _showThemeDialog(BuildContext context, ThemeMode currentMode) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Select Theme'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildThemeOption(
                  context,
                  'Light',
                  ThemeMode.light,
                  currentMode,
                ),
                _buildThemeOption(context, 'Dark', ThemeMode.dark, currentMode),
                _buildThemeOption(
                  context,
                  'System',
                  ThemeMode.system,
                  currentMode,
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    String label,
    ThemeMode mode,
    ThemeMode currentMode,
  ) {
    return RadioListTile<ThemeMode>(
      title: Text(label),
      value: mode,
      groupValue: currentMode,
      onChanged: (value) {
        if (value != null) {
          switch (value) {
            case ThemeMode.light:
              context.read<ThemeCubit>().setLight();
              break;
            case ThemeMode.dark:
              context.read<ThemeCubit>().setDark();
              break;
            case ThemeMode.system:
              context.read<ThemeCubit>().setSystem();
              break;
          }
          Navigator.pop(context);
        }
      },
    );
  }

  void _showDistanceUnitDialog(BuildContext context, SettingsLoaded state) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Distance Unit'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('Kilometers (km)'),
                  value: 'km',
                  groupValue: state.preferences.distanceUnit,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<SettingsCubit>().updateDistanceUnit(value);
                      Navigator.pop(dialogContext);
                    }
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Miles (mi)'),
                  value: 'miles',
                  groupValue: state.preferences.distanceUnit,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<SettingsCubit>().updateDistanceUnit(value);
                      Navigator.pop(dialogContext);
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showTemperatureUnitDialog(BuildContext context, SettingsLoaded state) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Temperature Unit'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  title: const Text('Celsius (°C)'),
                  value: 'celsius',
                  groupValue: state.preferences.temperatureUnit,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<SettingsCubit>().updateTemperatureUnit(
                        value,
                      );
                      Navigator.pop(dialogContext);
                    }
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Fahrenheit (°F)'),
                  value: 'fahrenheit',
                  groupValue: state.preferences.temperatureUnit,
                  onChanged: (value) {
                    if (value != null) {
                      context.read<SettingsCubit>().updateTemperatureUnit(
                        value,
                      );
                      Navigator.pop(dialogContext);
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'EV Companion',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2026 EV Companion App',
      children: [
        const SizedBox(height: 16),
        const Text(
          'A comprehensive mobile companion for electric vehicle owners, '
          'providing real-time battery monitoring, charging station discovery, '
          'and usage analytics.',
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<AuthBloc>().add(LogoutRequested());
                },
                child: Text(
                  'Logout',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ],
          ),
    );
  }
}
