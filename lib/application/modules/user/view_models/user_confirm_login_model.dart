import 'package:cuidapet_api/application/helpers/request_mapping.dart';

class UserConfirmLoginInputModel extends RequestMapping {
  int userId;
  String accessToken;
  late String iosDeviceToketoken;
  late String androidDeviceToken;
  UserConfirmLoginInputModel({
    required this.userId,
    required this.accessToken,
    required String data,
  }) : super(data);

  @override
  void map() {}
}
