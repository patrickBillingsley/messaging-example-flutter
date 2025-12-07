import 'package:messaging_example/api/base_api.dart';
import 'package:messaging_example/models/user.dart';

class SessionApi extends BaseApi {
  Future<User> login(String email, String password) {
    return post<User>(
      '$baseApiUrl/sign_in',
      mapper: User.fromJson,
      body: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<User> signup(String email, String username, String password, String passwordConfirmation) {
    return post<User>(
      '$baseApiUrl/auth',
      mapper: User.fromJson,
      body: {
        'email': email,
        'username': username,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
  }
}
