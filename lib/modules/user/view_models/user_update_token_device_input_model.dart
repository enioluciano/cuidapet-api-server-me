import 'package:server/application/helpers/request_mapping.dart';
import 'package:server/modules/user/view_models/platform.dart';

class UserUpdateTokenDeviceInputModel extends RequestMapping {
  int userId;
  late String token;
  late Platform plataform;
  UserUpdateTokenDeviceInputModel(
      {required this.userId, required String dataRequest})
      : super(dataRequest);

  @override
  void map() {
    token = data['token'];
    plataform = (data['plataform'].toLowerCase() == 'ios'
        ? Platform.ios
        : Platform.android);
  }
}
