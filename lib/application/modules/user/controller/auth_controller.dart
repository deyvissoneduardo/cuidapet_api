import 'dart:async';
import 'dart:convert';
import 'package:cuidapet_api/application/entities/user.dart';
import 'package:cuidapet_api/application/exception/user_exists_exception.dart';
import 'package:cuidapet_api/application/exception/user_notfound_exception.dart';
import 'package:cuidapet_api/application/helpers/jwt_helpers.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/application/modules/user/service/i_user_service.dart';
import 'package:cuidapet_api/application/modules/user/view_models/login_view_model.dart';
import 'package:cuidapet_api/application/modules/user/view_models/user_save_input_model.dart';
import 'package:injectable/injectable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'auth_controller.g.dart';

@Injectable()
class AuthController {
  IUserService userService;
  ILogger log;

  AuthController({
    required this.userService,
    required this.log,
  });

  @Route.post('/')
  Future<Response> login(Request request) async {
    try {
      final loginViewModel = LoginViewModel(await request.readAsString());

      User user;
      if (!loginViewModel.socialLogin) {
        user = await userService.loginWithEmailAndPassword(loginViewModel.login,
            loginViewModel.password, loginViewModel.supplierUser);
      } else {
        user = User();
      }
      return Response.ok(jsonEncode(
        {'access_token': JwtHelpers.generateJWT(user.id!, user.supplierId)},
      ));
    } on UserNotfoundException {
      return Response.forbidden(
          jsonEncode({'message': 'Usuario ou senha invalido'}));
    } catch (e, s) {
      log.error('Erro ao realizar login', e, s);
      return Response.internalServerError(
        body: jsonEncode({'message': 'Erro ao realizar login'}),
      );
    }
  }

  @Route.post('/register')
  Future<Response> saveUser(Request request) async {
    try {
      final userModel = UserSaveInputModel(await request.readAsString());
      await userService.createUser(userModel);
      return Response.ok(
        jsonEncode({'message': 'Cadastro realizado com Suceso'}),
      );
    } on UserExistsException {
      return Response(
        400,
        body: jsonEncode({'message': 'Usuario ja cadastrado'}),
      );
    } catch (e, s) {
      log.error('Erro ao cadastrar usuario', e, s);
      return Response.internalServerError();
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
