import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/episode/entities/episode_entity.dart';
import 'package:rmapp/src/presentation/character_detail/widgets/episode_list_tile_widget.dart';
import 'package:rmapp/src/presentation/episode_detail/page/episode_detail_page.dart';

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
    return ListView(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: episodes
          .map(
            (e) => EpisodeListTileWidget(
              entity: e,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EpisodeDetailPage(
                      episodeEntity: e,
                    ),
                  ),
                );
              },
            ),
          )
          .toList(),
    );
  }
}
