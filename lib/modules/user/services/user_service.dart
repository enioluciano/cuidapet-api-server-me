import 'package:injectable/injectable.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:server/application/exceptions/service_exception.dart';
import 'package:server/application/exceptions/user_not_found_exception.dart';
import 'package:server/application/helpers/jwt_helper.dart';
import 'package:server/application/logger/i_logger.dart';
import 'package:server/modules/user/view_models/refresh_token_view_model.dart';
import 'package:server/modules/user/view_models/user_confirm_input_model.dart';
import 'package:server/modules/user/view_models/user_refresh_token_input_model.dart';

import '../../../entities/user.dart';
import '../data/i_user_repository.dart';
import '../view_models/user_save_input_model.dart';
import './i_user_service.dart';

@LazySingleton(as: IUserService)
class UserService implements IUserService {
  IUserRepository userRepository;
  ILogger log;
  UserService({required this.userRepository, required this.log});

  @override
  Future<User> createUser(UserSaveInputModel user) {
    final userEntity = User(
        email: user.email,
        password: user.password,
        registerType: 'App',
        supplierId: user.supplierId);
    return userRepository.createUser(userEntity);
  }

  @override
  Future<User> loginWithEmailPassword(
          String email, String password, bool supplierUser) =>
      userRepository.loginWithEmailPassword(email, password, supplierUser);

  @override
  Future<User> loginWithSocial(
      String email, String? avatar, String socialType, String socialKey) async {
    try {
      return await userRepository.loginByEmailSocialKey(
          email, socialKey, socialType);
    } on UserNotFoundException catch (err) {
      log.error('Usuario não encontrado, criando um usuário', error: err);
      final user = User(
          email: email,
          imageAvatar: avatar,
          registerType: socialType,
          socialKey: socialKey,
          password: DateTime.now().toString());
      return await userRepository.createUser(user);
    }
  }

  @override
  Future<String> confirmLogin(UserConfirmInputModel inputModel) async {
    final user = User(
        id: inputModel.userId,
        refreshToken: JwtHelper.refreshToken(inputModel.accessToken),
        iosToken: inputModel.iosDeviceToken,
        androidToken: inputModel.androidDeviceToken);

    await userRepository.updateUserDeviceTokenAndRefreshToken(user);
    return user.refreshToken!;
  }

  @override
  Future<RefreshTokenViewModel> refreshToken(
      UserRefreshTokenInputModel model) async {
    _validateRefreshToken(model);
    final newAccessToken = JwtHelper.generateJWT(model.user, model.supplier);
    final newRefreshToken =
        JwtHelper.refreshToken(newAccessToken.replaceAll('Bearer', ''));
    final user = User(id: model.user, refreshToken: model.refreshToken);
    await userRepository.updateRefreshToken(user);
    return RefreshTokenViewModel(
        accessToken: newAccessToken, refreshToken: newRefreshToken);
  }

  void _validateRefreshToken(UserRefreshTokenInputModel model) {
    try {
      final refreshToken = model.refreshToken.split(' ');

      if (refreshToken.length != 2 || refreshToken.first != 'Bearer') {
        log.error('Refresh token invalido');
        throw ServiceException(message: 'Refresh token invalido');
      }

      final refreshTokenClaim = JwtHelper.getClaim(refreshToken.last);
      refreshTokenClaim.validate(issuer: model.accessToken);
    } on ServiceException {
      rethrow;
    } on JwtException catch (e) {
      log.error('Refresh token invalido', error: e);
      throw ServiceException(message: 'Refresh token invalido');
    } catch (e) {
      throw ServiceException(message: 'Erro ao validar refresh token');
    }
  }
}
