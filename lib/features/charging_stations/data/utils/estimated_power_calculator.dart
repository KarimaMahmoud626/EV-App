class EstimatedPowerCalculator {
  double? estimatePower({required int? level, required String typeName}) {
    if (level == null) return null;

    switch (level) {
      case 1:
        return 3.7;

      case 2:
        if (typeName.contains('Type 1') || typeName.contains('J1772')) {
          return 7.4;
        }
        return 11;

      case 3:
        if (typeName.contains('CHAdeMO')) return 100;
        if (typeName.contains('CCS')) return 150;
        return 50;

      default:
        return null;
    }
  }
}
