import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:handy_home_app/data/data_sources/user_data_source.dart';
import 'package:handy_home_app/data/models/user_model.dart';
import 'package:handy_home_app/domain/repositories/user_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource _userDataSource;

  UserRepositoryImpl({required UserDataSource userDataSource})
    : _userDataSource = userDataSource;

  @override
  Future<Result<UserModel, DioException>> createUser(String id, String name, String password) async {
    try {
      final result = await _userDataSource.createUser(
        {
          "id": id,
          "name": name,
          "password": password,
        },
      );
      return Result.success(result.body);
    } on DioException catch (e, t) {
      log("createUser", error: e, stackTrace: t);
      return Result.error(e);
    }
  }
}
