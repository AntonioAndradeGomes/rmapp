import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';
import 'package:rmapp/src/presentation/widgets/character_item_widget.dart';

class ListCharactersWidget extends StatelessWidget {
  final List<CharacterEntity> items;
  const ListCharactersWidget({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(
        bottom: 20,
        left: 10,
        right: 10,
        top: 10,
      ),
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(
        height: 5,
      ),
      itemBuilder: (_, index) {
        final item = items[index];
        return CharacterItemWidget(
          item: item,
        );
      },
    );
  }
}
