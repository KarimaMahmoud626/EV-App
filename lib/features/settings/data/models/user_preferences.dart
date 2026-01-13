import 'package:equatable/equatable.dart';

/// User preferences model for app settings.
///
/// Stores user-configurable preferences that persist across app sessions.
class UserPreferences extends Equatable {
  final bool notificationsEnabled;
  final int lowBatteryThreshold; // Percentage (0-100)
  final int targetChargingLevel; // Percentage (0-100)
  final String distanceUnit; // 'km' or 'miles'
  final String temperatureUnit; // 'celsius' or 'fahrenheit'

  const UserPreferences({
    this.notificationsEnabled = true,
    this.lowBatteryThreshold = 20,
    this.targetChargingLevel = 80,
    this.distanceUnit = 'km',
    this.temperatureUnit = 'celsius',
  });

  /// Create preferences from JSON
  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      lowBatteryThreshold: json['lowBatteryThreshold'] as int? ?? 20,
      targetChargingLevel: json['targetChargingLevel'] as int? ?? 80,
      distanceUnit: json['distanceUnit'] as String? ?? 'km',
      temperatureUnit: json['temperatureUnit'] as String? ?? 'celsius',
    );
  }

  /// Convert preferences to JSON
  Map<String, dynamic> toJson() {
    return {
      'notificationsEnabled': notificationsEnabled,
      'lowBatteryThreshold': lowBatteryThreshold,
      'targetChargingLevel': targetChargingLevel,
      'distanceUnit': distanceUnit,
      'temperatureUnit': temperatureUnit,
    };
  }

  /// Create a copy with updated fields
  UserPreferences copyWith({
    bool? notificationsEnabled,
    int? lowBatteryThreshold,
    int? targetChargingLevel,
    String? distanceUnit,
    String? temperatureUnit,
  }) {
    return UserPreferences(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      lowBatteryThreshold: lowBatteryThreshold ?? this.lowBatteryThreshold,
      targetChargingLevel: targetChargingLevel ?? this.targetChargingLevel,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
    );
  }

  @override
  List<Object?> get props => [
    notificationsEnabled,
    lowBatteryThreshold,
    targetChargingLevel,
    distanceUnit,
    temperatureUnit,
  ];
}
