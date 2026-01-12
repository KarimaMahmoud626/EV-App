/// Battery-related constants used throughout the battery monitoring feature.
///
/// Centralizes all magic numbers and configuration values for battery simulation
/// and monitoring to improve maintainability and readability.
class BatteryConstants {
  // Private constructor to prevent instantiation
  BatteryConstants._();

  // ==================== Simulator Update Intervals ====================

  /// Interval between battery data updates (in seconds)
  static const Duration updateInterval = Duration(seconds: 3);

  // ==================== Charging Rates ====================

  /// Normal charging rate (% per minute)
  static const double normalChargeRate = 0.2;

  /// Fast charging rate (% per minute)
  static const double fastChargeRate = 0.3;

  /// Trickle charging rate when near full (% per minute)
  static const double trickleChargeRate = 0.08;

  // ==================== Discharge Rates ====================

  /// Normal discharge rate when not charging (% per minute)
  static const double normalDischargeRate = 0.05;

  // ==================== State of Charge (SOC) Thresholds ====================

  /// Maximum SOC for charging (85%)
  /// Charging slows down or stops at this level to protect battery
  static const double maxChargingSOC = 85.0;

  /// Minimum SOC for normal operation (20%)
  /// Below this, battery is considered low
  static const double minNormalSOC = 20.0;

  /// Critical minimum SOC (5%)
  /// Below this, vehicle should not be operated
  static const double criticalMinSOC = 5.0;

  /// SOC threshold for switching to trickle charge (80%)
  static const double trickleChargeThreshold = 80.0;

  // ==================== Battery Specifications ====================

  /// Number of cells in the battery pack
  static const int cellCount = 96;

  /// Nominal voltage per cell (V)
  static const double nominalCellVoltage = 3.7;

  /// Maximum voltage per cell (V)
  static const double maxCellVoltage = 4.2;

  /// Minimum voltage per cell (V)
  static const double minCellVoltage = 3.0;

  /// Battery capacity in kWh
  static const double batteryCapacityKWh = 75.0;

  // ==================== Temperature Limits ====================

  /// Normal operating temperature (°C)
  static const double normalTemperature = 25.0;

  /// Maximum safe temperature (°C)
  static const double maxTemperature = 45.0;

  /// Minimum safe temperature (°C)
  static const double minTemperature = -10.0;

  // ==================== State of Health (SOH) ====================

  /// Initial SOH for new battery (%)
  static const double initialSOH = 100.0;

  /// SOH degradation per charge cycle (%)
  static const double sohDegradationPerCycle = 0.001;

  // ==================== Range Estimation ====================

  /// Estimated range per 1% SOC (km)
  static const double rangePerPercent = 5.0;

  /// Maximum estimated range at 100% SOC (km)
  static const double maxRange = 500.0;
}
