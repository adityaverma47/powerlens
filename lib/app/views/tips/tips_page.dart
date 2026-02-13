import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';

/// Tips: static + dynamic battery care tips; honest language only.
class TipsPage extends StatelessWidget {
  const TipsPage({super.key});

  static const List<Map<String, String>> _tips = [
    {
      'title': 'Unplug near 85–90%',
      'text':
          'Try unplugging near 85–90% for long-term care. Keeping the battery between 20–90% when possible can help over time.',
    },
    {
      'title': 'Avoid deep discharges',
      'text':
          'Frequently letting the battery go below 20% can stress it. Charge when you can rather than waiting for very low levels.',
    },
    {
      'title': 'Heat and cold',
      'text':
          'Extreme temperatures affect battery behavior. Avoid leaving the device in very hot or very cold environments for long.',
    },
    {
      'title': 'No magic fixes',
      'text':
          'This app does not control or fix your battery. It helps you understand usage in plain language. There are no hidden optimizations.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.tipsTitle),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.tipsSubtitle,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ..._tips.map((t) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TipCard(
                    title: t['title']!,
                    text: t['text']!,
                  ),
                )),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryStart.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryStart.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                AppStrings.philosophy,
                style: AppTextStyles.bodySmall.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final String title;
  final String text;

  const _TipCard({required this.title, required this.text});

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
          Row(
            children: [
              Icon(
                Icons.health_and_safety,
                color: AppColors.primaryStart,
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: AppTextStyles.heading.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}
