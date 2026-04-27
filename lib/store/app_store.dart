import 'package:get/get.dart';

import '../services/index.dart';
import '../utils/index.dart';

class AppStore extends GetxController {
  static AppStore get to => Get.find<AppStore>();

  String installationId = 'local-device';
  String appVersion = AppConfig.appVersion;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<StorageService>()) {
      installationId = Get.find<StorageService>().installationId;
    }
    appVersion = AppConfig.appVersion;
  }
}
