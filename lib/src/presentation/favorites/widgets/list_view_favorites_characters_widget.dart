import 'package:flutter/material.dart';
import 'package:rmapp/src/common/routes/routes.dart';
import 'package:rmapp/src/domain/character/entities/character_entity.dart';
import 'package:rmapp/src/presentation/widgets/character_item_widget.dart';

class ListViewFavoritesCharactersWidget extends StatelessWidget {
  final List<CharacterEntity> items;
  final ValueChanged<CharacterEntity>? onRemove;

  const ListViewFavoritesCharactersWidget({
    super.key,
    required this.items,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Text(
          'There is no favorite character!',
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemBuilder: (_, index) {
        final item = items[index];
        return CharacterItemWidget(
          item: item,
          onTap: () {
            Navigator.of(context).pushNamed(
              Routes.characterDetail,
              arguments: item,
            );
          },
          onPressedRemove: () {
            onRemove != null ? onRemove!(item) : null;
          },
        );
      },
      separatorBuilder: (_, __) => const SizedBox(
        height: 10,
      ),
      itemCount: items.length,
    );
  }
}
