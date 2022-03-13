import 'package:get_it/get_it.dart';
import 'package:shelf_router/src/router.dart';

import '../../application/routers/i_router.dart';
import 'controller/auth_controller.dart';

class UserRouter implements IRouter {
  @override
  void configure(Router router) {
    final authController = GetIt.I.get<AuthController>();

    router.mount('/auth/', authController.router);
  }
}
