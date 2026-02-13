import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../app/controllers/battery_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_gradients.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/services/storage_service.dart' show BatterySample;

/// Usage: today's drain, drain speed text, line chart (time vs battery %).
class UsagePage extends GetView<BatteryController> {
  const UsagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppStrings.usageTitle),
        backgroundColor: AppColors.background,
      ),
      body: Obx(() {
        final samples = controller.todaySamples;
        final drainSpeedText = controller.drainSpeedText;
        final minutesLeft = controller.approximateMinutesLeft;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.todayDrain,
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: 8),
              Text(
                drainSpeedText,
                style: AppTextStyles.body,
              ),
              if (minutesLeft != null) ...[
                const SizedBox(height: 4),
                Text(
                  '${AppStrings.predictionDisclaimer} ~$minutesLeft min left (approx.)',
                  style: AppTextStyles.bodySmall,
                ),
              ],
              const SizedBox(height: 24),
              _BatteryLineChart(samples: samples),
            ],
          ),
        );
      }),
    );
  }
}

class _BatteryLineChart extends StatelessWidget {
  final List<BatterySample> samples;

  const _BatteryLineChart({required this.samples});

  @override
  Widget build(BuildContext context) {
    if (samples.isEmpty) {
      return Container(
        height: 220,
        alignment: Alignment.center,
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
        child: Text(
          'Open the app through the day to see today\'s battery story.',
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
      );
    }

    final sorted = List<BatterySample>.from(samples)
      ..sort((a, b) => a.time.compareTo(b.time));
    final spots = sorted
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value.percent))
        .toList();
    final minY = (sorted.map((s) => s.percent).reduce((a, b) => a < b ? a : b) - 5).clamp(0.0, 100.0);
    final maxY = (sorted.map((s) => s.percent).reduce((a, b) => a > b ? a : b) + 5).clamp(0.0, 100.0);

    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
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
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (spots.length - 1).clamp(1, 999).toDouble(),
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY - minY) / 4,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.textSecondary.withValues(alpha: 0.15),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 24,
                interval: (spots.length / 4).clamp(1.0, 999),
                getTitlesWidget: (value, meta) {
                  final i = value.round().clamp(0, sorted.length - 1);
                  if (i >= sorted.length) return const SizedBox();
                  final t = sorted[i].time;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${t.hour}:${t.minute.toString().padLeft(2, '0')}',
                      style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.primaryStart,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primaryStart.withValues(alpha: 0.3),
                    AppColors.primaryStart.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 250),
      ),
    );
  }
}
