/// The success envelope every backend endpoint wraps its payload in:
/// `{ statusCode, message, data }`.
///
/// Parse the envelope first, then read [data]. Use [ApiResponse.parse] with a
/// converter for the inner `data` shape.
class ApiResponse<T> {
  const ApiResponse({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  final int statusCode;
  final String message;
  final T data;

  /// Builds an [ApiResponse] from a decoded JSON map, mapping the inner `data`
  /// node through [fromData].
  factory ApiResponse.parse(
    Map<String, dynamic> json,
    T Function(Object? data) fromData,
  ) {
    return ApiResponse<T>(
      statusCode: (json['statusCode'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      data: fromData(json['data']),
    );
  }
}
