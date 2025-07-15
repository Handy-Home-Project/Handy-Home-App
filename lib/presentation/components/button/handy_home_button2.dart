import 'package:flutter/material.dart';
import 'package:handy_home_app/commons/theme/colors.dart';

class HandyHomeButton2 extends StatelessWidget {
  const HandyHomeButton2({
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
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: disable ? kGray3 : kBlue1,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: kWhite),
        ),
      ),
    );
  }
}
