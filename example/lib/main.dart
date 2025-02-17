import 'package:flutter/material.dart';
import 'package:serviceapi/constant/httpmethods.dart';
import 'package:serviceapi/serviceapi.dart';

void main() async {
  final api = ServiceAPI(
    baseURL: 'https://jsonplaceholder.typicode.com/',
    port: '',
    headers: {'Authorization': 'Bearer YOUR_TOKEN_HERE'},
  );

  try {
    final response = await api.request(
      endpoint: 'users',
      httpMethod: Httpmethods.GET,
      retryCount: 2,
    );
    debugPrint("Response: ${response.data}");
  } catch (e) {
    debugPrint("API Error: $e");
  }
}
