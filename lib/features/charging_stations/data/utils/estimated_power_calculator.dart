class EstimatedPowerCalculator {
  static double? estimatePower({required int? level, String? typeName}) {
    if (level == null) return null;

    final type = typeName ?? '';

    switch (level) {
      case 1:
        return 3.7;

      case 2:
        if (type.contains('Type 1') || type.contains('J1772')) {
          return 7.4;
        }
        return 11;

      case 3:
        if (type.contains('CHAdeMO')) return 100;
        if (type.contains('CCS')) return 150;
        return 50;

      default:
        return null;
    }
  }
}
