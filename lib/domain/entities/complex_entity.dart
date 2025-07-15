import 'package:handy_home_app/data/models/complex_model.dart';

class ComplexEntity {
  final String complexNo;

  final String title;

  final String address;

  ComplexEntity({
    required this.complexNo,
    required this.title,
    required this.address,
  });

  factory ComplexEntity.fromModel(ComplexModel model) => ComplexEntity(
    complexNo: model.complexNo,
    title: model.title,
    address: model.address,
  );
}
