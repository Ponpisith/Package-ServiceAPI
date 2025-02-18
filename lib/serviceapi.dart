import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'constant/authorization.dart';
import 'constant/httpmethods.dart';

class ServiceAPI {
  late final Dio _dio;
  final String _baseURL;
  final String _port;
  final Map<String, String>? _headers; //? Optional
  final Authorization _authorization;
  final String? _token;

  ServiceAPI({
    String? token,
    Map<String, String>? headers, // Optional headers
    Authorization? authorization,
    required String baseURL,
    required String port,
  })  : _baseURL = baseURL,
        _port = port,
        _headers = headers ?? {},
        _authorization = authorization ?? Authorization.none,
        _token = token {
    _dio = Dio();
    _configureDio();
  }

  String get _pathAPI {
    final portSegment = _port.isNotEmpty ? ':$_port' : '';
    return '$_baseURL$portSegment';
  }

  Map<String, dynamic>? _buildHeaders(
      Authorization authorization, String? token) {
    debugPrint('Authorization : $authorization');
    debugPrint('Token : $token');
    if (_headers!.isNotEmpty) {
      return _headers;
    }
    final baseHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (authorization == Authorization.bearerToken && token != null) {
      baseHeaders['authorization'] = 'Bearer $token';
    }

    debugPrint('baseHeaders : $baseHeaders');
    return baseHeaders;
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: _pathAPI,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 5),
      sendTimeout: const Duration(seconds: 5),
      headers: _buildHeaders(_authorization, _token),
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

  Future<Response> sendRequest({
    required String endpoint,
    FormData? formdata,
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    required Httpmethods httpMethod,
    int retryCount = 0, //? Retry count for failed requests
  }) async {
    late Response response;

    try {
      switch (httpMethod) {
        case Httpmethods.get:
          response = await _dio.get(
            endpoint,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options,
            onReceiveProgress: onReceiveProgress,
          );
          break;
        case Httpmethods.post:
          response = await _dio.post(
            endpoint,
            data: data ?? formdata,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          break;
        case Httpmethods.put:
          response = await _dio.put(
            endpoint,
            data: data ?? formdata,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          break;
        case Httpmethods.patch:
          response = await _dio.patch(
            endpoint,
            data: data ?? formdata,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          break;
        case Httpmethods.delete:
          response = await _dio.delete(
            endpoint,
            data: data ?? formdata,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options,
          );
          break;
      }
    } on DioException catch (e) {
      if (retryCount > 0) {
        debugPrint("Retrying... attempts left: $retryCount");
        return sendRequest(
          endpoint: endpoint,
          data: data ?? formdata,
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
      rethrow;
    }
    return response;
  }

  void showBaseURL() => debugPrint('BaseURL: $_pathAPI');
  void showPort() => debugPrint('Port: $_port');
}
