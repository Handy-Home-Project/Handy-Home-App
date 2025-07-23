import 'package:json_annotation/json_annotation.dart';

part 'room_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RoomModel {
  final String name;
  final String vertexes;
  final RoomType type;

  RoomModel({required this.name, required this.vertexes, required this.type});

  factory RoomModel.fromJson(Map<String, dynamic> json) =>
      _$RoomModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoomModelToJson(this);
}

enum RoomType {
  LIVING_ROOM("거실"),
  KITCHEN("부엌"),
  BATH_ROOM("화장실"),
  VALCONY("발코니"),
  ROOM("방"),
  OTHER("기타");

  final String title;

  const RoomType(this.title);
}