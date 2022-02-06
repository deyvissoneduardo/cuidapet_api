import 'package:cuidapet_api/application/entities/user.dart';
import 'package:cuidapet_api/application/modules/user/view_models/user_save_input_model.dart';

abstract class IUserService {
  Future<User> createUser(UserSaveInputModel user);
}
