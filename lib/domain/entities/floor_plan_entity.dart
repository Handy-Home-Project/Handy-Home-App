import 'package:handy_home_app/data/models/floor_plan_model.dart';

class FloorPlanEntity {
  final String pyeongNo;

  final String pyeongName;

  final double supplyArea;

  final String floorPlanUrl;

  FloorPlanEntity({
    required this.pyeongNo,
    required this.pyeongName,
    required this.supplyArea,
    required this.floorPlanUrl,
  });

  factory FloorPlanEntity.fromModel(FloorPlanModel model) => FloorPlanEntity(
    pyeongNo: model.pyeongNo,
    pyeongName: model.pyeongName,
    supplyArea: model.supplyArea,
    floorPlanUrl: model.floorPlanUrl,
  );
}
