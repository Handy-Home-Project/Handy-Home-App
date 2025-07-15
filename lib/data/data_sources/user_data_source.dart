import 'package:dio/dio.dart';
import 'package:handy_home_app/data/models/api_response_model.dart';
import 'package:handy_home_app/data/models/user_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'user_data_source.g.dart';

@RestApi()
abstract class UserDataSource {
  factory UserDataSource(Dio dio, {String? baseUrl}) = _UserDataSource;

  @POST('/api/user')
  Future<ApiResponseModel<UserModel>> createUser(
    @Body() Map<String, dynamic> name,
  );
}
