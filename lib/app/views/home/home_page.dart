import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/battery_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/score_utils.dart';

/// Home: large battery %, charging/discharging, care score, status chip, human-readable line.
class HomePage extends GetView<BatteryController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.homeTitle),
        backgroundColor: AppColors.background,
      ),
      body: Obx(() {
        final level = controller.batteryLevel.value;
        final isCharging = controller.isCharging;
        final score = controller.careScore.value;
        final status = controller.careScoreStatus;
        final statusLine = controller.humanReadableStatusLine.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                '$level%',
                style: AppTextStyles.batteryPercentage,
              ),
              const SizedBox(height: 8),
              Text(
                isCharging ? AppStrings.charging : AppStrings.discharging,
                style: AppTextStyles.subheading.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              _StatusChip(status: status),
              if (statusLine.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  statusLine,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
              ],
              const SizedBox(height: 40),
              _CareScoreCard(score: score),
            ],
          ),
        );
      }),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final CareScoreStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (String label, Color color) = switch (status) {
      CareScoreStatus.good => (AppStrings.statusGood, AppColors.accentGreen),
      CareScoreStatus.moderate =>
        (AppStrings.statusModerate, AppColors.accentOrange),
      CareScoreStatus.poor => (AppStrings.statusPoor, AppColors.accentRed),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        label,
        style: AppTextStyles.statusChip.copyWith(color: color),
      ),
    );
  }
}

class _CareScoreCard extends StatelessWidget {
  final int score;

  const _CareScoreCard({required this.score});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.batteryCareScore,
            style: AppTextStyles.heading,
          ),
          const SizedBox(height: 8),
          Text(
            '$score',
            style: AppTextStyles.batteryPercentage.copyWith(fontSize: 36),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.careScoreDisclaimer,
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}
