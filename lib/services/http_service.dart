import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../models/index.dart';
import '../utils/index.dart';
import 'storage_service.dart';

class HttpService extends GetxService {
  static HttpService get to => Get.find<HttpService>();

  HttpService() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: const {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final storage = Get.isRegistered<StorageService>()
              ? Get.find<StorageService>()
              : null;
          options.headers['X-Installation-Id'] =
              storage?.installationId ?? 'local-device';
          options.headers['X-App-Version'] = AppConfig.appVersion;
          options.headers['X-Timezone'] = AppConfig.timezone;
          return handler.next(options);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  late final Dio dio;
  final Uuid _uuid = const Uuid();

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return dio.get<T>(path, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool idempotent = true,
  }) async {
    return dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: _withIdempotency(options, idempotent),
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<dynamic> getData(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _unwrap(await get<dynamic>(path, queryParameters: queryParameters));
  }

  Future<dynamic> postData(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool idempotent = true,
  }) async {
    return _unwrap(
      await post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        idempotent: idempotent,
      ),
    );
  }

  Future<dynamic> putData(String path, {dynamic data}) async {
    return _unwrap(await put<dynamic>(path, data: data));
  }

  Future<dynamic> deleteData(String path, {dynamic data}) async {
    return _unwrap(await delete<dynamic>(path, data: data));
  }

  Options? _withIdempotency(Options? options, bool enabled) {
    if (!enabled) return options;
    final headers = <String, dynamic>{
      ...?options?.headers,
      'Idempotency-Key': _uuid.v4(),
    };
    if (options == null) return Options(headers: headers);
    return options.copyWith(headers: headers);
  }

  dynamic _unwrap(Response<dynamic> response) {
    final body = response.data;
    if (body is Map) {
      final map = jsonMap(body);
      if (map.containsKey('code')) {
        final code = jsonInt(map['code']);
        if (code != 0) {
          throw ApiException(
            code: code,
            statusCode: response.statusCode,
            message: jsonStringValue(map['message'], fallback: '请求失败'),
          );
        }
        return map['data'];
      }
    }
    return body;
  }
}
