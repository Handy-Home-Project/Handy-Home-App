import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handy_home_app/commons/route/no_animation_route.dart';
import 'package:handy_home_app/presentation/components/text_editing_box/handy_home_text_editing_box.dart';
import 'package:handy_home_app/presentation/screens/onboarding/find_from_address/select_floor_plan_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../commons/theme/colors.dart';
import '../../../providers/onboarding_provider.dart';

class FindAddressScreen extends ConsumerWidget {
  const FindAddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              const SizedBox(height: 40),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '집 주소',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge!.copyWith(color: kBlue1),
                    ),
                    TextSpan(
                      text: ' 또는 ',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextSpan(
                      text: '이름',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge!.copyWith(color: kBlue1),
                    ),
                    TextSpan(
                      text: '을\n',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextSpan(
                      text: '검색해보세요',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
              Text(
                '아파트와 같은 공공주택만 검색이 가능합니다.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              Stack(
                children: [
                  if (ref
                      .watch(onboardingProvider)
                      .searchAddressController
                      .text
                      .isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: max(
                        2,
                        min(
                          5,
                          ref
                              .watch(onboardingProvider)
                              .searchSuggestionList
                              .length,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        index = index - 1;

                        final suggestionList =
                            ref.watch(onboardingProvider).searchSuggestionList;
                        final currentSuggestion =
                            suggestionList.isEmpty || index == -1
                                ? null
                                : suggestionList[index];

                        return GestureDetector(
                          onTap: () {
                            if (currentSuggestion != null) {
                              ref
                                  .read(onboardingProvider.notifier)
                                  .selectComplex(currentSuggestion);
                              Navigator.of(context).push(
                                NoAnimationRoute(
                                  builder: (_) => const SelectFloorPlanScreen(),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius:
                                  index == -1
                                      ? const BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      )
                                      : index ==
                                          max(
                                                2,
                                                min(5, suggestionList.length),
                                              ) -
                                              2
                                      ? const BorderRadius.vertical(
                                        bottom: Radius.circular(20),
                                      )
                                      : null,
                              color: kGray2,
                            ),
                            child:
                                index != -1
                                    ? Row(
                                      children: [
                                        Text(
                                          currentSuggestion == null
                                              ? '검색 결과가 없습니다.'
                                              : currentSuggestion.title,
                                          style:
                                              currentSuggestion == null
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                        color: kBlack
                                                            .withOpacity(0.5),
                                                      )
                                                  : Theme.of(
                                                    context,
                                                  ).textTheme.bodyMedium,
                                        ),
                                        const Spacer(),
                                        if (currentSuggestion != null)
                                          SvgPicture.asset(
                                            'assets/icons/bxs-back.svg',
                                          ),
                                      ],
                                    )
                                    : null,
                          ),
                        );
                      },
                    ),
                  HandyHomeTextEditingBox(
                    hint: '집 주소, 이름으로 검색하기',
                    controller:
                        ref.read(onboardingProvider).searchAddressController,
                    onChanged:
                        ref
                            .read(onboardingProvider.notifier)
                            .onChangedSearchAddress,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
