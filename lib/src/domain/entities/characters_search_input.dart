import 'package:equatable/equatable.dart';

class CharactersSearchInput extends Equatable {
  final int page;
  final String search;

  const CharactersSearchInput({
    required this.page,
    required this.search,
  });
  @override
  List<Object?> get props => [
        page,
        search,
      ];
}
