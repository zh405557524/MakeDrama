import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService extends GetxService {
  GetStorage? _box;
  final Map<String, dynamic> _memory = {};

  static const _installationIdKey = 'installation_id';

  Future<StorageService> init() async {
    if (!Get.testMode) {
      await GetStorage.init();
      _box = GetStorage();
    }
    _ensureInstallationId();
    return this;
  }

  String get installationId => get<String>(_installationIdKey)!;

  T? get<T>(String key) {
    if (Get.testMode) return _memory[key] as T?;
    return _box!.read<T>(key);
  }

  Future<void> set(String key, dynamic value) async {
    if (Get.testMode) {
      _memory[key] = value;
      return;
    }
    await _box!.write(key, value);
  }

  Future<void> remove(String key) async {
    if (Get.testMode) {
      _memory.remove(key);
      return;
    }
    await _box!.remove(key);
  }

  Future<void> clear() async {
    final installationId = this.installationId;
    if (Get.testMode) {
      _memory.clear();
      _memory[_installationIdKey] = installationId;
      return;
    }
    await _box!.erase();
    await set(_installationIdKey, installationId);
  }

  void _ensureInstallationId() {
    final stored = get<String>(_installationIdKey);
    if (stored != null && stored.isNotEmpty) return;
    final installationId = 'install-${const Uuid().v4()}';
    if (Get.testMode) {
      _memory[_installationIdKey] = installationId;
      return;
    }
    _box!.write(_installationIdKey, installationId);
  }
}
