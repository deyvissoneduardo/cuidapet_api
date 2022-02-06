import 'package:cuidapet_api/application/entities/user.dart';
import 'package:cuidapet_api/application/modules/user/repository/i_user_repository.dart';
import 'package:cuidapet_api/application/modules/user/view_models/user_save_input_model.dart';
import 'package:injectable/injectable.dart';

import './i_user_service.dart';

@LazySingleton(as: IUserService)
class UserService implements IUserService {
  IUserRepository userRepository;
  UserService({
    required this.userRepository,
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
}
