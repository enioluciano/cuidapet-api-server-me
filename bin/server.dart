import 'package:get_it/get_it.dart';
import 'package:server/application/config/application_config.dart';
import 'package:server/application/middlewares/cors/cors_middleware.dart';
import 'package:server/application/middlewares/default_content_type/default_content_type.dart';
import 'package:server/application/middlewares/security/secutirty_middleware.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

void main() async {
  final appConfig = ApplicationConfig();
  final Router router = Router();
  await appConfig.loadConfigApplication(router);
  final getIt = GetIt.I;
  var handler = const shelf.Pipeline()
      .addMiddleware(CorsMiddleware().handler)
      .addMiddleware(
          DefaultContentType('application/json;charset=utf-8').handler)
      .addMiddleware(SecutirtyMiddleware(getIt.get()).handler)
      .addMiddleware(shelf.logRequests())
      .addHandler(router);

  var server = await shelf_io.serve(handler, 'localhost', 8080);

  // Enable content compression
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}

// Response _echoRequest(Request request) =>
//     Response.ok('Request for "${request.url}"');
