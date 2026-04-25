import 'package:get/get.dart';

import '../../store/index.dart';

class HomeController extends GetxController {
  WorkStore get workStore => WorkStore.to;
}
