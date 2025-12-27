import 'dart:math';

import 'package:ev_app/features/battery_monitoring/data/models/battery_data_model.dart';

class BatteryDataSimulator {
  final Random _random = Random();

  // Battery specifications
  static const double maxCapacity = 75.0;
  static const double nominalVoltage = 400.0;
  static const int cellCount = 96;

  static const double maxChargingSOC = 85.0; // ← Optimal max
  static const double minDischargingSOC = 20.0; // ← Optimal min
  static const double absoluteMinSOC = 5.0; // ← Emergency only

  // Current state
  double _currentSOC = 65.0;
  double _currentSOH = 95.0;
  double _temperature = 25.0;
  bool _isCharging = false;
  DateTime _lastUpdate = DateTime.now();

  // Degradation tracking
  int _totalCycles = 450;
  double _fastChargingCount = 120.0;
  int _fullCycleCount = 0; // ← 0-100% cycles (bad!)
  int _healthyCycleCount = 0; // ← 20-85% cycles (good!)

  // User settings
  double _targetSOC = maxChargingSOC; // ← Target for charging

  // Constructor
  BatteryDataSimulator({double initialSOC = 65.0}) {
    _currentSOC = initialSOC.clamp(absoluteMinSOC, 100.0);
  }

  /// Generate realistic battery data stream
  Stream<BatteryDataModel> getBatteryDataStream() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 3));

      final now = DateTime.now();
      final timeDiff = now.difference(_lastUpdate).inSeconds;

      // Update SOC based on charging/discharging
      _updateSOC(timeDiff);

      // Update temperature
      _updateTemperature();

      // Update SOH (degradation)
      _updateSOH();

      _lastUpdate = now;

      yield BatteryDataModel(
        soc: _currentSOC,
        soh: _currentSOH,
        voltage: _calculateVoltage(),
        current: _calculateCurrent(),
        temperature: _temperature,
        power: _calculatePower(),
        estimatedRange: _calculateRange(),
        timeToFull: _calculateTimeToFull(),
        cycleCount: _totalCycles,
        cellVoltages: _generateCellVoltages(),
        timestamp: now,
        targetSoc: _targetSOC,
      );
    }
  }

  /// Update State of Charge with battery-friendly limits
  void _updateSOC(int seconds) {
    if (_isCharging) {
      // Charging logic with health-friendly limits

      // Charging rate depends on current SOC
      double chargeRate;
      if (_currentSOC < 20) {
        chargeRate = 0.2; // Slow below 20% (protection)
      } else if (_currentSOC < _targetSOC - 5) {
        chargeRate = 0.3; // Fast charging up to target - 5%
      } else {
        chargeRate = 0.08; // Very slow near target (trickle charge)
      }

      _currentSOC = min(_targetSOC, _currentSOC + (chargeRate * seconds / 60));

      // Stop charging when reaching target
      if (_currentSOC >= _targetSOC - 0.5) {
        _isCharging = false;

        // Track cycle type
        if (_targetSOC >= 95) {
          _fullCycleCount++; // Bad for battery!
        } else if (_targetSOC <= maxChargingSOC) {
          _healthyCycleCount++; // Good for battery!
        }
      }
    } else {
      // Discharging logic
      double dischargeRate = 0.05; // ~3% per hour (realistic city driving)
      _currentSOC = max(
        absoluteMinSOC,
        _currentSOC - (dischargeRate * seconds / 60),
      );

      // Auto-start charging at recommended minimum
      if (_currentSOC <= minDischargingSOC && _random.nextBool()) {
        _isCharging = true;
      }

      // Warning if below recommended minimum
      if (_currentSOC < minDischargingSOC) {
        // In real app, trigger notification here
        print('Battery below recommended minimum ($minDischargingSOC%)');
      }
    }
  }

  /// Update State of Health with realistic degradation
  void _updateSOH() {
    // Base degradation rate (very slow)
    double baseDegradation = 0.000001;

    // Extra degradation from bad practices
    double extraDegradation = 0.0;

    // 1. Full cycles are bad (0-100%)
    if (_fullCycleCount > 0) {
      extraDegradation += (_fullCycleCount / 100) * 0.05;
    }

    // 2. Deep discharges are bad (<20%)
    if (_currentSOC < minDischargingSOC) {
      extraDegradation += 0.000005; // Faster degradation
    }

    // 3. High SOC storage is bad (>85% for extended time)
    if (_currentSOC > maxChargingSOC && !_isCharging) {
      extraDegradation += 0.000003;
    }

    // 4. High temperature accelerates degradation
    if (_temperature > 35) {
      double tempFactor = (_temperature - 35) / 10; // 0.1 per 1°C above 35
      extraDegradation += baseDegradation * tempFactor;
    }

    _currentSOH = max(70.0, _currentSOH - baseDegradation - extraDegradation);
  }

  /// Calculate time to full based on target SOC
  Duration? _calculateTimeToFull() {
    if (!_isCharging) return null;

    double remainingSOC = _targetSOC - _currentSOC;
    if (remainingSOC <= 0) return Duration.zero;

    // Charging rate depends on current SOC
    double chargeRate;
    if (_currentSOC < _targetSOC - 5) {
      chargeRate = 0.3; // Fast charging
    } else {
      chargeRate = 0.08; // Slow near target
    }

    int minutes = (remainingSOC / chargeRate).round();
    return Duration(minutes: minutes);
  }

  /// Set target SOC for charging
  void setTargetSOC(double target) {
    _targetSOC = target.clamp(minDischargingSOC, 100.0);
  }

  /// Get battery health metrics
  Map<String, dynamic> getHealthMetrics() {
    return {
      'soh': _currentSOH,
      'totalCycles': _totalCycles,
      'healthyCycles': _healthyCycleCount,
      'fullCycles': _fullCycleCount,
      'fastCharges': _fastChargingCount,
      'healthyRatio': _healthyCycleCount / max(1, _totalCycles),
      'recommendation': _getHealthRecommendation(),
    };
  }

  String _getHealthRecommendation() {
    if (_currentSOC > maxChargingSOC) {
      return 'Consider lowering charge target to $maxChargingSOC% for better battery health';
    }
    if (_currentSOC < minDischargingSOC) {
      return 'Charge soon to maintain battery health';
    }
    return 'Battery is in optimal range';
  }

  void _updateTemperature() {
    double targetTemp;

    if (_isCharging) {
      // Battery heats up during charging (35-45°C)
      targetTemp = 38.0 + _random.nextDouble() * 7.0;
    } else {
      // Normal operating temperature (20-30°C)
      targetTemp = 23.0 + _random.nextDouble() * 7.0;
    }

    // Gradually move towards target temperature
    _temperature += (targetTemp - _temperature) * 0.1;

    // Add small random fluctuation
    _temperature += (_random.nextDouble() - 0.5) * 0.5;
  }

  /// Calculate voltage based on SOC
  double _calculateVoltage() {
    // Realistic voltage curve: higher voltage = higher SOC
    double baseVoltage = nominalVoltage;
    double socFactor = (_currentSOC / 100) * 0.15; // ±15% variation

    return baseVoltage * (0.925 + socFactor) + (_random.nextDouble() - 0.5) * 2;
  }

  /// Calculate current (A)
  double _calculateCurrent() {
    if (_isCharging) {
      // Charging current: 50-150A depending on SOC
      double maxCurrent = _currentSOC < 80 ? 120.0 : 50.0;
      return maxCurrent + (_random.nextDouble() - 0.5) * 10;
    } else {
      // Discharging current: 20-80A depending on driving
      return -(30.0 + _random.nextDouble() * 50);
    }
  }

  /// Calculate power (kW)
  double _calculatePower() {
    double voltage = _calculateVoltage();
    double current = _calculateCurrent();
    return (voltage * current / 1000); // Convert to kW
  }

  /// Calculate estimated range (km)
  double _calculateRange() {
    double availableEnergy =
        (maxCapacity * _currentSOC / 100) * (_currentSOH / 100);
    double efficiency = 6.5; // km per kWh (realistic for EVs)
    return availableEnergy * efficiency;
  }

  /// Generate individual cell voltages
  List<double> _generateCellVoltages() {
    double avgCellVoltage = _calculateVoltage() / cellCount;

    return List.generate(cellCount, (index) {
      // Most cells are similar, some slightly different (realistic)
      double variation = (_random.nextDouble() - 0.5) * 0.02;
      return avgCellVoltage * (1 + variation);
    });
  }

  /// Manual control methods
  void startCharging() => _isCharging = true;
  void stopCharging() => _isCharging = false;
  bool get isCharging => _isCharging;

  /// Simulate fast charging (increases degradation)
  void simulateFastCharging() {
    _fastChargingCount++;
    _totalCycles++;
    _currentSOH -= 0.05; // Fast charging degrades battery faster
  }

  /// Simulate normal charging cycle
  void simulateChargingCycle() {
    _totalCycles++;
    if (_totalCycles % 50 == 0) {
      _currentSOH -= 0.1; // Small degradation every 50 cycles
    }
  }
}
