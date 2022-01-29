import 'package:dotenv/dotenv.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtHelpers {
  JwtHelpers._();
  static final String _jwtSecret = env['JWT_SECRET'] ?? env['jwtSecret']!;

  static JwtClaim getClaim(String token) {
    return verifyJwtHS256Signature(token, _jwtSecret);
  }
}
