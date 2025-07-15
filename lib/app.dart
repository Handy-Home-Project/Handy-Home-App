import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_home_app/commons/theme/theme.dart';
import 'package:handy_home_app/commons/utils/snack_bar_helper.dart';
import 'package:handy_home_app/presentation/providers/main_provider.dart';
import 'package:handy_home_app/presentation/screens/home_screen.dart';
import 'package:handy_home_app/presentation/screens/onboarding/onboarding_screen.dart';

class HandyHomeApplication extends StatelessWidget {
  const HandyHomeApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        scaffoldMessengerKey: SnackBarHelper.messengerKey,
        debugShowCheckedModeBanner: false,
        home: Builder(
          builder: (context) {
            final container = ProviderContainer();
            final hasUserEntity =
                container.read(mainProvider).userEntity != null;

            // TODO - [20250102] 집 선택 유무 확인 후 HomeScreen 으로 넘기는 기능 필요
            if (hasUserEntity) {
              return const HomeScreen();
            } else {
              return const OnboardingScreen();
            }
          },
        ),
      ),
    );
  }
}
