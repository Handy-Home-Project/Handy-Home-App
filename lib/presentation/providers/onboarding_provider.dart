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

  void changePage(int value) => state = state.copyWith(currentPage: value);

  void createUser() async {
    final id = state.idController.text;
    final name = state.nameController.text;
    final password = state.passwordController.text;
    final passwordMatch = state.passwordMatchController.text;

    if (id.length <= 5) {
      return SnackBarHelper.showSnackBar(
        message: '아이디는 6글자 이상으로 작성해주세요.',
      );
    }

    if (!RegExp(r'^[a-zA-Z가-힣]{1,5}$').hasMatch(name)) {
      return SnackBarHelper.showSnackBar(
        message: '이름은 영문 및 한글, 5글자 이내로 작성해주세요.',
      );
    }

    if (password.length <= 5) {
      return SnackBarHelper.showSnackBar(
        message: '비밀번호는 6글자 이상으로 작성해주세요.',
      );
    }

    if (password != passwordMatch) {
      return SnackBarHelper.showSnackBar(
          message: '비밀번호가 일치하지 않습니다. 비밀번호를 확인해주세요.',
      );
    }

    final newUser = await _userUseCase.createUser(id, name, password);
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

  void createHome(String imagePath) async {
    final user = _userUseCase.getSavedUser()!;
    final home = await _homeUseCase.createHome(imagePath, user);
    if (home != null) {
      state = state.copyWith(isLoadingComplete: true);
    } else {
      SnackBarHelper.showSnackBar(message: '오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
    }
  }
}

class OnboardingState {
  final PageController pageController;
  final int currentPage;

  // 사용자 정보 입력 페이지
  final TextEditingController idController;
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final TextEditingController passwordMatchController;

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
    int? currentPage,
    TextEditingController? idController,
    TextEditingController? nameController,
    TextEditingController? passwordController,
    TextEditingController? passwordMatchController,
    TextEditingController? searchAddressController,
    this.searchSuggestionList = const [],
    this.selectedComplex,
    this.selectedFloorPlanList = const [],
    this.currentFloorPlanIndex = 0,
    this.isLoadingComplete = false,
  }) : idController = idController ?? TextEditingController(),
       nameController = nameController ?? TextEditingController(),
       currentPage = currentPage ?? 0,
       passwordController = passwordController ?? TextEditingController(),
       passwordMatchController = passwordMatchController ?? TextEditingController(),
       searchAddressController =
           searchAddressController ?? TextEditingController(),
       pageController = pageController ?? PageController();

  OnboardingState copyWith({
    int? currentPage,
    List<ComplexEntity>? searchSuggestionList,
    ComplexEntity? selectedComplex,
    List<FloorPlanEntity>? selectedFloorPlanList,
    int? currentFloorPlanIndex,
    bool? isLoadingComplete,
  }) => OnboardingState(
    currentPage: currentPage,
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
