/// App copy: honest, human-readable language only.
abstract class AppStrings {
  static const String appName = 'Battery Insights';

  static const String splashTagline = 'Understand your battery';

  // Home
  static const String homeTitle = 'Home';
  static const String charging = 'Charging';
  static const String discharging = 'Discharging';
  static const String batteryCareScore = 'Battery Care Score';
  static const String careScoreDisclaimer =
      'Based on usage patterns. Not battery health.';

  // Status chips
  static const String statusGood = 'Good';
  static const String statusModerate = 'Moderate';
  static const String statusPoor = 'Poor';

  // Human-readable status lines
  static const String statusEnoughLight = 'Enough for light usage right now';
  static const String statusEnoughModerate =
      'Enough for moderate use for a while';
  static const String statusLowSoon = 'Consider charging soon';
  static const String statusLowNow = 'Charge when you can';
  static const String statusCharging = 'Charging — unplug near 85–90% for care';

  // Usage
  static const String usageTitle = 'Usage';
  static const String todayDrain = "Today's battery drain";
  static const String drainSpeedLabel = '1% ≈ {minutes} min (approx.)';
  static const String drainSpeedUnknown = 'Drain speed (approx.) — open app to estimate';

  // Insights
  static const String insightsTitle = 'Insights';
  static const String insightsSubtitle = 'Plain-language battery stories';

  // Tips
  static const String tipsTitle = 'Tips';
  static const String tipsSubtitle = 'Honest battery care advice';

  // Prediction
  static const String predictionDisclaimer =
      'Approximate estimate based on recent usage';

  // Philosophy
  static const String philosophy =
      'This app does not control or fix your battery. '
      'It helps you understand your battery usage and behavior in plain, human-readable language.';
}
