// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponseListModel<T> _$ApiResponseListModelFromJson<T>(
        Map<String, dynamic> json) =>
    ApiResponseListModel<T>(
      statusCd: (json['status_cd'] as num).toInt(),
      statusMsg: json['status_msg'] as String?,
      success: json['success'] as bool,
      body: (json['body'] as List<dynamic>)
          .map(GenericConverter<T>().fromJson)
          .toList(),
    );

Map<String, dynamic> _$ApiResponseListModelToJson<T>(
        ApiResponseListModel<T> instance) =>
    <String, dynamic>{
      'status_cd': instance.statusCd,
      'status_msg': instance.statusMsg,
      'success': instance.success,
      'body': instance.body.map(GenericConverter<T>().toJson).toList(),
    };
