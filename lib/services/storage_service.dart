import 'package:get_storage/get_storage.dart';

class StorageService {
  StorageService() : box = GetStorage();

  final GetStorage box;
}
