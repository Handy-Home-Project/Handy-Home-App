import 'dart:developer';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_home_app/commons/di/di.dart';
import 'package:handy_home_app/commons/utils/snack_bar_helper.dart';
import 'package:handy_home_app/domain/entities/complex_entity.dart';
import 'package:handy_home_app/domain/entities/floor_plan_entity.dart';
import 'package:handy_home_app/domain/use_cases/home_use_case.dart';
import 'package:handy_home_app/domain/use_cases/user_use_case.dart';
import 'package:handy_home_app/presentation/providers/main_provider.dart';

final onboardingProvider =
    StateNotifierProvider<OnboardingStateNotifier, OnboardingState>(
      (ref) => OnboardingStateNotifier(
        userUseCase: DependencyInjection.getIt.get(),
        homeUseCase: DependencyInjection.getIt.get(),
      ),
    );

class OnboardingStateNotifier extends StateNotifier<OnboardingState> {
  final UserUseCase _userUseCase;

  final HomeUseCase _homeUseCase;

  OnboardingStateNotifier({
    required UserUseCase userUseCase,
    required HomeUseCase homeUseCase,
  }) : _userUseCase = userUseCase,
       _homeUseCase = homeUseCase,
       super(OnboardingState());

  void createUser() async {
    final name = state.nameController.text;
    log(name);
    if (!RegExp(r'^[a-zA-Z가-힣]{1,5}$').hasMatch(name)) {
      return SnackBarHelper.showSnackBar(
        message: '이름은 영문 및 한글, 5글자 이내로 작성해주세요.',
      );
    }

    final newUser = await _userUseCase.createUser(name);
    if (newUser != null) {
      log(newUser.toString());
      final container = ProviderContainer();
      container.read(mainProvider.notifier).setUserEntity(newUser);
      container.dispose();

      state.pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      return SnackBarHelper.showSnackBar(
        message: '오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      );
    }
  }

  void onChangedSearchAddress(String keyword) async {
    state.searchAddressController.text = keyword;
    EasyDebounce.debounce(
      'onChangedSearchAddress',
      const Duration(milliseconds: 300),
      () async {
        final newSuggestionList = await _homeUseCase.getComplexListFromKeyword(
          keyword: keyword,
        );
        state = state.copyWith(searchSuggestionList: newSuggestionList);
        log(state.searchSuggestionList.length.toString());
      },
    );
  }

  void selectComplex(ComplexEntity complex) async {
    state = state.copyWith(selectedComplex: complex);

    final floorPlanList = await _homeUseCase.getFloorPlanListFromComplexNo(
      complexNo: complex.complexNo,
    );

    state = state.copyWith(selectedFloorPlanList: floorPlanList);
  }

  void changeFloorPlanIndex(int index) {
    state = state.copyWith(currentFloorPlanIndex: index);
  }

  void selectFloorPlan() {
    EasyDebounce.debounce(
      'selectFloorPlan',
      const Duration(seconds: 3, milliseconds: 400),
      () async {
        state = state.copyWith(isLoadingComplete: true);
      },
    );
  }
}

class OnboardingState {
  final PageController pageController;

  // 사용자 이름 입력 페이지
  final TextEditingController nameController;

  // 집 주소로 찾기 페이지
  final TextEditingController searchAddressController;
  final List<ComplexEntity> searchSuggestionList;

  // 도면 선택 페이지
  final ComplexEntity? selectedComplex;
  final List<FloorPlanEntity> selectedFloorPlanList;
  final int currentFloorPlanIndex;

  // 집 생성 임시 데이터
  final bool isLoadingComplete;

  OnboardingState({
    PageController? pageController,
    TextEditingController? nameController,
    TextEditingController? searchAddressController,
    this.searchSuggestionList = const [],
    this.selectedComplex,
    this.selectedFloorPlanList = const [],
    this.currentFloorPlanIndex = 0,
    this.isLoadingComplete = false,
  }) : nameController = nameController ?? TextEditingController(),
       searchAddressController =
           searchAddressController ?? TextEditingController(),
       pageController = pageController ?? PageController();

  OnboardingState copyWith({
    List<ComplexEntity>? searchSuggestionList,
    ComplexEntity? selectedComplex,
    List<FloorPlanEntity>? selectedFloorPlanList,
    int? currentFloorPlanIndex,
    bool? isLoadingComplete,
  }) => OnboardingState(
    pageController: pageController,
    nameController: nameController,
    searchAddressController: searchAddressController,
    searchSuggestionList: searchSuggestionList ?? this.searchSuggestionList,
    selectedComplex: selectedComplex ?? this.selectedComplex,
    selectedFloorPlanList: selectedFloorPlanList ?? this.selectedFloorPlanList,
    currentFloorPlanIndex: currentFloorPlanIndex ?? this.currentFloorPlanIndex,
    isLoadingComplete: isLoadingComplete ?? this.isLoadingComplete,
  );
}
