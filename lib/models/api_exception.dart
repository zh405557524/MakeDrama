class ApiException implements Exception {
  const ApiException({required this.message, this.code, this.statusCode});

  final int? code;
  final int? statusCode;
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
