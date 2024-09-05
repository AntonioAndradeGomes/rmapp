import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rmapp/providers.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/episodes_controller.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/episodes_state.dart';
import 'package:rmapp/src/presentation/character_detail/widgets/details_character_widget.dart';
import 'package:rmapp/src/presentation/character_detail/widgets/episode_list_tile_widget.dart';

class CharacterDetailPage extends StatefulWidget {
  final CharacterEntity characterEntity;
  const CharacterDetailPage({
    super.key,
    required this.characterEntity,
  });

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  final _controller = getIt<EpisodesController>();

  @override
  void initState() {
    _controller.loadData(
      urls: widget.characterEntity.episode,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              centerTitle: true,
              expandedHeight: 250,
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  fit: BoxFit.fitWidth,
                  imageUrl: widget.characterEntity.image,
                ),
                collapseMode: CollapseMode.pin,
                title: Text(
                  widget.characterEntity.name,
                ),
              ),
            ),
            DetailsCharacterWidget(
              characterEntity: widget.characterEntity,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const ListTile(
                    dense: true,
                    title: Text(
                      'Episodes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    leading: Icon(
                      Icons.movie_rounded,
                    ),
                  ),
                  ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (_, state, __) {
                      if (state is LoadinEpisodesState) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is SuccessEpisodesState) {
                        return Column(
                          children: state.episodes!
                              .map(
                                (e) => EpisodeListTileWidget(
                                  entity: e,
                                ),
                              )
                              .toList(),
                        );
                      }
                      if (state is ErrorEpisodesState) {
                        return Center(
                          child: Column(
                            children: [
                              Text(
                                state.exception!.customMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              FilledButton(
                                onPressed: () {
                                  _controller.loadData(
                                    urls: widget.characterEntity.episode,
                                  );
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text(
                                  'Search again',
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
