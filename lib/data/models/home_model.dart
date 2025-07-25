import 'dart:convert';

import 'package:handy_home_app/data/models/room_model.dart';
import 'package:handy_home_app/data/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_model.g.dart';

@JsonSerializable(explicitToJson: true)
class HomeModel {
  final int id;

  final int? sourceId;

  final String name;

  final List<RoomModel> roomList;

  final UserModel user;

  final bool isPreview;

  HomeModel({required this.id, required this.name, required this.roomList, required this.user, required this.isPreview, required this.sourceId});

  factory HomeModel.fromJson(Map<String, dynamic> json) =>
      _$HomeModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeModelToJson(this);
}

extension HomeModelExtensions on HomeModel {
  List<Map<String, dynamic>> toRoomListJson() => roomList.map((e) => e.toJson()).toList();
}