import 'package:flutter/material.dart';
import 'package:handy_home_app/commons/theme/colors.dart';

class HandyHomeTextEditingBox extends StatelessWidget {
  const HandyHomeTextEditingBox({
    super.key,
    required this.controller,
    this.hint,
    this.onChanged,
  });

  final String? hint;

  final TextEditingController controller;

  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: kGray1,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: TextField(
          style: Theme.of(context).textTheme.bodyMedium,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: kBlack.withOpacity(0.5)),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
