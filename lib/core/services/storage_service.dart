import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local storage for drain speed, care score, and today's battery samples.
/// No background abuse; data written only when app is used.
class StorageService {
  static const String _keyDrainSpeedMinutes = 'drain_speed_minutes';
  static const String _keyCareScore = 'care_score';
  static const String _keyTodaySamples = 'today_battery_samples';
  static const String _keyLastSampleDate = 'last_sample_date';
  static const String _keyLowBatteryCount = 'low_battery_count';
  static const String _keyFastDrainCount = 'fast_drain_count';
  static const String _keyLongChargeAbove90Count = 'long_charge_above_90';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<double?> getDrainSpeedMinutesPerPercent() async {
    final prefs = await _preferences;
    return prefs.getDouble(_keyDrainSpeedMinutes);
  }

  Future<void> setDrainSpeedMinutesPerPercent(double value) async {
    final prefs = await _preferences;
    await prefs.setDouble(_keyDrainSpeedMinutes, value);
  }

  Future<int> getCareScore() async {
    final prefs = await _preferences;
    return prefs.getInt(_keyCareScore) ?? 100;
  }

  Future<void> setCareScore(int score) async {
    final prefs = await _preferences;
    await prefs.setInt(_keyCareScore, score.clamp(0, 100));
  }

  Future<List<BatterySample>> getTodaySamples() async {
    final prefs = await _preferences;
    final dateKey = DateTime.now().toIso8601String().split('T').first;
    final storedDate = prefs.getString(_keyLastSampleDate);
    if (storedDate != dateKey) return [];

    final json = prefs.getString(_keyTodaySamples);
    if (json == null) return [];
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list
          .map((e) => BatterySample(
                (e['p'] as num).toDouble(),
                DateTime.parse(e['t'] as String),
              ))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> appendBatterySample(int level) async {
    final prefs = await _preferences;
    final dateKey = DateTime.now().toIso8601String().split('T').first;
    final storedDate = prefs.getString(_keyLastSampleDate);
    List<BatterySample> samples = await getTodaySamples();
    if (storedDate != dateKey) {
      samples = [];
    }
    samples.add(BatterySample(level.toDouble(), DateTime.now()));
    // Keep last 48 samples (e.g. every ~30 min) to avoid huge list
    if (samples.length > 48) samples = samples.sublist(samples.length - 48);
    await prefs.setString(
      _keyTodaySamples,
      jsonEncode(samples.map((s) => {'p': s.percent, 't': s.time.toIso8601String()}).toList()),
    );
    await prefs.setString(_keyLastSampleDate, dateKey);
  }

  Future<int> getLowBatteryCount() async {
    final prefs = await _preferences;
    return prefs.getInt(_keyLowBatteryCount) ?? 0;
  }

  Future<void> incrementLowBatteryCount() async {
    final prefs = await _preferences;
    await prefs.setInt(_keyLowBatteryCount, (await getLowBatteryCount()) + 1);
  }

  Future<int> getFastDrainCount() async {
    final prefs = await _preferences;
    return prefs.getInt(_keyFastDrainCount) ?? 0;
  }

  Future<void> incrementFastDrainCount() async {
    final prefs = await _preferences;
    await prefs.setInt(_keyFastDrainCount, (await getFastDrainCount()) + 1);
  }

  Future<int> getLongChargeAbove90Count() async {
    final prefs = await _preferences;
    return prefs.getInt(_keyLongChargeAbove90Count) ?? 0;
  }

  Future<void> incrementLongChargeAbove90Count() async {
    final prefs = await _preferences;
    await prefs.setInt(
      _keyLongChargeAbove90Count,
      (await getLongChargeAbove90Count()) + 1,
    );
  }
}

class BatterySample {
  final double percent;
  final DateTime time;

  BatterySample(this.percent, this.time);
}
