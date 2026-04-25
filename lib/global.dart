import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'services/index.dart';
import 'store/index.dart';

class Global {
  const Global._();

  static Future<void> init() async {
    if (!Get.testMode) {
      await GetStorage.init();
    }

    if (!Get.isRegistered<StorageService>()) {
      Get.put<StorageService>(StorageService(), permanent: true);
    }
    if (!Get.isRegistered<HttpService>()) {
      Get.put<HttpService>(HttpService(), permanent: true);
    }
    if (!Get.isRegistered<AppStore>()) {
      Get.put<AppStore>(AppStore(), permanent: true);
    }
    if (!Get.isRegistered<TaskStore>()) {
      Get.put<TaskStore>(TaskStore(), permanent: true);
    }
    if (!Get.isRegistered<WorkStore>()) {
      Get.put<WorkStore>(WorkStore()..seed(), permanent: true);
    }
  }
}
