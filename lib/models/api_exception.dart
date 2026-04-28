/// 统一的接口异常模型。
///
/// 用于承载后端返回的错误信息和状态码，便于上层统一处理。
class ApiException implements Exception {
  const ApiException({required this.message, this.code, this.statusCode});

  /// 业务错误码（可选）。
  final int? code;

  /// HTTP 状态码（可选）。
  final int? statusCode;

  /// 错误消息。
  final String message;

  @override
  String toString() {
    final parts = <String>[
      if (code != null) 'code=$code',
      if (statusCode != null) 'status=$statusCode',
      message,
    ];
    return 'ApiException(${parts.join(', ')})';
  }
}
