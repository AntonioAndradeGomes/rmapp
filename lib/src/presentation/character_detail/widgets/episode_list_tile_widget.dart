import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/episode/entities/episode_entity.dart';

class EpisodeListTileWidget extends StatelessWidget {
  final EpisodeEntity entity;
  final GestureTapCallback? onTap;
  const EpisodeListTileWidget({
    super.key,
    required this.entity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      leading: const Icon(
        Icons.movie_creation_rounded,
      ),
      title: Text(
        entity.name,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entity.episode,
          ),
          Text(
            entity.airDate,
          ),
        ],
      ),
    );
  }
}
