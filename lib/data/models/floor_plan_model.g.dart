// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floor_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FloorPlanModel _$FloorPlanModelFromJson(Map<String, dynamic> json) =>
    FloorPlanModel(
      pyeongNo: json['pyeong_no'] as String,
      pyeongName: json['pyeong_name'] as String,
      supplyArea: (json['supply_area'] as num).toDouble(),
      floorPlanUrl: json['floor_plan_url'] as String,
    );

Map<String, dynamic> _$FloorPlanModelToJson(FloorPlanModel instance) =>
    <String, dynamic>{
      'pyeong_no': instance.pyeongNo,
      'pyeong_name': instance.pyeongName,
      'supply_area': instance.supplyArea,
      'floor_plan_url': instance.floorPlanUrl,
    };
