import 'package:cuidapet_api/application/entities/user.dart';
import 'package:cuidapet_api/application/exception/user_notfound_exception.dart';
import 'package:cuidapet_api/application/helpers/jwt_helpers.dart';
import 'package:cuidapet_api/application/logger/i_logger.dart';
import 'package:cuidapet_api/application/modules/user/repository/i_user_repository.dart';
import 'package:cuidapet_api/application/modules/user/view_models/user_confirm_login_model.dart';
import 'package:cuidapet_api/application/modules/user/view_models/user_save_input_model.dart';
import 'package:injectable/injectable.dart';

import './i_user_service.dart';

@LazySingleton(as: IUserService)
class UserService implements IUserService {
  IUserRepository userRepository;
  ILogger log;
  UserService({
    required this.userRepository,
    required this.log,
  });

  @override
  Future<User> createUser(UserSaveInputModel user) async {
    final userEntity = User(
      email: user.email,
      password: user.password,
      registerType: 'APP',
      supplierId: user.supplierId,
    );

    return userRepository.createUser(userEntity);
  }

  @override
  Future<User> loginWithEmailAndPassword(
          String email, String password, bool supplierUser) =>
      userRepository.loginWithEmailAndPassword(email, password, supplierUser);

  @override
  Future<User> loginWithSocial(
      String email, String avatar, String socialKey, String socialType) async {
    try {
      return await userRepository.loginByEmailSocialKey(
          email, socialKey, socialType);
    } on UserNotfoundException catch (e, s) {
      log.error('Usuario nao encontrado', e, s);
      final user = User(
        email: email,
        imageAvatar: avatar,
        socialKey: socialKey,
        registerType: socialType,
        password: '123qwe',
      );
      return await userRepository.createUser(user);
    }
  }

  @override
  Future<String> confirmLogin(UserConfirmInputModel inputModel) async {
    final refreshToken = JwtHelpers.refreshToken(inputModel.accessToken);
    final user = User(
      id: inputModel.userId,
      refreshToken: refreshToken,
      imageAvatar: inputModel.iosDeviceToketoken,
      androidToken: inputModel.androidDeviceToken,
    );
    await userRepository.updateUserDeviceTokenAndRefreshToken(user);
    return refreshToken;
  }
}
