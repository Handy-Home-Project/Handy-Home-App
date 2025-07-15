import 'package:json_annotation/json_annotation.dart';

part 'floor_plan_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class FloorPlanModel {

  final String pyeongNo;

  final String pyeongName;

  final double supplyArea;

  final String floorPlanUrl;

  FloorPlanModel({
    required this.pyeongNo,
    required this.pyeongName,
    required this.supplyArea,
    required this.floorPlanUrl,
  });

  factory FloorPlanModel.fromJson(Map<String, dynamic> json) => _$FloorPlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$FloorPlanModelToJson(this);

}