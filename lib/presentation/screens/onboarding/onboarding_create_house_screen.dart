import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_home_app/commons/route/no_animation_route.dart';
import 'package:handy_home_app/commons/theme/colors.dart';
import 'package:handy_home_app/commons/utils/snack_bar_helper.dart';
import 'package:handy_home_app/presentation/screens/onboarding/find_from_address/find_address_screen.dart';

class OnboardingCreateHouseScreen extends ConsumerWidget {
  const OnboardingCreateHouseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: '아래 방법들 중 하나로\n집을 생성해보세요',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const Spacer(),
          _buildCreateHouseCard(
            context: context,
            imageUrl: 'assets/images/find_from_address.png',
            title: '집 주소로 찾기',
            content: '집 주소를 입력해 평면도를 찾고, 집을 생성 할 수 있습니다.',
            onTap: () {
              Navigator.of(context).push(
                NoAnimationRoute(builder: (_) => const FindAddressScreen()),
              );
            },
          ),
          const SizedBox(height: 30),
          _buildCreateHouseCard(
            context: context,
            imageUrl: 'assets/images/find_from_floor_plan.png',
            title: '평면도 가져오기',
            content: '갤러리 또는 카메라를 사용해 평면도 이미지를 불러와 집을 생성 할 수 있습니다.',
            onTap: () {
              SnackBarHelper.showSnackBar(message: '이 기능은 현재 준비 중 입니다.');
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildCreateHouseCard({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String content,
    required void Function() onTap,
  }) => GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: kGray1,
      ),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Image.asset(
                imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 13),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text(content, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    ),
  );
}
