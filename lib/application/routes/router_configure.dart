import 'package:cuidapet_api/application/modules/test/teste_router.dart';
import 'package:cuidapet_api/application/routes/i_route.dart';
import 'package:shelf_router/shelf_router.dart';

class RouterConfigure {
  final Router _router;
  final List<IRouter> _routers = [
    TesteRouter(),
  ];

  RouterConfigure(this._router);

  void configure() => _routers.forEach((r) {
        r.configure(_router);
      });
}
