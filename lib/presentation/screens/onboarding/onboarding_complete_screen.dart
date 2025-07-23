import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_home_app/commons/theme/colors.dart';
import 'package:handy_home_app/commons/utils/snack_bar_helper.dart';
import 'package:handy_home_app/presentation/components/button/handy_home_button1.dart';
import 'package:handy_home_app/presentation/providers/onboarding_provider.dart';
import 'package:handy_home_app/presentation/screens/home_screen.dart';
import 'package:lottie/lottie.dart';

import '../../../commons/route/no_animation_route.dart';

class OnboardingCompleteScreen extends ConsumerStatefulWidget {
  const OnboardingCompleteScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  ConsumerState<OnboardingCompleteScreen> createState() => _OnboardingCompleteScreenState();
}

class _OnboardingCompleteScreenState extends ConsumerState<OnboardingCompleteScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(onboardingProvider.notifier).createHome(widget.imagePath);
    });
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingProvider);

    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    !onboardingState.isLoadingComplete
                        ? Lottie.asset(
                          'assets/anim/loading.json',
                          repeat: true,
                          reverse: false,
                          height: 140,
                        )
                        : Lottie.asset(
                          'assets/anim/loading_complete.json',
                          repeat: false,
                          reverse: false,
                          height: 85,
                        ),
                    Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Text(
                        !onboardingState.isLoadingComplete
                            ? '집이 만들어지는 중이에요...\n잠시만 기다려주세요'
                            : '집이 만들어졌어요.\n이제 집을 꾸미러 가볼까요?',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Opacity(
                opacity: onboardingState.isLoadingComplete ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 40,
                  ),
                  child: HandyHomeButton1(
                    text: '다음',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        NoAnimationRoute(builder: (context) => HomeScreen()),
                      );
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
