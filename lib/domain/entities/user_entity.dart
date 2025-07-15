import '../../data/models/user_model.dart';

class UserEntity {

  final int id;

  final String name;

  UserEntity({required this.id, required this.name});

  factory UserEntity.fromUserModel(UserModel model) => UserEntity(id: model.id, name: model.name);

}