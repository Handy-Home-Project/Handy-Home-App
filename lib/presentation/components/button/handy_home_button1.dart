import 'package:flutter/material.dart';
import 'package:handy_home_app/commons/theme/colors.dart';

class HandyHomeButton1 extends StatelessWidget {
  const HandyHomeButton1({
    super.key,
    this.onTap,
    this.disable = false,
    this.text = '',
  });

  final void Function()? onTap;

  final String text;

  final bool disable;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disable ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: disable ? kGray3 : kBlue1,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.titleSmall!.copyWith(color: kWhite),
        ),
      ),
    );
  }
}
