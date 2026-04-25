import 'package:get/get.dart';

class AppStore extends GetxController {
  static AppStore get to => Get.find<AppStore>();

  String installationId = 'local-device';
}
