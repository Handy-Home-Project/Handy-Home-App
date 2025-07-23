import 'package:json_annotation/json_annotation.dart';

import '../../commons/utils/generic_converter.dart';

part 'api_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ApiResponseModel<T> {
  final int statusCd;

  final String? statusMsg;

  final bool success;

  @GenericConverter()
  final T body;

  ApiResponseModel({
    required this.statusCd,
    required this.statusMsg,
    required this.success,
    required this.body,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseModelToJson(this);
}
