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
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _controller.loadData(
      urls: widget.characterEntity.episode,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        elevation: 0,
        onPressed: () async {
          try {
            await _controller.saveData(
              entity: widget.characterEntity,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).primaryColor,
                content: const Text(
                  'Character added to favorites successfully',
                ),
              ),
            );
          } on CustomException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  e.customMessage!,
                ),
              ),
            );
          }
        },
        child: const Icon(
          Icons.save,
        ),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (_, isScrolled) {
          return [
            SliverAppBar(
              // forceMaterialTransparency: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              pinned: true,
              floating: false,
              expandedHeight: 300,
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
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
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: MyDelegate(
                tabBar: TabBar(
                  controller: _tabController,
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
                  indicatorSize: TabBarIndicatorSize.label,
                ),
              ),
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
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
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  MyDelegate({
    required this.tabBar,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
