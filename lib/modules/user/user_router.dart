import 'package:get_it/get_it.dart';
import 'package:server/application/routers/i_router.dart';
import 'package:server/modules/user/controller/auth_controller.dart';
import 'package:server/modules/user/controller/user_controller.dart';
import 'package:shelf_router/shelf_router.dart';

class UserRouter implements IRouter {
  @override
  void configure(Router router) {
    final authController = GetIt.I.get<AuthController>();
    final userController = GetIt.I.get<UserController>();

    router.mount('/auth/', authController.router);
    router.mount('/user/', userController.router);
    print(router);
  }
}
