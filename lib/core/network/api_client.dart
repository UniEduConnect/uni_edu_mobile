import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/api_response.dart';
import 'api_config.dart';
import 'api_exception.dart';

/// Thin HTTP client over [http] that knows the UNI-EDU API conventions:
///
/// - prefixes requests with [ApiConfig.baseUrl];
/// - sends/receives JSON;
/// - unwraps the `ApiResponse<T>` envelope on success;
/// - maps non-2xx `ErrorResponse` bodies (and transport failures) to
///   [ApiException] so callers handle one error type.
///
/// It is deliberately tiny and stateless apart from an optional bearer token —
/// auth state lives in the auth layer, not here.
class ApiClient {
  ApiClient({http.Client? httpClient, this.bearerToken})
    : _http = httpClient ?? http.Client();

  final http.Client _http;

  /// Access token sent as `Authorization: Bearer <token>` when present.
  String? bearerToken;

  static const Duration _timeout = Duration(seconds: 20);

  /// POSTs [body] as JSON to [path] and returns the parsed `data` node, mapped
  /// through [fromData]. Throws [ApiException] on any failure.
  Future<T> post<T>(
    String path,
    Map<String, dynamic> body, {
    required T Function(Object? data) fromData,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    http.Response response;
    try {
      response = await _http
          .post(uri, headers: _headers, body: jsonEncode(body))
          .timeout(_timeout);
    } catch (_) {
      throw ApiException.network;
    }
    return _handle<T>(response, fromData);
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (bearerToken != null) 'Authorization': 'Bearer $bearerToken',
  };

  T _handle<T>(http.Response response, T Function(Object? data) fromData) {
    final decoded = _tryDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final envelope = ApiResponse<T>.parse(
        decoded is Map<String, dynamic> ? decoded : <String, dynamic>{},
        fromData,
      );
      return envelope.data;
    }

    throw _toException(response.statusCode, decoded);
  }

  Object? _tryDecode(String body) {
    if (body.isEmpty) return null;
    try {
      return jsonDecode(body);
    } catch (_) {
      return null;
    }
  }

  /// Maps an error body to [ApiException]. The backend `ErrorResponse` is
  /// camelCase with an optional field-level `errors` map.
  ApiException _toException(int statusCode, Object? decoded) {
    if (decoded is! Map<String, dynamic>) {
      return ApiException('Đã có lỗi xảy ra (mã $statusCode).', statusCode: statusCode);
    }

    final message =
        decoded['message'] as String? ??
        decoded['title'] as String? ??
        'Đã có lỗi xảy ra (mã $statusCode).';

    final fieldErrors = <String, List<String>>{};
    final errors = decoded['errors'];
    if (errors is Map) {
      errors.forEach((key, value) {
        if (value is List) {
          fieldErrors['$key'] = value.map((e) => '$e').toList();
        } else if (value != null) {
          fieldErrors['$key'] = ['$value'];
        }
      });
    }

    return ApiException(message, statusCode: statusCode, fieldErrors: fieldErrors);
  }

  /// Releases the underlying connection pool.
  void close() => _http.close();
}
