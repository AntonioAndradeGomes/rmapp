import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';
import 'package:rmapp/src/presentation/character_detail/widgets/detail_list_tile_widget.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            actions: const [
              Icon(
                Icons.movie,
              ),
            ],
            forceElevated: true,
            stretch: true,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                fit: BoxFit.cover,
                widget.characterEntity.image,
              ),
              collapseMode: CollapseMode.pin,
              title: Text(
                widget.characterEntity.name,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                DetailListTileWidget(
                  icon: Icons.heart_broken_rounded,
                  title: 'Status',
                  subtitle: widget.characterEntity.status,
                ),
                DetailListTileWidget(
                  icon: Icons.pets,
                  title: 'Species',
                  subtitle: widget.characterEntity.species,
                ),
                DetailListTileWidget(
                  icon: Icons.info,
                  title: 'Type',
                  subtitle: widget.characterEntity.type.isEmpty
                      ? 'Unknown'
                      : widget.characterEntity.type,
                ),
                DetailListTileWidget(
                  icon: Icons.transgender_rounded,
                  title: 'Gender',
                  subtitle: widget.characterEntity.gender,
                ),
                DetailListTileWidget(
                  icon: Icons.location_on_rounded,
                  title: 'Location',
                  subtitle: widget.characterEntity.locationName,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
