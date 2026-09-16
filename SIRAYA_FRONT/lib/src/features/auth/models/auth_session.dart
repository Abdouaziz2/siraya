import 'package:nioudem/src/features/auth/models/siraya_user.dart';

class AuthSession {
  const AuthSession({
    required this.token,
    required this.user,
    required this.profileComplete,
  });

  final String token;
  final SirayaUser user;
  final bool profileComplete;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      token: json['token']?.toString() ?? '',
      user: SirayaUser.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      profileComplete: json['profileComplete'] == true,
    );
  }
}
