import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'services/index.dart';
import 'store/index.dart';
import 'utils/index.dart';

class Global {
  const Global._();

  static PackageInfo? _platform;
  static bool _initialized = false;

  static String get version => _platform?.version ?? AppConfig.appVersion;
  static String get build => _platform?.buildNumber ?? AppConfig.buildNumber;

  static Future<void> init() async {
    if (_initialized && Get.isRegistered<WorkStore>()) return;

    await _initPlatform();

    if (!Get.isRegistered<StorageService>()) {
      await Get.putAsync<StorageService>(
        () => StorageService().init(),
        permanent: true,
      );
    }
    if (!Get.isRegistered<HttpService>()) {
      Get.put<HttpService>(HttpService(), permanent: true);
    }
    if (!Get.isRegistered<WorkService>()) {
      Get.put<WorkService>(WorkService(), permanent: true);
    }
    if (!Get.isRegistered<TaskPollingService>()) {
      Get.put<TaskPollingService>(TaskPollingService(), permanent: true);
    }
    if (!Get.isRegistered<AppStore>()) {
      Get.put<AppStore>(AppStore(), permanent: true);
    }
    if (!Get.isRegistered<TaskStore>()) {
      Get.put<TaskStore>(TaskStore(), permanent: true);
    }
    if (!Get.isRegistered<WorkStore>()) {
      Get.put<WorkStore>(WorkStore(), permanent: true);
    }

    _initialized = true;
  }

  static Future<void> _initPlatform() async {
    try {
      _platform = await PackageInfo.fromPlatform();
      AppConfig.appVersion = _platform?.version ?? AppConfig.appVersion;
      AppConfig.buildNumber = _platform?.buildNumber ?? AppConfig.buildNumber;
    } catch (_) {
      AppConfig.appVersion = '1.0.0';
      AppConfig.buildNumber = '1';
    }
  }
}
