import 'package:flutter/material.dart';
import 'package:rmapp/src/dependencies/dependencies_injector.dart';
import 'package:rmapp/src/domain/character/entities/character_entity.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/character/save_character_controller.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/episode/episodes_controller.dart';
import 'package:rmapp/src/presentation/character_detail/widgets/details_character_widget.dart';
import 'package:rmapp/src/presentation/character_detail/widgets/episodes_sliver_widget.dart';
import 'package:rmapp/src/presentation/character_detail/widgets/load_add_character_widget.dart';
import 'package:rmapp/src/presentation/character_detail/widgets/sliver_appbar_character_widget.dart';

class CharacterDetailPage extends StatefulWidget {
  final CharacterEntity characterEntity;
  const CharacterDetailPage({
    super.key,
    required this.characterEntity,
  });

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage>
    with SingleTickerProviderStateMixin {
  final _controller = injector<EpisodesController>();
  final _savingDataController = injector<SaveCharacterController>();

  @override
  void initState() {
    _controller.loadData(
      urls: widget.characterEntity.episode,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DefaultTabController(
          length: 2,
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _savingDataController.saveData(
                  entity: widget.characterEntity,
                );
              },
              elevation: 0,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.save,
              ),
            ),
            body: NestedScrollView(
              headerSliverBuilder: (
                context,
                innerBoxIsScrolled,
              ) {
                return [
                  SliverAppbarCharacterWidget(
                    characterEntity: widget.characterEntity,
                  ),
                ];
              },
              body: TabBarView(
                children: [
                  DetailsCharacterWidget(
                    characterEntity: widget.characterEntity,
                  ),
                  EpisodesSliverWidget(
                    valueListenable: _controller,
                  ),
                ],
              ),
            ),
          ),
        ),
        LoadAddCharacterWidget(
          savingController: _savingDataController,
        ),
      ],
    );
  }
}
