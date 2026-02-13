import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/bindings/battery_binding.dart';
import '../../../app/controllers/battery_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../home/home_page.dart';
import '../usage/usage_page.dart';
import '../insights/insights_page.dart';
import '../tips/tips_page.dart';

/// Dashboard: bottom nav root with 4 tabs (Home, Usage, Insights, Tips).
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  final _pages = const [
    HomePage(),
    UsagePage(),
    InsightsPage(),
    TipsPage(),
  ];

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<BatteryController>()) {
      BatteryBinding().dependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.battery_full,
                  label: 'Home',
                  index: 0,
                  current: _currentIndex,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _NavItem(
                  icon: Icons.show_chart,
                  label: 'Usage',
                  index: 1,
                  current: _currentIndex,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _NavItem(
                  icon: Icons.lightbulb_outline,
                  label: 'Insights',
                  index: 2,
                  current: _currentIndex,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
                _NavItem(
                  icon: Icons.health_and_safety,
                  label: 'Tips',
                  index: 3,
                  current: _currentIndex,
                  onTap: () => setState(() => _currentIndex = 3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final selected = index == current;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: selected ? AppColors.primaryStart : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                color: selected ? AppColors.primaryStart : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
