import 'package:flutter/material.dart';
import 'package:rmapp/src/common/routes/routes.dart';
import 'package:rmapp/src/domain/episode/entities/episode_entity.dart';
import 'package:rmapp/src/presentation/character_detail/widgets/episode_list_tile_widget.dart';

class EpisodesListWidget extends StatelessWidget {
  final List<EpisodeEntity> episodes;
  final ScrollController? controller;
  const EpisodesListWidget({
    super.key,
    required this.episodes,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: const PageStorageKey<String>('episodes'),
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverList.builder(
          itemCount: episodes.length,
          itemBuilder: (context, index) {
            final entity = episodes[index];
            return EpisodeListTileWidget(
              entity: entity,
              onTap: () {
                Navigator.of(context).pushNamed(
                  Routes.episodeDetail,
                  arguments: entity,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
