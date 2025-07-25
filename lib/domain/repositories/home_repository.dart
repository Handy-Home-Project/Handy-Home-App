import 'package:dio/dio.dart';
import 'package:handy_home_app/data/models/complex_detail_model.dart';
import 'package:handy_home_app/data/models/complex_model.dart';
import 'package:handy_home_app/data/models/home_model.dart';
import 'package:multiple_result/multiple_result.dart';

abstract interface class HomeRepository {
  Future<Result<List<ComplexModel>, DioException>> getComplexesFromKeyword(String keyword);

  Future<Result<ComplexDetailModel, DioException>> getComplexDetailFromComplexNo(String complexNo);

  Future<Result<HomeModel, DioException>> createHome(String imagePath, String userId);

  Future<Result<HomeModel, DioException>> createHomePreview(String userId, int homeId);

  Future<Result<List<HomeModel>, DioException>> getHomes(String userId);
}
