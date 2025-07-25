import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handy_home_app/data/models/home_model.dart';
import 'package:handy_home_app/presentation/providers/home_provider.dart';

import '../../../components/bottom_sheet/select_item_bottom_sheet.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.homeState, required this.currentHome});

  final HomeState homeState;

  final HomeModel currentHome;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgPicture.asset('assets/logo/handy_home_logo.svg', width: 90),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(context: context, builder: (context) => SelectItemBottomSheet(
              title: '집을 선택해주세요',
              itemList: homeState.homeListGroupByName.values.map((e) => e.first)
                  .toList()
                  .asMap().map((key, value) => MapEntry(value.name, value)),
            ));
          },
          child: Row(
            children: [
              Text(
                currentHome.name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.arrow_drop_down_rounded)
            ],
          ),
        )
      ],
    );
  }
}
