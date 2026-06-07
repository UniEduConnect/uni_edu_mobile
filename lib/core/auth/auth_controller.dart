import 'package:flutter/foundation.dart';

import '../../models/auth/auth_requests.dart';
import '../../models/auth/auth_user.dart';
import '../network/api_client.dart';
import 'auth_repository.dart';
import 'token_storage.dart';

/// App-wide authentication state and the single entry point for auth actions.
///
/// This is the project's chosen state-management pattern for cross-screen
/// state: a [ChangeNotifier] exposed through an `InheritedNotifier`
/// (`AuthScope`). It owns the [ApiClient] (so the bearer token is set in one
/// place), the [AuthRepository] (network calls), and the [TokenStorage]
/// (secure persistence).
///
/// Screens call [login] / [registerStudent] / … and `await` the result; on
/// success the controller updates [user] and notifies listeners. Errors are
/// rethrown as [ApiException] for the screen to display.
class AuthController extends ChangeNotifier {
  AuthController({ApiClient? client, AuthRepository? repository, TokenStorage? storage})
    : _client = client ?? ApiClient(),
      _storage = storage ?? TokenStorage() {
    _repository = repository ?? AuthRepository(_client);
  }

  final ApiClient _client;
  final TokenStorage _storage;
  late final AuthRepository _repository;

  AuthUser? _user;

  /// The signed-in user (decoded from the JWT), or null when logged out.
  AuthUser? get user => _user;

  /// Whether a valid access token is loaded.
  bool get isLoggedIn => _user != null;

  /// Loads any persisted token at startup so a returning user stays signed in.
  Future<void> bootstrap() async {
    final token = await _storage.readAccessToken();
    if (token == null || token.isEmpty) return;
    _applyToken(token);
  }

  /// Signs in and persists the token. Throws [ApiException] on failure.
  Future<void> login(LoginRequest request) async {
    final token = await _repository.login(request);
    await _storage.writeAccessToken(token);
    _applyToken(token);
  }

  Future<void> registerStudent(StudentRegister request) =>
      _repository.registerStudent(request);

  Future<void> registerParent(ParentRegister request) =>
      _repository.registerParent(request);

  Future<void> registerTutor(TutorRegister request) =>
      _repository.registerTutor(request);

  /// Clears local auth state and the persisted token.
  Future<void> logout() async {
    await _storage.clear();
    _client.bearerToken = null;
    _user = null;
    notifyListeners();
  }

  void _applyToken(String token) {
    _client.bearerToken = token;
    _user = AuthUser.fromJwt(token);
    notifyListeners();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }
}
