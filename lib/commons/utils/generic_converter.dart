
import 'package:json_annotation/json_annotation.dart';

import '../../data/models/complex_detail_model.dart';
import '../../data/models/complex_model.dart';
import '../../data/models/floor_plan_model.dart';
import '../../data/models/user_model.dart';

class GenericConverter<T> implements JsonConverter<T, Object?> {
  const GenericConverter();

  @override
  T fromJson(Object? json) {
    if (json is Map<String, dynamic>) {
      return switch (T) {
        UserModel => UserModel.fromJson(json),
        ComplexModel => ComplexModel.fromJson(json),
        ComplexDetailModel => ComplexDetailModel.fromJson(json),
        FloorPlanModel => FloorPlanModel.fromJson(json),
        _ => throw UnimplementedError('fromJson for type $T not implemented.')
      } as T;
    }
    throw ArgumentError('Invalid json for type $T: $json');
  }

  @override
  Object? toJson(T object) {
    if (object is JsonSerializable) {
      return (object as dynamic).toJson();
    }
    throw UnimplementedError('toJson for type $T not implemented.');
  }
}