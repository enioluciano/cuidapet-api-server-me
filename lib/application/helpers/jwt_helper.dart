import 'package:dotenv/dotenv.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

class JwtHelper {
  static final String _jwtSecret = env['JWT_SECRET'] ?? env['jwtSecret']!;
  JwtHelper._();

  static String generateJWT(int userId, int? supplierId) {
    final claimSet = JwtClaim(
        issuer: 'cuidapet',
        subject: userId.toString(),
        expiry: DateTime.now().add(Duration(seconds: 20)),
        notBefore: DateTime.now(),
        issuedAt: DateTime.now(),
        otherClaims: <String, dynamic>{'supplier': supplierId},
        maxAge: const Duration(days: 1));
    return 'Bearer ${issueJwtHS256(claimSet, _jwtSecret)}';
  }

  static getClaim(String token) {
    return verifyJwtHS256Signature(token, _jwtSecret);
  }

  static String refreshToken(String accessToken) {
    final claimSet = JwtClaim(
        issuer: accessToken,
        subject: 'refreshToken',
        expiry: DateTime.now().add(Duration(days: 20)),
        // notBefore: DateTime.now(),
        issuedAt: DateTime.now(),
        otherClaims: <String, dynamic>{},
        maxAge: const Duration(days: 1));
    return 'Bearer ${issueJwtHS256(claimSet, _jwtSecret)}';
  }
}
