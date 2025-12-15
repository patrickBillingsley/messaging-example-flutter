import 'package:http/http.dart' as http;
import 'package:messaging_example/extensions/string_extension.dart';

class ServerException implements Exception {
  final http.Response response;
  final Map<String, dynamic> userReadableErrors = {};

  ServerException({
    required this.response,
    Map<String, dynamic>? humanReadableErrors,
  }) {
    final keys = humanReadableErrors?.keys.where((key) => key != 'full_messages');
    if (keys != null) {
      for (final key in keys) {
        userReadableErrors[key] = '${key.capitalize()} ${(List<String>.from(humanReadableErrors?[key])).firstOrNull}.';
      }
    }
  }
}
