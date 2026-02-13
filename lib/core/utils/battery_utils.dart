import '../services/storage_service.dart';

/// Human-readable status line and drain/prediction helpers.
/// Honest language only; no fake optimization.
class BatteryUtils {
  /// Returns a human-readable status line based on level and charging state.
  static String humanReadableStatus({
    required int level,
    required bool isCharging,
  }) {
    if (isCharging) {
      return 'Charging — unplug near 85–90% for care';
    }
    if (level >= 60) return 'Enough for moderate use for a while';
    if (level >= 30) return 'Enough for light usage right now';
    if (level >= 15) return 'Consider charging soon';
    return 'Charge when you can';
  }

  /// Approximate minutes left based on current level and drain speed (min per 1%).
  /// Always approximate; label in UI.
  static int? approximateMinutesLeft({
    required int level,
    double? minutesPerPercent,
  }) {
    if (minutesPerPercent == null || minutesPerPercent <= 0) return null;
    return (level * minutesPerPercent).round();
  }

  /// Estimate drain speed (minutes per 1%) from today's samples.
  /// Returns null if not enough data. Calculated only when app opens.
  static double? estimateDrainSpeedFromSamples(List<BatterySample> samples) {
    if (samples.length < 2) return null;
    // Sort by time
    final sorted = List<BatterySample>.from(samples)
      ..sort((a, b) => a.time.compareTo(b.time));
    double totalDrop = 0;
    int totalMinutes = 0;
    for (int i = 1; i < sorted.length; i++) {
      final prev = sorted[i - 1];
      final curr = sorted[i];
      final drop = prev.percent - curr.percent;
      if (drop > 0) {
        totalDrop += drop;
        totalMinutes += curr.time.difference(prev.time).inMinutes;
      }
    }
    if (totalDrop <= 0 || totalMinutes <= 0) return null;
    return totalMinutes / totalDrop;
  }
}
