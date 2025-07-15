import 'package:dio/dio.dart';
import 'package:handy_home_app/data/models/api_response_list_model.dart';
import 'package:handy_home_app/data/models/api_response_model.dart';
import 'package:handy_home_app/data/models/complex_detail_model.dart';
import 'package:handy_home_app/data/models/complex_model.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'home_data_source.g.dart';

@RestApi()
abstract class HomeDataSource {
  factory HomeDataSource(Dio dio, {String? baseUrl}) = _HomeDataSource;

  @GET('/api/home/search')
  Future<ApiResponseListModel<ComplexModel>> getComplexesFromKeyword(
    @Query('keyword') String keyword,
  );

  @GET('/api/home/floor_plan/{complex_no}')
  Future<ApiResponseModel<ComplexDetailModel>> getComplexDetailFromComplexNo(
    @Path('complex_no') complexNo,
  );
}
