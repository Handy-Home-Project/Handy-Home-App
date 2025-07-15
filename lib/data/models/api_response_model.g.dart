// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponseModel<T> _$ApiResponseModelFromJson<T>(Map<String, dynamic> json) =>
    ApiResponseModel<T>(
      statusCd: (json['status_cd'] as num).toInt(),
      statusMsg: json['status_msg'] as String?,
      success: json['success'] as bool,
      body: GenericConverter<T>().fromJson(json['body']),
    );

Map<String, dynamic> _$ApiResponseModelToJson<T>(
        ApiResponseModel<T> instance) =>
    <String, dynamic>{
      'status_cd': instance.statusCd,
      'status_msg': instance.statusMsg,
      'success': instance.success,
      'body': GenericConverter<T>().toJson(instance.body),
    };
