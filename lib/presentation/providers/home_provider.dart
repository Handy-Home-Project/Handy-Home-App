import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:handy_home_app/commons/utils/snack_bar_helper.dart';
import 'package:handy_home_app/data/models/home_model.dart';
import 'package:handy_home_app/domain/use_cases/home_use_case.dart';
import 'package:handy_home_app/domain/use_cases/user_use_case.dart';

import '../../commons/di/di.dart';

part 'home_provider.freezed.dart';
part 'home_provider.g.dart';

final homeProvider = StateNotifierProvider.family<HomeNotifier, HomeState, String>((ref, userId) => HomeNotifier(
  state: HomeState(
    homeListGroupByName: {},
    currentHome: null,
  ),
  userUseCase: DependencyInjection.getIt.get(),
  homeUseCase: DependencyInjection.getIt.get(),
));

@Freezed()
abstract class HomeState with _$HomeState {
  factory HomeState({
    required final Map<int, List<HomeModel>> homeListGroupByName,
    required final HomeModel? currentHome,
  }) = _HomeState;

  factory HomeState.fromJson(Map<String, dynamic> json) =>
      _$HomeStateFromJson(json);
}

class HomeNotifier extends StateNotifier<HomeState> {
  final UserUseCase _userUseCase;
  final HomeUseCase _homeUseCase;

  HomeNotifier({
    required HomeState state,
    required UserUseCase userUseCase,
    required HomeUseCase homeUseCase,
  }) :  _userUseCase = userUseCase,
        _homeUseCase = homeUseCase,
        super(state);

  Future<void> updateUserHome() async {
    final result = await _homeUseCase.getHomeList(_userUseCase.getSavedUser()!.id);
    result.sort((a, b) => b.id.compareTo(a.id));
    final homeGroupBy = result.groupListsBy((element) => element.isPreview
        ? element.sourceId!
        : element.id);
    state = state.copyWith(
      homeListGroupByName: homeGroupBy,
      currentHome: homeGroupBy.isNotEmpty
          ? result.firstWhere((element) => !element.isPreview)
          : null,
    );
  }

  Future<HomeModel?> createHomePreview() async {
    final user = _userUseCase.getSavedUser();
    final currentHome = state.currentHome;

    if (user == null || currentHome == null) {
      SnackBarHelper.showSnackBar(message: '방을 먼저 선택해주세요.');
      return null;
    }

    final result = await _homeUseCase.createHomePreview(currentHome, user);
    if (result != null) {
      result.roomList.addAll(currentHome.roomList);

      final newHomeListGroupByName = Map.of(state.homeListGroupByName);
      newHomeListGroupByName[state.currentHome!.id]?.insert(0, result);

      state = state.copyWith(
         homeListGroupByName: newHomeListGroupByName,
      );
    }

    return result;
  }
}