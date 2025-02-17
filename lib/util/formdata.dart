import 'dart:io';

import 'package:dio/dio.dart';

class FormdataUtil {
  static Future<FormData> createFormData(Map<String, String> fields,
      {Map<String, List<File>>? files}) async {
    final formData = FormData();

    fields.forEach(
      (key, value) {
        formData.fields.add(MapEntry(key, value));
      },
    );

    if (files != null) {
      for (var entry in files.entries) {
        for (var filePath in entry.value) {
          formData.files.add(MapEntry(
              entry.key,
              await MultipartFile.fromFile(filePath.path,
                  filename: filePath.path.split('/').last)));
        }
      }
    }
    return formData;
  }
}
