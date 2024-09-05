import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/entities/episode_entity.dart';
import 'package:rmapp/src/presentation/character_detail/widgets/episode_list_tile_widget.dart';
import 'package:rmapp/src/presentation/episode_detail/page/episode_detail_page.dart';

class EpisodesColumnWidget extends StatelessWidget {
  final List<EpisodeEntity> episodes;
  const EpisodesColumnWidget({
    super.key,
    required this.episodes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
