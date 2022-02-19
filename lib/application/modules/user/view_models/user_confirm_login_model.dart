import 'package:cuidapet_api/application/helpers/request_mapping.dart';

class UserConfirmInputModel extends RequestMapping {
  int userId;
  String accessToken;
  late String iosDeviceToketoken;
  late String androidDeviceToken;
  UserConfirmInputModel({
    required this.userId,
    required this.accessToken,
    required String data,
  }) : super(data);

  @override
  void map() {
    iosDeviceToketoken = data['ios_token'];
    androidDeviceToken = data['android_token'];
  }
}
