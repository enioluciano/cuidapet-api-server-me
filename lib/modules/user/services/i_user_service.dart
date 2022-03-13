import 'package:server/modules/user/view_models/refresh_token_view_model.dart';
import 'package:server/modules/user/view_models/user_confirm_input_model.dart';
import 'package:server/modules/user/view_models/user_refresh_token_input_model.dart';

import '../../../entities/user.dart';
import '../view_models/user_save_input_model.dart';

abstract class IUserService {
  Future<User> createUser(UserSaveInputModel user);
  Future<User> loginWithEmailPassword(
      String email, String password, bool supplierUser);
  Future<User> loginWithSocial(
      String email, String avatar, String socialType, String socialKey);
  Future<String> confirmLogin(UserConfirmInputModel inputModel);
  Future<RefreshTokenViewModel> refreshToken(UserRefreshTokenInputModel model);
}