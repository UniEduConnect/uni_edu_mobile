/// Request payloads for the auth endpoints, mirroring the backend DTOs.
///
/// Each class only carries data + a `toJson()` matching the C# DTO property
/// names (the API serializes/deserializes camelCase). Validation lives in the
/// UI and the backend; these stay dumb.
library;

/// Body for `POST /api/login` (`LoginRequest`).
class LoginRequest {
  const LoginRequest({required this.email, required this.password});

  final String email;
  final String password;

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

/// Fields shared by every register endpoint (`BaseRegisterDTO`).
class BaseRegister {
  const BaseRegister({
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.fullname,
  });

  final String email;
  final String password;
  final String phoneNumber;
  final String fullname;

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'phoneNumber': phoneNumber,
    'fullname': fullname,
  };
}

/// Body for `POST /api/register/student` (`StudentRegister`).
class StudentRegister extends BaseRegister {
  const StudentRegister({
    required super.email,
    required super.password,
    required super.phoneNumber,
    required super.fullname,
    required this.school,
    required this.grade,
  });

  final String school;
  final int grade;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'school': school,
    'grade': grade,
  };
}

/// Body for `POST /api/register/parent` (`ParentRegister` — base fields only).
class ParentRegister extends BaseRegister {
  const ParentRegister({
    required super.email,
    required super.password,
    required super.phoneNumber,
    required super.fullname,
  });
}

/// Body for `POST /api/register/tutor` (`TutorRegister`).
class TutorRegister extends BaseRegister {
  const TutorRegister({
    required super.email,
    required super.password,
    required super.phoneNumber,
    required super.fullname,
    required this.gender,
    required this.degree,
    this.studentIdNumber,
  });

  final String gender;
  final String degree;
  final String? studentIdNumber;

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    'gender': gender,
    'degree': degree,
    if (studentIdNumber != null && studentIdNumber!.isNotEmpty)
      'studentIdNumber': studentIdNumber,
  };
}
