import 'package:json_annotation/json_annotation.dart';

import '../../commons/utils/generic_converter.dart';

part 'api_response_list_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ApiResponseListModel<T> {
  final int statusCd;

  final String? statusMsg;

  final bool success;

  @GenericConverter()
  final List<T> body;

  ApiResponseListModel({
    required this.statusCd,
    required this.statusMsg,
    required this.success,
    required this.body,
  });

  factory ApiResponseListModel.fromJson(Map<String, dynamic> json) => _$ApiResponseListModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseListModelToJson(this);
}