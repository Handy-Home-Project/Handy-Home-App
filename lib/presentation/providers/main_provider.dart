import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_home_app/commons/di/di.dart';
import 'package:handy_home_app/domain/entities/user_entity.dart';
import 'package:handy_home_app/domain/use_cases/user_use_case.dart';

final mainProvider = StateNotifierProvider<MainNotifierState, MainState>(
  (ref) => MainNotifierState(userUseCase: DependencyInjection.getIt.get()),
);

class MainNotifierState extends StateNotifier<MainState> {
  final UserUseCase _userUseCase;

  MainNotifierState({required UserUseCase userUseCase})
    : _userUseCase = userUseCase,
      super(MainState()) {
    _initMainNotifierState();
  }

  void _initMainNotifierState() {
    final savedUser = _userUseCase.getSavedUser();
    if (savedUser != null) setUserEntity(savedUser);
  }

  void setUserEntity(UserEntity user) {
    state.copyWith(userEntity: user);
  }
}

class MainState {
  final UserEntity? userEntity;

  MainState({this.userEntity});

  MainState copyWith({UserEntity? userEntity}) =>
      MainState(userEntity: userEntity ?? userEntity);
}
