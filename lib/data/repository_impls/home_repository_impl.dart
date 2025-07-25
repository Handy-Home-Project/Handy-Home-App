import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:handy_home_app/data/data_sources/home_data_source.dart';
import 'package:handy_home_app/data/models/complex_detail_model.dart';
import 'package:handy_home_app/data/models/complex_model.dart';
import 'package:handy_home_app/data/models/home_model.dart';
import 'package:handy_home_app/domain/repositories/home_repository.dart';
import 'package:multiple_result/multiple_result.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource _homeDataSource;

  HomeRepositoryImpl({required HomeDataSource homeDataSource})
    : _homeDataSource = homeDataSource;

  @override
  Future<Result<List<ComplexModel>, DioException>> getComplexesFromKeyword(
    String keyword,
  ) async {
    try {
      final result = await _homeDataSource.getComplexesFromKeyword(keyword);
      return Result.success(result.body);
    } on DioException catch (e, t) {
      log("getComplexesFromKeyword", error: e, stackTrace: t);
      return Result.error(e);
    }
  }

  @override
  Future<Result<ComplexDetailModel, DioException>>
  getComplexDetailFromComplexNo(String complexNo) async {
    try {
      final result = await _homeDataSource.getComplexDetailFromComplexNo(
        complexNo,
      );
      return Result.success(result.body);
    } on DioException catch (e, t) {
      log("getComplexDetailFromComplexNo", error: e, stackTrace: t);
      return Result.error(e);
    }
  }

  @override
  Future<Result<HomeModel, DioException>> createHome(String imagePath, String userId) async {
    try {
      final result = await _homeDataSource.createHome(imagePath, userId);
      return Result.success(result.body);
    } on DioException catch (e, t) {
      log("createHome", error: e, stackTrace: t);
      return Result.error(e);
    }
  }

  @override
  Future<Result<HomeModel, DioException>> createHomePreview(String userId, int homeId) async {
    try {
      final result = await _homeDataSource.createHomePreview(userId, homeId);
      return Result.success(result.body);
    } on DioException catch (e, t) {
      log("createHomePreview", error: e, stackTrace: t);
      return Result.error(e);
    }
  }

  @override
  Future<Result<List<HomeModel>, DioException>> getHomes(String userId) async {
    try {
      final result = await _homeDataSource.getHomes(userId);
      return Result.success(result.body);
    } on DioException catch (e, t) {
      log("getHomes", error: e, stackTrace: t);
      return Result.error(e);
    }
  }
}
