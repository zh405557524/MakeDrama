import 'package:dio/dio.dart';

class HttpService {
  HttpService() : dio = Dio();

  final Dio dio;
}
