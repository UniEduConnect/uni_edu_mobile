import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the JWT access token in platform secure storage (Keychain on iOS,
/// EncryptedSharedPreferences on Android) — never in plain `SharedPreferences`,
/// per the backend auth guidance.
///
/// Only the access token is kept here; the refresh token is an `HttpOnly`
/// cookie owned by the backend and is not accessible to the app.
class TokenStorage {
  TokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true),
      );

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'access_token';

  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  Future<void> writeAccessToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  Future<void> clear() => _storage.delete(key: _accessTokenKey);
}
