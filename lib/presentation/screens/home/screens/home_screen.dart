import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handy_home_app/commons/route/no_animation_route.dart';
import 'package:handy_home_app/commons/theme/colors.dart';
import 'package:handy_home_app/presentation/providers/home_provider.dart';
import 'package:handy_home_app/presentation/providers/main_provider.dart';
import 'package:handy_home_app/presentation/screens/home/areas/home_app_bar.dart';
import 'package:handy_home_app/presentation/screens/home/dialog/create_interior_dialog.dart';
import 'package:handy_home_app/presentation/screens/home/screens/create_ai_generate_screen.dart';
import 'package:handy_home_app/presentation/screens/interior/screens/interior_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({super.key});

  final PageController pageController = PageController(viewportFraction: 0.95);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final mainState = ref.watch(mainProvider);
      ref.read(homeProvider(mainState.userEntity!.id).notifier).updateUserHome();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mainState = ref.watch(mainProvider);
    final homeState = ref.watch(homeProvider(mainState.userEntity!.id));
    final homeNotifier = ref.watch(homeProvider(mainState.userEntity!.id).notifier);

    final currentHome = homeState.currentHome;
    if (currentHome == null) {
      return Scaffold(
        body: Center(child: SafeArea(child: CircularProgressIndicator())),
      );
    }
    
    final currentHomePreviewList = homeState.homeListGroupByName[currentHome.id];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeAppBar(homeState: homeState, currentHome: currentHome),
                SizedBox(height: 20),
                if (currentHomePreviewList != null) SizedBox(
                  height: 200,
                  child: PageView.builder(
                    clipBehavior: Clip.none,
                    controller: widget.pageController,
                    itemCount: max(1, currentHomePreviewList.length),
                    itemBuilder: (context, index) {
                      final currentItem = currentHomePreviewList[index];

                      final isSourceHome = currentItem.id == currentHome.id;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: GestureDetector(
                          onTap: () async {
                            if (isSourceHome) {
                              final result = await showDialog(context: context, builder: (context) => CreateInteriorDialog());

                              if (result is int) {
                                final homePreview = (await homeNotifier.createHomePreview());

                                widget.pageController.jumpTo(0);
                                if (result == 1 && homePreview != null) {
                                  Navigator.of(context).push(NoAnimationRoute(builder: (context) => CreateAiGenerateScreen(
                                    homePreview: homePreview,
                                  )));
                                } else if (result == 0 && homePreview != null) {
                                  Navigator.of(context).push(
                                      NoAnimationRoute(builder: (context) => InteriorScreen(home: homePreview))
                                  );
                                }
                              }
                            } else {
                              Navigator.of(context).push(
                                  NoAnimationRoute(builder: (context) => InteriorScreen(home: currentHome))
                              );
                            }
                          },
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(13)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(27),
                              child: Stack(
                                children: [
                                  Image.asset(
                                    "assets/images/preview_home.png",
                                    width: MediaQuery.sizeOf(context).width,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  if (isSourceHome) BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                    child: Container(
                                      color: kBlack.withAlpha((255*0.4).round()),
                                      height: 200,
                                    ),
                                  ),
                                  if (isSourceHome) Center(
                                    child: Column(
                                      spacing: 4,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/icons/bxs-add-circle.svg', width: 24,),
                                        Text('새로운 인테리어 추가하기',
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                            color: kWhite,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}