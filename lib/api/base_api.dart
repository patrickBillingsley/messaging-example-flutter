import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:messaging_example/bloc/session_bloc.dart';
import 'package:messaging_example/exceptions/server_exception.dart';
import 'package:messaging_example/mixin/logger.dart';
import 'package:messaging_example/types.dart';

class BaseApi with Logger {
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    if (SessionBloc().credentials != null) ...SessionBloc().credentials!.toHeaders(),
  };

  String get host => Platform.isAndroid ? '10.0.2.2' : 'localhost';
  String get baseUrl => 'http://$host:3000';
  String get baseApiUrl => '$baseUrl/api/v1';

  Future<(T, Headers)> fetch<T extends Object>(
    String url, {
    required T Function(Json) mapper,
  }) async {
    final response = await http.get(Uri.parse(url), headers: defaultHeaders);
    final json = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ServerException(response: response, humanReadableErrors: json['errors']);
    }

    return (mapper(json['data'] ?? json), response.headers);
  }

  Future<(List<T>, Headers)> fetchList<T extends Object>(
    String url, {
    required T Function(Json) mapper,
  }) async {
    final response = await http.get(Uri.parse(url), headers: defaultHeaders);
    final json = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ServerException(response: response, humanReadableErrors: json['errors']);
    }

    return (List<T>.from(json.map<T>((j) => mapper(j as Json))), response.headers);
  }

  Future<(T, Headers)> post<T extends Object>(
    String url, {
    required T Function(Json) mapper,
    required Json body,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: defaultHeaders,
      body: jsonEncode(body),
    );
    final json = jsonDecode(response.body);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ServerException(response: response, humanReadableErrors: json['errors']);
    }

    return (mapper(json['data'] ?? json), response.headers);
  }
}
