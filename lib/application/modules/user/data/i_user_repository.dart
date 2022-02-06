import 'package:cuidapet_api/application/entities/user.dart';

abstract class IUserRepository {
  Future<User> createUser(User user);
}
