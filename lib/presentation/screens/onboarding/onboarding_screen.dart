import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_home_app/commons/theme/colors.dart';
import 'package:handy_home_app/presentation/providers/main_provider.dart';
import 'package:handy_home_app/presentation/providers/onboarding_provider.dart';
import 'package:handy_home_app/presentation/screens/onboarding/onboarding_create_house_screen.dart';
import 'package:handy_home_app/presentation/screens/onboarding/onboarding_name_input_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../components/button/handy_home_button1.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                children: [
                  const Spacer(),
                  SmoothPageIndicator(
                    effect: ExpandingDotsEffect(
                      activeDotColor: kBlue1,
                      dotColor: kBlue1.withOpacity(0.5),
                      dotHeight: 6,
                      dotWidth: 6,
                      spacing: 5,
                      expansionFactor: 5,
                    ),
                    controller: ref.read(onboardingProvider).pageController,
                    count: 3,
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: ref.read(onboardingProvider).pageController,
                onPageChanged: ref.read(onboardingProvider.notifier).changePage,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  SingleChildScrollView(child: OnboardingNameInputScreen()),
                  OnboardingCreateHouseScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ref.watch(onboardingProvider).currentPage == 0 ? Padding(
        padding: const EdgeInsets.all(20),
        child: HandyHomeButton1(
          text: '다음',
          onTap: () async {
            FocusScope.of(context).unfocus();
            final user = await ref.read(onboardingProvider.notifier).createUser();

            if (user != null) {
              ref.read(mainProvider.notifier).setUserEntity(user);
              ref.read(onboardingProvider).pageController.animateToPage(
                1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          },
        ),
      ) : null,
    );
  }
}
