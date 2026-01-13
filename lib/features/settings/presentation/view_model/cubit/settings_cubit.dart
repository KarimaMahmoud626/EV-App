import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ev_app/features/settings/data/models/user_preferences.dart';
import 'package:ev_app/features/settings/presentation/view_model/cubit/settings_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Cubit for managing user settings and preferences.
///
/// Handles loading, updating, and persisting user preferences
/// using SharedPreferences for local storage.
class SettingsCubit extends Cubit<SettingsState> {
  static const String _preferencesKey = 'user_preferences';

  SettingsCubit() : super(const SettingsInitial());

  /// Load user preferences from local storage
  Future<void> loadPreferences() async {
    try {
      emit(const SettingsLoading());

      // Add a small delay to ensure plugin is ready
      await Future<void>.delayed(const Duration(milliseconds: 100));

      final prefs = await SharedPreferences.getInstance();
      final prefsJson = prefs.getString(_preferencesKey);

      if (prefsJson != null && prefsJson.isNotEmpty) {
        try {
          final prefsMap = json.decode(prefsJson) as Map<String, dynamic>;
          final preferences = UserPreferences.fromJson(prefsMap);
          emit(SettingsLoaded(preferences));
        } catch (jsonError) {
          // If JSON parsing fails, use defaults
          emit(const SettingsLoaded(UserPreferences()));
        }
      } else {
        // No saved preferences, use defaults
        emit(const SettingsLoaded(UserPreferences()));
      }
    } catch (e) {
      // If SharedPreferences fails, still show UI with defaults
      // This prevents the app from being stuck on error screen
      emit(const SettingsLoaded(UserPreferences()));
    }
  }

  /// Update a specific preference
  Future<void> updatePreferences(UserPreferences newPreferences) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final prefsJson = json.encode(newPreferences.toJson());
      await prefs.setString(_preferencesKey, prefsJson);

      emit(SettingsLoaded(newPreferences));
    } catch (e) {
      // Even if save fails, update the UI state
      // The preference will be lost on restart, but app remains functional
      emit(SettingsLoaded(newPreferences));
    }
  }

  /// Toggle notifications
  Future<void> toggleNotifications(bool enabled) async {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      final updated = currentState.preferences.copyWith(
        notificationsEnabled: enabled,
      );
      await updatePreferences(updated);
    }
  }

  /// Update low battery threshold
  Future<void> updateLowBatteryThreshold(int threshold) async {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      final updated = currentState.preferences.copyWith(
        lowBatteryThreshold: threshold,
      );
      await updatePreferences(updated);
    }
  }

  /// Update target charging level
  Future<void> updateTargetChargingLevel(int level) async {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      final updated = currentState.preferences.copyWith(
        targetChargingLevel: level,
      );
      await updatePreferences(updated);
    }
  }

  /// Update distance unit
  Future<void> updateDistanceUnit(String unit) async {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      final updated = currentState.preferences.copyWith(distanceUnit: unit);
      await updatePreferences(updated);
    }
  }

  /// Update temperature unit
  Future<void> updateTemperatureUnit(String unit) async {
    final currentState = state;
    if (currentState is SettingsLoaded) {
      final updated = currentState.preferences.copyWith(temperatureUnit: unit);
      await updatePreferences(updated);
    }
  }

  /// Reset preferences to defaults
  Future<void> resetToDefaults() async {
    await updatePreferences(const UserPreferences());
  }
}
