import 'package:shelf/src/response.dart';

import 'package:shelf/src/request.dart';

import '../middlewares.dart';

class DefaultContentType extends Middlewares {
  String content;
  DefaultContentType(this.content);
  @override
  Future<Response> execute(Request request) async {
    final response = await innerHandler(request);
    return response.change(headers: {'content-type': content});
  }
}
