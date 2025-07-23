import 'package:handy_home_app/data/models/room_model.dart';
import 'package:handy_home_app/data/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HomeModel {
  final int id;

  final List<RoomModel> roomList;

  final UserModel user;

  HomeModel({required this.id, required this.roomList, required this.user});

  factory HomeModel.fromJson(Map<String, dynamic> json) =>
      _$HomeModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeModelToJson(this);
}