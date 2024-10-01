import 'package:equatable/equatable.dart';
import 'package:rmapp/src/domain/character/entities/filter_character_entity.dart';

class CharactersSearchInput extends Equatable {
  final int page;
  final String search;
  final FilterCharacter filterCharacter;

  const CharactersSearchInput({
    required this.page,
    required this.search,
    required this.filterCharacter,
  });
  @override
  List<Object?> get props => [
        page,
        search,
        filterCharacter,
      ];
}
