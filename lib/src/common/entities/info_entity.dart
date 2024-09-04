import 'package:equatable/equatable.dart';

class InfoEntity extends Equatable {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  const InfoEntity({
    required this.count,
    required this.pages,
    required this.next,
    required this.prev,
  });

  @override
  List<Object?> get props => [
        count,
        pages,
        next,
        prev,
      ];
}
