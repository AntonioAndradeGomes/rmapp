import 'package:equatable/equatable.dart';
import 'package:rmapp/src/common/entities/info_entity.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';

class CharacterReturnEntity extends Equatable {
  final InfoEntity info;
  final List<CharacterEntity> results;

  const CharacterReturnEntity({
    required this.info,
    required this.results,
  });

  @override
  List<Object?> get props => [info, results];
}
