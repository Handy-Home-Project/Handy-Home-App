import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_home_app/commons/route/no_animation_route.dart';
import 'package:handy_home_app/presentation/components/button/handy_home_button1.dart';
import 'package:handy_home_app/presentation/components/button/handy_home_button2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../commons/theme/colors.dart';
import '../../../providers/onboarding_provider.dart';
import '../onboarding_complete_screen.dart';

class SelectFloorPlanScreen extends ConsumerWidget {
  const SelectFloorPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);
    final complex = onboardingState.selectedComplex;
    final floorPlanList = onboardingState.selectedFloorPlanList;

    final imagePath = floorPlanList.isNotEmpty ? 'https://landthumb-phinf.pstatic.net${floorPlanList[onboardingState.currentFloorPlanIndex].floorPlanUrl}' : '';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
              if (complex != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    RichText(
                      text: TextSpan(
                        text: complex.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Text(
                      complex.address,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              const SizedBox(height: 40),
              if (floorPlanList.isNotEmpty)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 245,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(17),
                          ),
                          border: Border.all(width: 3, color: kGray2),
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage(
                              imagePath,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        height: 30,
                        child: ListView.builder(
                          clipBehavior: Clip.none,
                          scrollDirection: Axis.horizontal,
                          itemCount: floorPlanList.length,
                          itemBuilder: (context, index) {
                            final isSelected =
                                onboardingState.currentFloorPlanIndex == index;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: HandyHomeButton2(
                                text: floorPlanList[index].pyeongName,
                                disable: !isSelected,
                                onTap:
                                    !isSelected
                                        ? () => ref
                                            .read(onboardingProvider.notifier)
                                            .changeFloorPlanIndex(index)
                                        : null,
                              ),
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      HandyHomeButton1(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            NoAnimationRoute(
                              builder:
                                  (context) => OnboardingCompleteScreen(imagePath: imagePath),
                            ),
                          );
                        },
                        text: '이 집으로 선택하기',
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
