// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complex_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComplexDetailModel _$ComplexDetailModelFromJson(Map<String, dynamic> json) =>
    ComplexDetailModel(
      complex: ComplexModel.fromJson(json['complex'] as Map<String, dynamic>),
      floorPlans: (json['floor_plans'] as List<dynamic>)
          .map((e) => FloorPlanModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ComplexDetailModelToJson(ComplexDetailModel instance) =>
    <String, dynamic>{
      'complex': instance.complex.toJson(),
      'floor_plans': instance.floorPlans.map((e) => e.toJson()).toList(),
    };
