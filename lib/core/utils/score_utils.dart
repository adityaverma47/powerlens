/// Battery Care Score (0–100). NOT battery health.
/// Deduct for: frequent low battery, fast drain sessions, long charging above 90%.
class ScoreUtils {
  static const int maxScore = 100;
  static const int minScore = 0;

  /// Compute care score from stored counts. Start at 100, deduct for patterns.
  static int computeCareScore({
    required int lowBatteryCount,
    required int fastDrainCount,
    required int longChargeAbove90Count,
  }) {
    int score = 100;
    score -= (lowBatteryCount * 2).clamp(0, 25);
    score -= (fastDrainCount * 3).clamp(0, 25);
    score -= (longChargeAbove90Count * 2).clamp(0, 20);
    return score.clamp(minScore, maxScore);
  }

  /// Status category for UI chip: Good (green), Moderate (orange), Poor (red).
  static CareScoreStatus statusFromScore(int score) {
    if (score >= 70) return CareScoreStatus.good;
    if (score >= 40) return CareScoreStatus.moderate;
    return CareScoreStatus.poor;
  }
}

enum CareScoreStatus { good, moderate, poor }
