import 'package:cuidapet_api/application/entities/user.dart';
import 'package:cuidapet_api/application/modules/user/view_models/user_confirm_login_model.dart';
import 'package:cuidapet_api/application/modules/user/view_models/user_save_input_model.dart';

abstract class IUserService {
  Future<User> createUser(UserSaveInputModel user);
  Future<User> loginWithEmailAndPassword(
      String email, String password, bool supplierUser);
  Future<User> loginWithSocial(
      String email, String avatar, String socialKey, String socialType);
  Future<String> confirmLogin(UserConfirmInputModel userConfirmLoginInputModel);
}
