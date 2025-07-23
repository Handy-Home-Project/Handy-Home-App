import 'package:dio/dio.dart';
import 'package:handy_home_app/data/models/user_model.dart';
import 'package:multiple_result/multiple_result.dart';

abstract interface class UserRepository {
  Future<Result<UserModel, DioException>> createUser(String id, String name, String password);
}
