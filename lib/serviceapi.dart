import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:serviceapi/constant/httpmethods.dart';
import 'package:serviceapi/util/handleError.dart';

class ServiceAPI {
  late final Dio _dio;
  // final BuildContext context;
  final String baseURL;
  final String port;
  final Map<String, String>? headers;

  ServiceAPI(
    {
    // required this.context,
    required this.baseURL,
    required this.port,
    this.headers, // Optional headers
  }) {
    _dio = Dio();
    _configureDio();
  }

  String get _pathAPI => '$baseURL${port.isNotEmpty ? ':$port' : ''}';

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: _pathAPI,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
      contentType: 'application/json',
      headers: {
        'Accept': 'application/json',
        ...?headers,
      },
    );

    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        debugPrint("Request to: ${options.uri}");
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint("Response: ${response.statusCode}");
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        debugPrint("Error: ${e.message}");
        return handler.next(e);
      },
    ));
  }

  Future<Response> request({
    required String endpoint,
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    required Httpmethods httpMethod,
    int retryCount = 0, // Retry count for failed requests
  }) async {
    late Response response;

    try {
      switch (httpMethod) {
        case Httpmethods.GET:
          response = await _dio.get(
            endpoint,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options,
            onReceiveProgress: onReceiveProgress,
          );
          break;
        case Httpmethods.POST:
          response = await _dio.post(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          break;
        case Httpmethods.PUT:
          response = await _dio.put(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          break;
        case Httpmethods.DELETE:
          response = await _dio.delete(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options,
          );
          break;
      }
    } on DioException catch (e) {
      if (retryCount > 0) {
        debugPrint("Retrying... attempts left: $retryCount");
        return request(
          endpoint: endpoint,
          data: data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
          httpMethod: httpMethod,
          retryCount: retryCount - 1,
        );
      }
      debugPrint("Request failed: ${e.message}");
      // HandleError(
      //     context: context,
      //     title: 'Error',
      //     content: e.message ?? 'Unknow Error');
      rethrow;
    }
    return response;
  }

  void showBaseURL() => debugPrint('BaseURL: $_pathAPI');
  void showPort() => debugPrint('Port: $port');
}
