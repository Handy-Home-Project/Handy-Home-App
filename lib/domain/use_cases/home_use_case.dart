import 'package:handy_home_app/data/models/user_model.dart';
import 'package:handy_home_app/domain/entities/complex_entity.dart';
import 'package:handy_home_app/domain/entities/floor_plan_entity.dart';
import 'package:handy_home_app/domain/entities/user_entity.dart';
import 'package:handy_home_app/domain/repositories/home_repository.dart';

import '../../data/models/home_model.dart';

class HomeUseCase {
  final HomeRepository _homeRepository;

  HomeUseCase({required HomeRepository homeRepository})
    : _homeRepository = homeRepository;

  Future<List<ComplexEntity>> getComplexListFromKeyword({
    required String keyword,
  }) async {
    final result = await _homeRepository.getComplexesFromKeyword(keyword);
    if (result.isError()) return [];

    return result.getOrThrow().map(ComplexEntity.fromModel).toList();
  }

  Future<List<FloorPlanEntity>> getFloorPlanListFromComplexNo({
    required String complexNo,
  }) async {
    final result = await _homeRepository.getComplexDetailFromComplexNo(
      complexNo,
    );
    if (result.isError()) return [];

    return result
        .getOrThrow()
        .floorPlans
        .map(FloorPlanEntity.fromModel)
        .toList();
  }

  Future<HomeModel?> createHome(String imagePath, UserEntity user) async {
    final result = await _homeRepository.createHome(imagePath, user.id);
    if (result.isError()) return null;
    return result.getOrThrow();
  }

  Future<HomeModel?> createHomePreview(HomeModel home, UserEntity user) async {
    final result = await _homeRepository.createHomePreview(user.id, home.id);
    if (result.isError()) return null;
    return result.getOrThrow();
  }

  Future<List<HomeModel>> getHomeList(String userId) async {
    final result = await _homeRepository.getHomes(userId);
    if (result.isError()) return [];
    return result.getOrThrow();
  }
}
