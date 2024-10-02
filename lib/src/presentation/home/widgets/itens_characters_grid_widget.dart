import 'package:flutter/material.dart';
import 'package:rmapp/src/common/routes/routes.dart';
import 'package:rmapp/src/domain/character/entities/character_entity.dart';
import 'package:rmapp/src/presentation/home/widgets/item_character_widget.dart';

class ItensCharactersGridWidget extends StatefulWidget {
  final ScrollController scrollController;
  final List<CharacterEntity> items;
  final Future<void> Function() loadMore;
  const ItensCharactersGridWidget({
    super.key,
    required this.scrollController,
    required this.items,
    required this.loadMore,
  });

  @override
  State<ItensCharactersGridWidget> createState() =>
      _ItensCharactersGridWidgetState();
}

class _ItensCharactersGridWidgetState extends State<ItensCharactersGridWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfShouldLoadMore();
    });
    widget.scrollController.addListener(_onScroll);
  }

  void _checkIfShouldLoadMore() {
    if (widget.scrollController.position.maxScrollExtent == 0) {
      widget.loadMore();
    }
  }

  void _onScroll() {
    if (widget.scrollController.position.pixels >=
        widget.scrollController.position.maxScrollExtent) {
      widget.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _checkIfShouldLoadMore();
        });
        return GridView.builder(
          controller: widget.scrollController,
          itemCount: widget.items.length,
          // shrinkWrap: true,
          padding: const EdgeInsets.all(15),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180, //tamanho máximo dos itens
            mainAxisExtent: 180,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.3,
          ),
          itemBuilder: (_, index) {
            final item = widget.items[index];
            return ItemCharacterWidget(
              item: item,
              onTap: () {
                Navigator.of(context).pushNamed(
                  Routes.characterDetail,
                  arguments: item,
                );
              },
            );
          },
        );
      },
    );
  }
}
