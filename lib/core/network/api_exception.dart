/// Thrown when an API call fails — either a non-2xx response from the backend
/// or a transport/parsing problem on the client.
///
/// The backend returns an `ErrorResponse` (camelCase) on failures with a
/// human-readable [message] and, for validation errors, a per-field
/// [fieldErrors] map. UI should surface [message] (and optionally the field
/// errors) rather than a raw status code.
class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode,
    this.fieldErrors = const {},
  });

  /// User-facing error message taken from the backend `message`/`title`.
  final String message;

  /// HTTP status code, when the failure came from a server response.
  final int? statusCode;

  /// Field-level validation errors keyed by field name (may be empty).
  final Map<String, List<String>> fieldErrors;

  /// A fallback message for when the network can't be reached at all.
  static const ApiException network = ApiException(
    'Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối mạng.',
  );

  /// Flattens [fieldErrors] into newline-joined text for compact display,
  /// falling back to [message] when there are none.
  String get displayMessage {
    if (fieldErrors.isEmpty) return message;
    final lines = fieldErrors.values.expand((e) => e).toList();
    return lines.isEmpty ? message : lines.join('\n');
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
