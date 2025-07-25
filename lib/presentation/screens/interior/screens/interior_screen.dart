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
    "vertex": [
      [
        146.28,
        0.0
      ],
      [
        146.28,
        328.41
      ],
      [
        533.2,
        328.41
      ],
      [
        533.2,
        451.1
      ],
      [
        736.1,
        451.1
      ],
      [
        736.1,
        328.41
      ],
      [
        872.94,
        328.41
      ],
      [
        872.94,
        189.22
      ],
      [
        533.2,
        189.22
      ],
      [
        533.2,
        0.0
      ]
    ]
  },
  {
    "name": "방 1",
    "type": "ROOM",
    "vertex": [
      [
        146.28,
        328.41
      ],
      [
        146.28,
        687.03
      ],
      [
        533.2,
        687.03
      ],
      [
        533.2,
        328.41
      ]
    ]
  },
  {
    "name": "방 2",
    "type": "ROOM",
    "vertex": [
      [
        736.1,
        328.41
      ],
      [
        736.1,
        687.03
      ],
      [
        1005.06,
        687.03
      ],
      [
        1005.06,
        328.41
      ]
    ]
  },
  {
    "name": "부엌 1",
    "type": "KITCHEN",
    "vertex": [
      [
        533.2,
        0.0
      ],
      [
        533.2,
        189.22
      ],
      [
        830.47,
        189.22
      ],
      [
        830.47,
        0.0
      ]
    ]
  },
  {
    "name": "기타 1",
    "type": "OTHER",
    "vertex": [
      [
        872.94,
        189.22
      ],
      [
        872.94,
        328.41
      ],
      [
        1005.06,
        328.41
      ],
      [
        1005.06,
        189.22
      ]
    ]
  },
  {
    "name": "발코니 1",
    "type": "VALCONY",
    "vertex": [
      [
        33.03,
        90.12
      ],
      [
        0.0,
        139.67
      ],
      [
        0.0,
        687.03
      ],
      [
        146.28,
        687.03
      ],
      [
        146.28,
        90.12
      ]
    ]
  },
  {
    "name": "화장실 1",
    "type": "BATH_ROOM",
    "vertex": [
      [
        533.2,
        451.1
      ],
      [
        533.2,
        687.03
      ],
      [
        703.07,
        687.03
      ],
      [
        703.07,
        451.1
      ]
    ]
  },
  {
    "name": "기타 2",
    "type": "OTHER",
    "vertex": [
      [
        33.03,
        0.0
      ],
      [
        33.03,
        90.12
      ],
      [
        146.28,
        90.12
      ],
      [
        146.28,
        0.0
      ]
    ]
  },
  {
    "name": "기타 3",
    "type": "OTHER",
    "vertex": [
      [
        830.47,
        0.0
      ],
      [
        830.47,
        35.86
      ],
      [
        887.09,
        35.86
      ],
      [
        887.09,
        0.0
      ]
    ]
  },
  {
    "name": "기타 4",
    "type": "OTHER",
    "vertex": [
      [
        939.0,
        0.0
      ],
      [
        939.0,
        64.17
      ],
      [
        1005.06,
        64.17
      ],
      [
        1005.06,
        0.0
      ]
    ]
  },
  {
    "name": "기타 5",
    "type": "OTHER",
    "vertex": [
      [
        703.07,
        451.1
      ],
      [
        703.07,
        687.03
      ],
      [
        736.1,
        687.03
      ],
      [
        736.1,
        451.1
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
