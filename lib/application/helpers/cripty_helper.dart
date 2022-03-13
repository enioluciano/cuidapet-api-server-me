import 'dart:convert';
import 'package:crypto/crypto.dart';

class CriptyHelper {
  CriptyHelper._();
  //criptografar a senha
  static String generateSha256Hash(String passowrd) {
    final bytes = utf8.encode(passowrd);
    return sha256.convert(bytes).toString();
  }
}
