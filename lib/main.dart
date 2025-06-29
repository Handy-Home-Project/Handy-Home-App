import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

void main() {
  runApp(const MaterialApp(
    home: HandyHomeApplication(),
  ));
}

class HandyHomeApplication extends StatefulWidget {
  const HandyHomeApplication({super.key});

  @override
  State<HandyHomeApplication> createState() => _HandyHomeApplicationState();
}

class _HandyHomeApplicationState extends State<HandyHomeApplication> {
  bool unityOn = false;
  UnityWidgetController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: unityOn ? UnityWidget(
              onUnityCreated: (controller) => this.controller = controller,
              fullscreen: false,
            ) : SizedBox(),
          ),
          controller == null ? TextButton(
            onPressed: () {
              if (!unityOn) setState(() => unityOn = true);
            },
            child: Text("Unity 실행"),
          ) : Row(
            children: [
              TextButton(
                onPressed: () {
                  controller?.postJsonMessage("ServiceManager", "", {});
                },
                child: Text("메세지 전송"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    unityOn = false;
                    controller?.dispose();
                    controller = null;
                  });
                },
                child: Text("Unity 종료"),
              ),
            ],
          )
        ],
      )
    );
  }
}
