import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/character/entities/character_entity.dart';

class SliverAppbarCharacterWidget extends StatelessWidget {
  final CharacterEntity characterEntity;
  const SliverAppbarCharacterWidget({
    super.key,
    required this.characterEntity,
  });

  @override
  Widget build(BuildContext context) {
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      sliver: SliverAppBar(
        pinned: true,
        floating: false,
        expandedHeight: 340,
        centerTitle: true,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.only(
            bottom: 50,
          ),
          centerTitle: true,
          background: CachedNetworkImage(
            fit: BoxFit.fitWidth,
            imageUrl: characterEntity.image,
          ),
          collapseMode: CollapseMode.pin,
          title: Text(
            characterEntity.name,
            textAlign: TextAlign.center,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Material(
            child: TabBar(
              tabs: const [
                Tab(
                  icon: Icon(Icons.info),
                ),
                Tab(
                  icon: Icon(Icons.movie),
                ),
              ],
              indicatorColor: Theme.of(context).primaryColor,
              dividerHeight: 0,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),
        ),
      ),
    );
  }
}
