import 'package:dotenv/dotenv.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtHelpers {
  JwtHelpers._();
  static final String _jwtSecret = env['JWT_SECRET'] ?? env['jwtSecret']!;

  static String generateJWT(int userId, int? supplierId) {
    final claimSet = JwtClaim(
      issuer: 'cuidapet',
      subject: userId.toString(),
      expiry: DateTime.now().add(
        const Duration(days: 1),
      ),
      notBefore: DateTime.now(),
      issuedAt: DateTime.now(),
      otherClaims: <String, dynamic>{
        'supplier': supplierId,
      },
      maxAge: const Duration(days: 1),
    );
    return 'Bearer ${issueJwtHS256(claimSet, _jwtSecret)}';
  }

  static JwtClaim getClaim(String token) {
    return verifyJwtHS256Signature(token, _jwtSecret);
  }
}
