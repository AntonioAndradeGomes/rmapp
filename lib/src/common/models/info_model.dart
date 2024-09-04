import 'package:rmapp/src/common/entities/info_entity.dart';

class InfoModel extends InfoEntity {
  const InfoModel({
    required super.count,
    required super.pages,
    required super.next,
    required super.prev,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) => InfoModel(
        count: json['count'],
        pages: json['pages'],
        next: json['next'],
        prev: json['prev'],
      );
}
