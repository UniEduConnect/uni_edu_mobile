// Unit tests for the auth layer: model parsing/serialization and the API
// client's envelope-unwrapping + error mapping (with a mocked HTTP client).
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

import 'package:uni_edu_mobile/core/auth/auth_repository.dart';
import 'package:uni_edu_mobile/core/network/api_client.dart';
import 'package:uni_edu_mobile/core/network/api_exception.dart';
import 'package:uni_edu_mobile/models/auth/auth_requests.dart';
import 'package:uni_edu_mobile/models/auth/auth_role.dart';
import 'package:uni_edu_mobile/models/auth/auth_user.dart';

/// Builds a fake (unsigned) JWT carrying [claims] as its payload.
String fakeJwt(Map<String, dynamic> claims) {
  String seg(Map<String, dynamic> m) =>
      base64Url.encode(utf8.encode(jsonEncode(m)));
  return '${seg({'alg': 'HS256'})}.${seg(claims)}.signature';
}

void main() {
  group('AuthRole', () {
    test('tryParse is case-insensitive and maps to register path', () {
      expect(AuthRole.tryParse('student'), AuthRole.student);
      expect(AuthRole.tryParse('TUTOR'), AuthRole.tutor);
      expect(AuthRole.tryParse('unknown'), isNull);
      expect(AuthRole.student.registerPath, 'student');
    });
  });

  group('Register request serialization', () {
    test('StudentRegister includes school and grade', () {
      final json = const StudentRegister(
        email: 'a@b.com',
        password: 'secret1',
        phoneNumber: '0900000000',
        fullname: 'A B',
        school: 'THPT X',
        grade: 10,
      ).toJson();
      expect(json['email'], 'a@b.com');
      expect(json['school'], 'THPT X');
      expect(json['grade'], 10);
    });

    test('TutorRegister omits an empty studentIdNumber', () {
      final json = const TutorRegister(
        email: 'a@b.com',
        password: 'secret1',
        phoneNumber: '0900000000',
        fullname: 'A B',
        gender: 'Nam',
        degree: 'Cử nhân',
        studentIdNumber: '',
      ).toJson();
      expect(json.containsKey('studentIdNumber'), isFalse);
      expect(json['gender'], 'Nam');
    });
  });

  group('AuthUser.fromJwt', () {
    test('decodes .NET ClaimTypes claim URIs', () {
      final token = fakeJwt({
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier':
            'user-123',
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress':
            'a@b.com',
        'http://schemas.microsoft.com/ws/2008/06/identity/claims/role':
            'Student',
        'fullname': 'Nguyễn Văn A',
      });
      final user = AuthUser.fromJwt(token);
      expect(user, isNotNull);
      expect(user!.id, 'user-123');
      expect(user.email, 'a@b.com');
      expect(user.role, AuthRole.student);
      expect(user.name, 'Nguyễn Văn A');
    });

    test('returns null for a malformed token', () {
      expect(AuthUser.fromJwt('not-a-jwt'), isNull);
    });
  });

  group('ApiClient via AuthRepository', () {
    test('login unwraps the access token from the ApiResponse envelope', () async {
      final mock = MockClient((request) async {
        expect(request.url.path, '/api/login');
        return http.Response(
          jsonEncode({
            'statusCode': 200,
            'message': 'Login successful',
            'data': {'accessToken': 'the-token'},
          }),
          200,
        );
      });
      final repo = AuthRepository(ApiClient(httpClient: mock));
      final token = await repo.login(
        const LoginRequest(email: 'a@b.com', password: 'secret1'),
      );
      expect(token, 'the-token');
    });

    test('maps an error body to ApiException with message + field errors',
        () async {
      final mock = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'message': 'Validation failed',
            'errors': {
              'email': ['Email is already taken.'],
            },
          }),
          400,
        );
      });
      final repo = AuthRepository(ApiClient(httpClient: mock));
      expect(
        () => repo.registerParent(
          const ParentRegister(
            email: 'a@b.com',
            password: 'secret1',
            phoneNumber: '0900000000',
            fullname: 'A B',
          ),
        ),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 400)
              .having((e) => e.displayMessage, 'displayMessage',
                  contains('Email is already taken.')),
        ),
      );
    });
  });
}
