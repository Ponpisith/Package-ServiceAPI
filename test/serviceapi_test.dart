import 'package:flutter_test/flutter_test.dart';
import 'package:serviceapi/constant/httpmethods.dart';
import 'package:serviceapi/serviceapi.dart';

void main() {
  final api = ServiceAPI(
    baseURL: 'https://jsonplaceholder.typicode.com/',
    port: '',
    headers: {'Authorization': 'Bearer YOUR_TOKEN_HERE'},
  );

  group('CRUD Testing', () {
    test('GET API Test', () async {
      final response =
          await api.request(endpoint: 'users', httpMethod: Httpmethods.GET);
      expect(response.data, isNotNull);
    });

    test('POST API Test', () async {
      final response =
          await api.request(endpoint: 'posts', httpMethod: Httpmethods.POST);
      expect(response.data, {'id': 101});
    });

    test('PUT API Test', () async {
      final response = await api.request(
        endpoint: 'posts/1', // Updating post with ID 1
        httpMethod: Httpmethods.PUT,
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
      final response = await api.request(
        endpoint: 'posts/1', // Deleting post with ID 1
        httpMethod: Httpmethods.DELETE,
      );
      expect(response.statusCode, 200);
    });
  });

  // group('Service Handle Error', () {
  //   test('GET API Test', () async {
  //     final response =
  //         await api.request(endpoint: 'usersa', httpMethod: Httpmethods.GET);
  //     expect(response.statusCode, 404);
  //   });
  // });
}
