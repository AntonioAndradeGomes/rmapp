import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/entities/episode_entity.dart';

class EpisodeDetailsWidget extends StatelessWidget {
  final EpisodeEntity episodeEntity;
  const EpisodeDetailsWidget({
    super.key,
    required this.episodeEntity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          episodeEntity.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          episodeEntity.airDate,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          'Characteres',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
