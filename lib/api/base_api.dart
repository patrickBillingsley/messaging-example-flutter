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
  String get baseApiUrl => 'http://$host:3000/api/v1';

  Future<T> fetch<T extends Object>(
    String url, {
    required T Function(Json) mapper,
  }) async {
    final response = await http.get(Uri.parse(url), headers: defaultHeaders);
    final json = jsonDecode(response.body);

    return mapper(json);
  }

  Future<List<T>> fetchList<T extends Object>(
    String url, {
    required T Function(Json) mapper,
  }) async {
    final response = await http.get(Uri.parse(url), headers: defaultHeaders);
    final json = List<Json>.from(jsonDecode(response.body));

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

    return mapper(json);
  }
}
