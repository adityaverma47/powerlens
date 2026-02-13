import 'package:battery_plus/battery_plus.dart';
import 'package:get/get.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/battery_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/battery_utils.dart';
import '../../core/utils/score_utils.dart';

/// Single GetX controller for battery state. Observable fields; human-readable insights.
class BatteryController extends GetxController {
  BatteryController({
    BatteryService? batteryService,
    StorageService? storageService,
  })  : _batteryService = batteryService ?? BatteryService(),
        _storageService = storageService ?? StorageService();

  final BatteryService _batteryService;
  final StorageService _storageService;

  final RxInt batteryLevel = 0.obs;
  final Rx<BatteryState> batteryState = BatteryState.unknown.obs;
  final RxnDouble drainSpeedMinutesPerPercent = RxnDouble();
  final RxInt careScore = 100.obs;
  final RxList<String> insightsList = <String>[].obs;
  final RxString humanReadableStatusLine = ''.obs;
  final RxList<BatterySample> todaySamples = <BatterySample>[].obs;

  bool get isCharging =>
      batteryState.value == BatteryState.charging ||
      batteryState.value == BatteryState.full;

  @override
  void onInit() {
    super.onInit();
    _loadAll();
    _batteryService.onBatteryStateChanged.listen((_) => refreshBattery());
  }

  Future<void> _loadAll() async {
    await refreshBattery();
    await _loadDrainSpeed();
    await _loadCareScore();
    await _loadTodaySamples();
    _updateHumanReadableStatus();
    _generateInsights();
  }

  Future<void> refreshBattery() async {
    batteryLevel.value = await _batteryService.getBatteryLevel();
    batteryState.value = await _batteryService.getBatteryState();
    await _storageService.appendBatterySample(batteryLevel.value);
    await _loadTodaySamples();
    _updateDrainSpeedFromSamples();
    _updateCareScoreFromPatterns();
    _updateHumanReadableStatus();
    _generateInsights();
  }

  void _updateHumanReadableStatus() {
    humanReadableStatusLine.value = BatteryUtils.humanReadableStatus(
      level: batteryLevel.value,
      isCharging: isCharging,
    );
  }

  Future<void> _loadDrainSpeed() async {
    final stored = await _storageService.getDrainSpeedMinutesPerPercent();
    if (stored != null) drainSpeedMinutesPerPercent.value = stored;
  }

  Future<void> _loadTodaySamples() async {
    todaySamples.value = await _storageService.getTodaySamples();
  }

  void _updateDrainSpeedFromSamples() {
    final estimated =
        BatteryUtils.estimateDrainSpeedFromSamples(todaySamples);
    if (estimated != null) {
      drainSpeedMinutesPerPercent.value = estimated;
      _storageService.setDrainSpeedMinutesPerPercent(estimated);
    }
  }

  Future<void> _loadCareScore() async {
    careScore.value = await _storageService.getCareScore();
  }

  void _updateCareScoreFromPatterns() async {
    if (batteryLevel.value < 20) {
      await _storageService.incrementLowBatteryCount();
    }
    final low = await _storageService.getLowBatteryCount();
    final fast = await _storageService.getFastDrainCount();
    final long90 = await _storageService.getLongChargeAbove90Count();
    final score = ScoreUtils.computeCareScore(
      lowBatteryCount: low,
      fastDrainCount: fast,
      longChargeAbove90Count: long90,
    );
    careScore.value = score;
    await _storageService.setCareScore(score);
  }

  /// Mark a fast drain session (e.g. when drop is large in short time).
  Future<void> recordFastDrainSession() async {
    await _storageService.incrementFastDrainCount();
    await _loadCareScore();
  }

  /// Call when user has been charging above 90% for long (e.g. from samples).
  Future<void> recordLongChargeAbove90() async {
    await _storageService.incrementLongChargeAbove90Count();
    await _loadCareScore();
  }

  CareScoreStatus get careScoreStatus =>
      ScoreUtils.statusFromScore(careScore.value);

  /// Drain speed text: "1% ≈ X min (approx.)" or fallback.
  String get drainSpeedText {
    final m = drainSpeedMinutesPerPercent.value;
    if (m == null || m <= 0) return AppStrings.drainSpeedUnknown;
    return AppStrings.drainSpeedLabel.replaceAll('{minutes}', m.round().toString());
  }

  /// Approximate minutes left (for prediction). Label as estimate in UI.
  int? get approximateMinutesLeft =>
      BatteryUtils.approximateMinutesLeft(
        level: batteryLevel.value,
        minutesPerPercent: drainSpeedMinutesPerPercent.value,
      );

  /// Max 3–4 insights per day; plain-language battery stories.
  void _generateInsights() {
    final list = <String>[];
    final level = batteryLevel.value;
    final charging = isCharging;
    final score = careScore.value;
    final samples = todaySamples;

    if (level < 25 && !charging) {
      list.add('Battery is getting low. Consider charging when you can.');
    }
    if (level >= 85 && charging) {
      list.add('Avoid long charging above 90% for long-term care.');
    }
    if (samples.length >= 3) {
      final drop = samples.first.percent - samples.last.percent;
      final minutes = samples.last.time.difference(samples.first.time).inMinutes;
      if (minutes > 0 && (drop / minutes) > 0.5) {
        list.add('Battery drained faster today than usual.');
      }
    }
    if (score < 50) {
      list.add('Your care score is lower — try unplugging near 85–90% and avoiding deep discharges.');
    }
    if (list.isEmpty) {
      list.add('Your battery usage looks steady. Keep unplugging near 85–90% when possible.');
    }
    insightsList.value = list.take(4).toList();
  }
}
