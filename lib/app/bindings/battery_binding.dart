import 'package:get/get.dart';
import '../controllers/battery_controller.dart';
import '../../core/services/battery_service.dart';
import '../../core/services/storage_service.dart';

/// GetX binding: inject BatteryService, StorageService, BatteryController.
class BatteryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BatteryService>(() => BatteryService());
    Get.lazyPut<StorageService>(() => StorageService());
    Get.lazyPut<BatteryController>(
      () => BatteryController(
        batteryService: Get.find<BatteryService>(),
        storageService: Get.find<StorageService>(),
      ),
    );
  }
}
