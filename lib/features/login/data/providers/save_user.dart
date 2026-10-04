import 'dart:convert';

import '../../../../core/enums/constants_enums.dart';
import '../../../../core/local_services/local_storage.dart';
import '../models/user_model.dart';

class SaveUser {
  static final SaveUser instance = SaveUser._();
  SaveUser._();

  Future<void> saveUser(String user) async {
    await LocalStorage.instance.add(Constants.userData.name, user);
  }

  UserModel? getUser() {
    final String? userData = LocalStorage.instance.get(Constants.userData.name);
    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future<void> deleteUserData() async {
    await LocalStorage.instance.delete(Constants.userData.name);
    await LocalStorage.instance.delete(Constants.loginKey.name);
  }
}
