import 'package:dio/dio.dart';
import 'package:serviceapi/constant/httpmethods.dart';

class ServiceAPI {
  final _dio = Dio();
  final String baseURL;
  final String port;
  final String endPonint;

  ServiceAPI(
      {required this.baseURL, required this.port, required this.endPonint});

  String get _pathAPI => '$baseURL${port.isNotEmpty ? ':$port' : ''}/';

  void _configureDio() {
    // Set default configs
    _dio.options.baseUrl = _pathAPI;
    _dio.options.connectTimeout = Duration(seconds: 5);
    _dio.options.receiveTimeout = Duration(seconds: 3);
  }

  Future<Response> request(String endPonint,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      Options? options,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      Httpmethods? httpMethod}) async {
    if (httpMethod == null) {
      throw Exception('Please enter httpMethod');
    }
    late Response response;

    _configureDio();

    switch (httpMethod) {
      //GET
      case Httpmethods.GET:
        response = await _dio.get(endPonint,
            data: data,
            cancelToken: cancelToken,
            queryParameters: queryParameters,
            onReceiveProgress: onReceiveProgress,
            options: options);
      //POST
      case Httpmethods.POST:
        response = await _dio.post(endPonint,
            data: data,
            cancelToken: cancelToken,
            queryParameters: queryParameters,
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
            options: options);
      //PUT
      case Httpmethods.PUT:
        response = await _dio.put(endPonint,
            data: data,
            cancelToken: cancelToken,
            queryParameters: queryParameters,
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
            options: options);
      //DELETE
      case Httpmethods.DELETE:
        response = await _dio.delete(endPonint,
            data: data,
            cancelToken: cancelToken,
            queryParameters: queryParameters,
            options: options);
    }
    return response;
  }

  void showbaseURL() => print('BaseURL : $baseURL');
  void showport() => print('Port : $port');
}
