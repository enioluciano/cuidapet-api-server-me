import 'dart:convert';

import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/src/response.dart';

import 'package:shelf/src/request.dart';

import '../../helpers/jwt_helper.dart';
import '../../logger/i_logger.dart';
import '../middlewares.dart';
import 'security_skip_url.dart';

class SecutirtyMiddleware extends Middlewares {
  final ILogger log;
  final skypUrl = <SecuritySkipUrl>[
    SecuritySkipUrl(url: '/auth/register', method: 'POST'),
    SecuritySkipUrl(url: '/auth/', method: 'POST'),
  ];

  SecutirtyMiddleware(this.log);
  @override
  Future<Response> execute(Request request) async {
    try {
      //se nao precisar de token vai executar apenas esse.
      if (skypUrl.contains(SecuritySkipUrl(
          url: '/${request.url.path}', method: request.method))) {
        return innerHandler(request);
      }

      final authHeader = request.headers['Authorization'];
      if (authHeader == null || authHeader.isEmpty) {
        throw JwtException.invalidToken;
      }
      final authHeaderContent = authHeader
          .split(' '); // quebrar o Bearer com o token --> Bearer dasdsa
      if (authHeaderContent[0] != 'Bearer') {
        throw JwtException.invalidToken;
      }

      final authorizationToken = authHeaderContent[1];
      final claims = JwtHelper.getClaim(
          authorizationToken); //validar, descriptografar e pegar as informacoes do token
      if (request.url.path != 'auth/refresh') {
        claims.validate();
      }
      final claimsMap = claims.toJson();
      final userId = claimsMap['sub'];
      final supplierId = claimsMap[
          'supplier']; //customizado mas pode ser usado o padrao do jwt

      if (userId == null) {
        throw JwtException.invalidToken;
      }
      final securityHeaders = {
        'user': userId,
        'access_token': authorizationToken,
        'supplier': supplierId
      };
      return innerHandler(request.change(headers: securityHeaders));
    } on JwtException catch (e, s) {
      log.error('Erro ao validar token JWT', error: e, stackTrace: s);
      return Response.forbidden(jsonEncode({}));
    } catch (e, s) {
      log.error('Internal Server Error', error: e, stackTrace: s);
      return Response.forbidden(jsonEncode({}));
    }
  }
}
