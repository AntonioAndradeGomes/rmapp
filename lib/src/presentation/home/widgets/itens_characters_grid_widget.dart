import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';
import 'package:rmapp/src/presentation/character_detail/pages/character_detail_page.dart';
import 'package:rmapp/src/presentation/home/widgets/item_character_widget.dart';

class ItensCharactersGridWidget extends StatelessWidget {
  final ScrollController? scrollController;
  final List<CharacterEntity> items;
  const ItensCharactersGridWidget({
    super.key,
    this.scrollController,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      itemCount: items.length,
      shrinkWrap: true,
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 180, //tamanho máximo dos itens
        mainAxisExtent: 180,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (_, index) {
        final item = items[index];
        return ItemCharacterWidget(
          item: item,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CharacterDetailPage(
                  characterEntity: item,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
