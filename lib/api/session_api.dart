import 'package:messaging_example/api/base_api.dart';
import 'package:messaging_example/models/credentials.dart';
import 'package:messaging_example/models/user.dart';

class SessionApi extends BaseApi {
  Future<(User, Credentials)> login(String email, String password) async {
    final (user, headers) = await post<User>(
      '$baseApiUrl/auth/sign_in',
      mapper: User.fromJson,
      body: {
        'email': email,
        'password': password,
      },
    );

    return (user, Credentials.from(headers));
  }

  Future<User> signup(String email, String username, String password, String passwordConfirmation) async {
    final (user, _) = await post<User>(
      '$baseApiUrl/auth',
      mapper: User.fromJson,
      body: {
        'email': email,
        'username': username,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    return user;
  }
}
