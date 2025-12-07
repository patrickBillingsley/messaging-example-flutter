import 'package:messaging_example/api/base_api.dart';
import 'package:messaging_example/api/session_api.dart';
import 'package:messaging_example/mixin/logger.dart';
import 'package:messaging_example/models/user.dart';
import 'package:rxdart/rxdart.dart';

class SessionBloc with Logger {
  static SessionBloc? _instance;
  SessionApi _api;

  factory SessionBloc({SessionApi? api}) {
    return _instance ??= SessionBloc._(api);
  }

  SessionBloc._(
    api,
  ) : _api = api ?? SessionApi();

  final BehaviorSubject<User?> _currentUserSubject = BehaviorSubject();
  Stream<User?> get currentUserStream => _currentUserSubject.stream;
  User? get currentUser => _currentUserSubject.valueOrNull;

  Future<void> login({required String email, required String password}) async {
    try {
      final user = await _api.login(email, password);
      _currentUserSubject.add(user);
    } on ApiException catch (err) {
      log.warning('${err.runtimeType} occurred while logging in.', err);
      _currentUserSubject.addError(err);
    }
  }

  Future<void> signup({
    required String email,
    required String username,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final user = await _api.signup(email, username, password, passwordConfirmation);
      _currentUserSubject.add(user);
    } on ApiException catch (err) {
      log.warning('${err.runtimeType} occurred while signing up.', err);
      _currentUserSubject.addError(err);
    }
  }
}
