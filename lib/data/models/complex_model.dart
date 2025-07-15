import 'package:json_annotation/json_annotation.dart';

part 'complex_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ComplexModel {

  final String complexNo;

  final String title;

  final String address;

  ComplexModel({
    required this.complexNo,
    required this.title,
    required this.address,
  });

  factory ComplexModel.fromJson(Map<String, dynamic> json) => _$ComplexModelFromJson(json);

  Map<String, dynamic> toJson() => _$ComplexModelToJson(this);
}