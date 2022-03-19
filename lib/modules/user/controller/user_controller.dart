import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:server/application/exceptions/user_not_found_exception.dart';
import 'package:server/application/logger/i_logger.dart';
import 'package:server/modules/user/services/i_user_service.dart';
import 'package:server/modules/user/view_models/update_url_avatar_view_model.dart';
import 'package:server/modules/user/view_models/user_update_token_device_input_model.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'user_controller.g.dart';

@Injectable()
class UserController {
  IUserService userService;
  ILogger log;
  UserController({required this.userService, required this.log});

  @Route.get('/')
  Future<Response> findByToken(Request request) async {
    try {
      final user = int.parse(request.headers['user']!);
      final userData = await userService.findById(user);

      return Response.ok(jsonEncode({
        'email': userData.email,
        'register_type': userData.registerType,
        'img_avatar': userData.imageAvatar
      }));
    } on UserNotFoundException {
      return Response.notFound(jsonEncode(''));
    } on Exception catch (err, stackTrace) {
      log.error('Erro ao buscar usuário', error: err, stackTrace: stackTrace);
      return Response.internalServerError(
          body: jsonEncode({'message: Erro ao buscar usuário'}));
    }
  }

  @Route.put('/avatar')
  Future<Response> updateAvatar(Request request) async {
    try {
      final userId = int.parse(request.headers['user']!);
      final updateUrlAvatarViewModel = UpdateUrlAvatarViewModel(
          userId: userId, dataRequest: await request.readAsString());
      final user = await userService.updateAvatar(updateUrlAvatarViewModel);
      return Response.ok(jsonEncode({
        'email': user.email,
        'register_type': user.registerType,
        'img_avatar': user.imageAvatar
      }));
    } on Exception catch (err, s) {
      log.error('Erro ao atualizar o avatar', error: err, stackTrace: s);
      return Response.internalServerError(
          body: jsonEncode({'message: Erro ao atualizar o avatar'}));
    }
  }

  @Route.put('/device')
  Future<Response> updateDeviceToken(Request request) async {
    try {
      final userId = int.parse(request.headers['user']!);
      final updateDeviceToken = UserUpdateTokenDeviceInputModel(
          userId: userId, dataRequest: await request.readAsString());

      await userService.updateDeviceToken(updateDeviceToken);
      return Response.ok(jsonEncode({}));
    } on Exception catch (err, s) {
      log.error('Erro ao atualizar o device Token', error: err, stackTrace: s);
      return Response.internalServerError(
          body: jsonEncode({'message: Erro ao atualizar o device token'}));
    }
  }

  Router get router => _$UserControllerRouter(this);
}
