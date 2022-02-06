import 'package:cuidapet_api/application/modules/user/controller/auth_controller.dart';
import 'package:cuidapet_api/application/routes/i_route.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf_router/shelf_router.dart';

class UserRouter implements IRouter {
  @override
  void configure(Router router) {
    final authController = GetIt.I.get<AuthController>();
    router.mount('/auth/', authController.router);
  }
}
