import 'package:shelf_router/shelf_router.dart';

import '../../modules/user/user_router.dart';
import 'i_router.dart';

class RouterConfigure {
  final Router _router;

  //adicionar todas as routas aqui
  final List<IRouter> _routers = [
    UserRouter(),
  ];

  RouterConfigure(this._router);

  void configure() => _routers.forEach((r) => r.configure(_router));
}
