import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/dependencies/dependencies_injector.dart';
import 'package:rmapp/src/domain/character/entities/character_entity.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/episodes_controller.dart';
import 'package:rmapp/src/presentation/character_detail/widgets/details_character_widget.dart';
import 'package:rmapp/src/presentation/character_detail/widgets/episodes_sliver_widget.dart';

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

  @override
  void initState() {
    _controller.loadData(
      urls: widget.characterEntity.episode,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              await _controller.saveData(
                entity: widget.characterEntity,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Character added to favorites successfully',
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            } on CustomException catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    e.customMessage!,
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
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
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
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
                      imageUrl: widget.characterEntity.image,
                    ),
                    collapseMode: CollapseMode.pin,
                    title: Text(
                      widget.characterEntity.name,
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
    );
  }
}
