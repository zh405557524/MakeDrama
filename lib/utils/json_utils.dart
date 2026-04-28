Map<String, dynamic> jsonMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}

List<Map<String, dynamic>> jsonMapList(dynamic value) {
  if (value is! List) return <Map<String, dynamic>>[];
  return value.map(jsonMap).where((item) => item.isNotEmpty).toList();
}

List<String> jsonStringList(dynamic value) {
  if (value is! List) return <String>[];
  return value
      .where((item) => item != null)
      .map((item) => item.toString())
      .toList();
}

String? jsonString(dynamic value) {
  if (value == null) return null;
  final text = value.toString();
  return text.isEmpty ? null : text;
}

String jsonStringValue(dynamic value, {String fallback = ''}) {
  return jsonString(value) ?? fallback;
}

int jsonInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

bool jsonBool(dynamic value, {bool fallback = false}) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.toLowerCase();
    if (normalized == 'true' || normalized == '1') return true;
    if (normalized == 'false' || normalized == '0') return false;
  }
  return fallback;
}
