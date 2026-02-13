import 'package:flutter/material.dart';
import 'app/routes/app_pages.dart';
import 'core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BatteryInsightsApp());
}

class BatteryInsightsApp extends StatelessWidget {
  const BatteryInsightsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Battery Insights',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: createAppRouter(), // ✅ GoRouter here
    );
  }
}
