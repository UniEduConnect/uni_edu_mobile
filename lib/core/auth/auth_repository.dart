import '../../models/auth/auth_requests.dart';
import '../network/api_client.dart';

/// Data-access layer for the auth endpoints. Maps request DTOs to API calls and
/// returns the raw access token (login) or completes (register). Errors surface
/// as [ApiException] from the underlying [ApiClient].
class AuthRepository {
  AuthRepository(this._client);

  final ApiClient _client;

  /// `POST /api/login` → returns the JWT access token.
  Future<String> login(LoginRequest request) {
    return _client.post<String>(
      '/api/login',
      request.toJson(),
      fromData: (data) {
        final map = data as Map<String, dynamic>?;
        return map?['accessToken'] as String? ?? '';
      },
    );
  }

  /// `POST /api/register/student`.
  Future<void> registerStudent(StudentRegister request) =>
      _register('student', request.toJson());

  /// `POST /api/register/parent`.
  Future<void> registerParent(ParentRegister request) =>
      _register('parent', request.toJson());

  /// `POST /api/register/tutor`.
  Future<void> registerTutor(TutorRegister request) =>
      _register('tutor', request.toJson());

  Future<void> _register(String role, Map<String, dynamic> body) {
    // The register endpoints return `data: true`; we only care about success.
    return _client.post<void>(
      '/api/register/$role',
      body,
      fromData: (_) {},
    );
  }
}
