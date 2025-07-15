import 'package:handy_home_app/data/models/user_model.dart';

abstract interface class SharedPreferencesRepository {
  Future<void> initSharedPrefs();

  void saveUser(UserModel model);

  UserModel? getUser();
}
