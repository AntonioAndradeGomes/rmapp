import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/character/entities/character_entity.dart';
import 'package:rmapp/src/domain/episode/entities/episode_entity.dart';
import 'package:rmapp/src/presentation/character_detail/pages/character_detail_page.dart';
import 'package:rmapp/src/presentation/episode_detail/page/episode_detail_page.dart';
import 'package:rmapp/src/presentation/favorites/pages/favorites_page.dart';
import 'package:rmapp/src/presentation/home/pages/home_page.dart';

abstract class Routes {
  static const String home = '/';
  static const String characterDetail = '/character-detail';
  static const String episodeDetail = '/episode-detail';
  static const String charactersFavorite = '/character-favorite';

  static MaterialPageRoute onGenerateRoute(
    RouteSettings settings,
  ) {
    log(
      settings.name.toString(),
      time: DateTime.now(),
    );

    switch (settings.name) {
      case charactersFavorite:
        return MaterialPageRoute(
          builder: (_) => const FavoritesPage(),
        );
      case episodeDetail:
        return MaterialPageRoute(
          builder: (_) => EpisodeDetailPage(
            episodeEntity: settings.arguments as EpisodeEntity,
          ),
        );
      case characterDetail:
        return MaterialPageRoute(
          builder: (_) => CharacterDetailPage(
            characterEntity: settings.arguments as CharacterEntity,
          ),
        );
      case home:
      default:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
        );
    }
  }
}
