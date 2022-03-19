import 'package:server/application/helpers/request_mapping.dart';

class UpdateUrlAvatarViewModel extends RequestMapping {
  late String urlAvatar;
  late int userId;

  UpdateUrlAvatarViewModel({required this.userId, dataRequest})
      : super(dataRequest);

  @override
  void map() {
    urlAvatar = data['url_avatar'];
  }
}
