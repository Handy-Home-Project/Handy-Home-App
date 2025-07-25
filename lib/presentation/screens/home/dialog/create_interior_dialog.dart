import 'package:flutter/material.dart';
import 'package:handy_home_app/commons/theme/colors.dart';

import '../../../components/button/handy_home_button1.dart';

class CreateInteriorDialog extends StatelessWidget {
  const CreateInteriorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kWhite,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20))
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '인테리어 생성 방법을\n선택해주세요.',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Row(
              spacing: 14,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: HandyHomeButton1(
                    text: '빈 방 생성하기',
                    onTap: () {
                      Navigator.of(context).pop(0);
                    },
                  ),
                ),
                Expanded(
                  child: HandyHomeButton1(
                    text: 'AI 인테리어 생성하기',
                    onTap: () {
                      Navigator.of(context).pop(1);
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
