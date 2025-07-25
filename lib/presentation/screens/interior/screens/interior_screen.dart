import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:handy_home_app/commons/theme/colors.dart';
import 'package:handy_home_app/data/models/home_model.dart';

class InteriorScreen extends StatelessWidget {
  const InteriorScreen({super.key, required this.home});

  final HomeModel home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: kTransparent,
        leading: GestureDetector(
          onTap: Navigator.of(context).pop,
          child: Icon(Icons.arrow_back_ios_rounded, color: kBlack),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: UnityWidget(
                onUnityCreated: (controller) {
                  print('onUnityCreated');
                  final data = home.toRoomListJson();
                  final prettyJson = const JsonEncoder.withIndent('  ').convert(data);
                  print(prettyJson);
                  controller.postMessage('Room', 'ParseRoomData', jsonEncode(data));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
