import 'package:messaging_example/types.dart';

class Credentials {
  final String token;
  final String client;
  final String uid;

  const Credentials({
    required this.token,
    required this.client,
    required this.uid,
  });

  factory Credentials.from(Headers headers) {
    return Credentials(
      token: headers['access-token'] as String,
      client: headers['client'] as String,
      uid: headers['uid'] as String,
    );
  }

  Map<String, String> toHeaders() {
    return {
      'access-token': token,
      'client': client,
      'uid': uid,
    };
  }
}
