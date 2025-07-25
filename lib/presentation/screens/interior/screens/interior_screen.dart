import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:handy_home_app/commons/theme/colors.dart';
import 'package:handy_home_app/data/models/home_model.dart';

class InteriorScreen extends StatelessWidget {
  const InteriorScreen({super.key, required this.home});

  final HomeModel home;

  final String jsonSample = """
[
  {
    "name": "거실 1",
    "type": "LIVING_ROOM",
    "vertexes": [
      [
        14.63,
        0.0
      ],
      [
        14.63,
        32.84
      ],
      [
        53.32,
        32.84
      ],
      [
        53.32,
        45.11
      ],
      [
        73.61,
        45.11
      ],
      [
        73.61,
        32.84
      ],
      [
        87.29,
        32.84
      ],
      [
        87.29,
        18.92
      ],
      [
        53.32,
        18.92
      ],
      [
        53.32,
        0.0
      ]
    ]
  },
  {
    "name": "방 1",
    "type": "ROOM",
    "vertexes": [
      [
        14.63,
        32.84
      ],
      [
        14.63,
        68.7
      ],
      [
        53.32,
        68.7
      ],
      [
        53.32,
        32.84
      ]
    ]
  },
  {
    "name": "방 2",
    "type": "ROOM",
    "vertexes": [
      [
        73.61,
        32.84
      ],
      [
        73.61,
        68.7
      ],
      [
        100.51,
        68.7
      ],
      [
        100.51,
        32.84
      ]
    ]
  },
  {
    "name": "부엌 1",
    "type": "KITCHEN",
    "vertexes": [
      [
        53.32,
        0.0
      ],
      [
        53.32,
        18.92
      ],
      [
        83.05,
        18.92
      ],
      [
        83.05,
        0.0
      ]
    ]
  },
  {
    "name": "기타 1",
    "type": "OTHER",
    "vertexes": [
      [
        87.29,
        18.92
      ],
      [
        87.29,
        32.84
      ],
      [
        100.51,
        32.84
      ],
      [
        100.51,
        18.92
      ]
    ]
  },
  {
    "name": "발코니 1",
    "type": "VALCONY",
    "vertexes": [
      [
        3.3,
        9.01
      ],
      [
        0.0,
        13.97
      ],
      [
        0.0,
        68.7
      ],
      [
        14.63,
        68.7
      ],
      [
        14.63,
        9.01
      ]
    ]
  },
  {
    "name": "화장실 1",
    "type": "BATH_ROOM",
    "vertexes": [
      [
        53.32,
        45.11
      ],
      [
        53.32,
        68.7
      ],
      [
        70.31,
        68.7
      ],
      [
        70.31,
        45.11
      ]
    ]
  },
  {
    "name": "기타 2",
    "type": "OTHER",
    "vertexes": [
      [
        3.3,
        0.0
      ],
      [
        3.3,
        9.01
      ],
      [
        14.63,
        9.01
      ],
      [
        14.63,
        0.0
      ]
    ]
  },
  {
    "name": "기타 3",
    "type": "OTHER",
    "vertexes": [
      [
        83.05,
        0.0
      ],
      [
        83.05,
        3.59
      ],
      [
        88.71,
        3.59
      ],
      [
        88.71,
        0.0
      ]
    ]
  },
  {
    "name": "기타 4",
    "type": "OTHER",
    "vertexes": [
      [
        93.9,
        0.0
      ],
      [
        93.9,
        6.42
      ],
      [
        100.51,
        6.42
      ],
      [
        100.51,
        0.0
      ]
    ]
  },
  {
    "name": "기타 5",
    "type": "OTHER",
    "vertexes": [
      [
        70.31,
        45.11
      ],
      [
        70.31,
        68.7
      ],
      [
        73.61,
        68.7
      ],
      [
        73.61,
        45.11
      ]
    ]
  }
]
""";

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
                  controller.postMessage('Room', 'ParseRoomData', jsonSample);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
