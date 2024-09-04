import 'package:equatable/equatable.dart';

class CaracterSearchInput extends Equatable {
  final int page;
  final String search;

  const CaracterSearchInput({
    required this.page,
    required this.search,
  });
  @override
  List<Object?> get props => [
        page,
        search,
      ];
}
