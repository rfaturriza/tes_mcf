import 'package:dio/dio.dart';

final dio = Dio();

void configureDio() {
  dio.options.baseUrl = 'https://equran.id';
  dio.options.connectTimeout = Duration(seconds: 5);
  dio.options.receiveTimeout = Duration(seconds: 3);
}
