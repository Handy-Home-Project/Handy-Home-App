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
          builder: (context) => Consumer(
            builder: (context, ref, child) {
              final hasUserEntity = ref.watch(mainProvider).userEntity != null;

              if (hasUserEntity) {
                return const HomeScreen();
              } else {
                return const OnboardingScreen();
              }
            },
          )
        ),
      ),
    );
  }
}
