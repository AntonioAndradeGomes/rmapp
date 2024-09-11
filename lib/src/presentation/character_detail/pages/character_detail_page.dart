import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rmapp/providers.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';
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
                content:
                    const Text('Character added to favorites successfully'),
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
      body: CustomScrollView(
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
          EpisodesSliverWidget(
            valueListenable: _controller,
            errorOnPressed: () {
              _controller.loadData(
                urls: widget.characterEntity.episode,
              );
            },
          )
        ],
      ),
    );
  }
}
