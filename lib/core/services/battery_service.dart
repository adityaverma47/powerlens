import 'package:battery_plus/battery_plus.dart';

/// Service to read battery level and state. No background abuse; read on demand.
class BatteryService {
  final Battery _battery = Battery();

  Future<int> getBatteryLevel() async {
    try {
      return await _battery.batteryLevel;
    } catch (_) {
      return 0;
    }
  }

  Future<BatteryState> getBatteryState() async {
    try {
      return await _battery.batteryState;
    } catch (_) {
      return BatteryState.unknown;
    }
  }

  Stream<BatteryState> get onBatteryStateChanged => _battery.onBatteryStateChanged;
}
