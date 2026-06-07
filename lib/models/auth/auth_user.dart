import 'dart:convert';

import 'auth_role.dart';

/// The signed-in user, decoded from the JWT access token's claims.
///
/// The backend mints tokens with .NET `ClaimTypes`, so the claim keys are the
/// long XML-schema URIs (e.g. `.../nameidentifier`); we also accept the short
/// names as a fallback. We only *read* the token client-side for display — the
/// server remains the source of truth on every request.
class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.role,
    this.name = '',
  });

  final String id;
  final String email;
  final AuthRole? role;

  /// The user's full name (`fullname` claim); empty when the token omits it.
  final String name;

  static const _idClaims = [
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier',
    'nameid',
    'sub',
  ];
  static const _emailClaims = [
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress',
    'email',
  ];
  static const _roleClaims = [
    'http://schemas.microsoft.com/ws/2008/06/identity/claims/role',
    'role',
  ];
  static const _nameClaims = [
    'fullname',
    'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name',
    'unique_name',
    'name',
  ];

  /// Decodes the claims of a JWT [accessToken]. Returns null if the token is
  /// malformed or its payload can't be parsed.
  static AuthUser? fromJwt(String accessToken) {
    final claims = _decodePayload(accessToken);
    if (claims == null) return null;
    return AuthUser(
      id: _first(claims, _idClaims) ?? '',
      email: _first(claims, _emailClaims) ?? '',
      role: AuthRole.tryParse(_first(claims, _roleClaims)),
      name: _first(claims, _nameClaims) ?? '',
    );
  }

  static String? _first(Map<String, dynamic> claims, List<String> keys) {
    for (final key in keys) {
      final value = claims[key];
      if (value != null) return '$value';
    }
    return null;
  }

  static Map<String, dynamic>? _decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    try {
      final normalized = base64Url.normalize(parts[1]);
      final payload = utf8.decode(base64Url.decode(normalized));
      final decoded = jsonDecode(payload);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }
}
