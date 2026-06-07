/// The account roles supported by the backend (`UserRole` enum).
///
/// [wire] is the value as it appears in the JWT `role` claim and in the
/// `/register/{role}` route segment; [label] is the Vietnamese display name.
enum AuthRole {
  admin('Admin', 'Quản trị viên'),
  tutor('Tutor', 'Gia sư'),
  parent('Parent', 'Phụ huynh'),
  student('Student', 'Học sinh');

  const AuthRole(this.wire, this.label);

  /// Value used on the wire (JWT claim / route segment).
  final String wire;

  /// Vietnamese label for the UI.
  final String label;

  /// Route segment for `POST /api/register/{role}` (lowercase [wire]).
  String get registerPath => wire.toLowerCase();

  /// Parses a backend role string (case-insensitive); null if unknown.
  static AuthRole? tryParse(String? value) {
    if (value == null) return null;
    for (final role in AuthRole.values) {
      if (role.wire.toLowerCase() == value.toLowerCase()) return role;
    }
    return null;
  }
}
