import 'package:cuidapet_api/application/modules/test/teste_controller.dart';
import 'package:cuidapet_api/application/routes/i_route.dart';
import 'package:shelf_router/shelf_router.dart';

class TesteRouter implements IRouter {
  @override
  void configure(Router router) {
    router.mount('/hello/', TesteController().router);
  }
}
