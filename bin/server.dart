import 'dart:io';

import 'package:cuidapet_api/application/config/application_config.dart';
import 'package:cuidapet_api/application/middlewares/cors/cors_middlewares.dart';
import 'package:cuidapet_api/application/middlewares/defatulContentType/default_content_type.dart';
import 'package:cuidapet_api/application/middlewares/security/security_middleware.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart' as shelf;

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;

  final router = Router();
  final appConfig = ApplicationConfig();
  await appConfig.loadConfigApplication(router);

  final getIt = GetIt.I;

  final _handler = const shelf.Pipeline()
      .addMiddleware(CorsMiddlewares().handler)
      .addMiddleware(DefaultContentType().handler)
      .addMiddleware(SecurityMiddleware(log: getIt.get()).handler)
      .addMiddleware(shelf.logRequests())
      .addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8181');
  final server = await serve(_handler, ip, port);
  print('Server listening on port ${server.port}');
}
