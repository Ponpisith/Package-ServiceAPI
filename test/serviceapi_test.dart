import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serviceapi/constant/httpmethods.dart';
import 'package:serviceapi/ServiceAPI.dart';
import 'package:serviceapi/util/formdata.dart';

void main() async {
  final api = ServiceAPI(
    baseURL: 'https://jsonplaceholder.typicode.com/',
    port: '',
    headers: {'Authorization': 'Bearer YOUR_TOKEN_HERE'},
  );

  group('CRUD Testing', () {
    test('GET API Test', () async {
      final response =
          await api.sendRequest(endpoint: 'users', httpMethod: Httpmethods.get);
      expect(response.data, isNotNull);
    });

    test('POST API Test', () async {
      final response = await api.sendRequest(
          endpoint: 'posts', httpMethod: Httpmethods.post);
      expect(response.data, {'id': 101});
    });

    test('PUT API Test', () async {
      final response = await api.sendRequest(
        endpoint: 'posts/1', // Updating post with ID 1
        httpMethod: Httpmethods.put,
        data: {
          "title": "Updated Title",
          "body": "Updated content",
          "userId": 1
        },
      );
      expect(response.data, {
        'title': 'Updated Title',
        'body': 'Updated content',
        'userId': 1,
        'id': 1
      });
    });

    test('DELETE API Test', () async {
      final response = await api.sendRequest(
        endpoint: 'posts/1', // Deleting post with ID 1
        httpMethod: Httpmethods.delete,
      );
      expect(response.statusCode, 200);
    });

    test('UploadFile API', () async {
      final mockToken =
          'U2FsdGVkX1/gFJMIQqEtvxucO1Ao8Sf0CxhyIT5bGpfcYzFfvGdorSYcQvTLQ8WgYyW5Liu+cz1hklgnMaymYUFDEifaqOxLWknpwuGzbNo=';

      FormData formdata = await FormdataUtil.createFormData({
        'title': 'title test',
        'description': 'description test'
      }, files: {
        'files': [
          File('assets/files/example_file01.jpg'),
          File('assets/files/example_file02.png')
        ],
      });

      final apiUploadFile = ServiceAPI(
          baseURL: 'http://10.101.10.139',
          port: '3000',
          headers: {'Authorization': 'Bearer $mockToken'});

      // Mock the response
      final mockResponse = {
        'statusCode': 201,
        'message': 'Create Annoucement Successfully'
      };

      // Call the sendRequest method and send formData
      final response = await apiUploadFile.sendRequest(
          endpoint: '/api/v1/announcement/create',
          httpMethod: Httpmethods.post,
          formdata: formdata);

      // Verify the response
      expect(response.statusCode, mockResponse['statusCode']);
    });
  });
}
