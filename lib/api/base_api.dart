import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:messaging_example/mixin/logger.dart';
import 'package:messaging_example/types.dart';

class BaseApi with Logger {
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  String get host => Platform.isAndroid ? '10.0.2.2' : 'localhost';
  String get baseUrl => 'http://$host:3000';
  String get baseApiUrl => '$baseUrl/api/v1';

  Future<T> fetch<T extends Object>(
    String url, {
    required T Function(Json) mapper,
  }) async {
    final response = await http.get(Uri.parse(url), headers: defaultHeaders);
    final json = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(errors: json['errors']);
    }

    return mapper(json);
  }

  Future<List<T>> fetchList<T extends Object>(
    String url, {
    required T Function(Json) mapper,
  }) async {
    final response = await http.get(Uri.parse(url), headers: defaultHeaders);
    final json = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(errors: json['errors']);
    }

    return List<T>.from(json.map<T>(mapper));
  }

  Future<T> post<T extends Object>(
    String url, {
    required T Function(Json) mapper,
    required Map<String, dynamic> body,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: defaultHeaders,
      body: jsonEncode(body),
    );
    final json = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(errors: json['errors']);
    }

    return mapper(json);
  }
}

class ApiException implements Exception {
  final Map<String, dynamic> errors = {};

  ApiException({
    required Map<String, dynamic> errors,
  }) {
    final keys = errors.keys.where((key) => key != 'full_messages');
    for (final key in keys) {
      this.errors[key] = '${key.capitalize()} ${(List<String>.from(errors[key])).firstOrNull}.';
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return substring(0, 1).toUpperCase() + substring(1);
  }
}
