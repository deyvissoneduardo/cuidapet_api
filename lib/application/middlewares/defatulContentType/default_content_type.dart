import 'package:cuidapet_api/application/middlewares/middlewares.dart';
import 'package:shelf/shelf.dart';

class DefaultContentType extends Middlewares {
  @override
  Future<Response> execute(Request request) async {
    final response = await innerHandler(request);

    return response
        .change(headers: {'content-type': 'application/json;charset=utf-8'});
  }
}
