import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/battery_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

/// Insights: text-based battery stories in plain language; insight cards with icons.
class InsightsPage extends GetView<BatteryController> {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.insightsTitle),
        backgroundColor: AppColors.background,
      ),
      body: Obx(() {
        final insights = controller.insightsList;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.insightsSubtitle,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              if (insights.isEmpty)
                _PlaceholderCard(
                  text: 'Your battery insights will appear here as you use the app.',
                )
              else
                ...insights.map((text) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _InsightCard(text: text),
                    )),
            ],
          ),
        );
      }),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String text;

  const _InsightCard({required this.text});

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryStart.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.lightbulb_outline,
              color: AppColors.primaryStart,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.body,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  final String text;

  const _PlaceholderCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
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
      child: Text(text, style: AppTextStyles.body),
    );
  }
}
