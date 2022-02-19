import 'package:cuidapet_api/application/modules/user/user_router.dart';
import 'package:cuidapet_api/application/routes/i_route.dart';
import 'package:shelf_router/shelf_router.dart';

class RouterConfigure {
  final Router _router;
  final List<IRouter> _routers = [
    UserRouter(),
  ];

  RouterConfigure(this._router);

  void configure(Router router) {
    for (var r in _routers) {
      r.configure(_router);
    }
  }
}
