import 'package:equatable/equatable.dart';
import 'package:ev_app/features/settings/data/models/user_preferences.dart';

/// Base state for settings feature
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state before preferences are loaded
class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

/// Loading state while fetching preferences
class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

/// Successfully loaded preferences
class SettingsLoaded extends SettingsState {
  final UserPreferences preferences;

  const SettingsLoaded(this.preferences);

  @override
  List<Object?> get props => [preferences];
}

/// Error state when loading/saving fails
class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
