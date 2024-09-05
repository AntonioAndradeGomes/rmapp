import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/entities/character_entity.dart';
import 'package:rmapp/src/presentation/character_detail/widgets/detail_list_tile_widget.dart';

class DetailsCharacterWidget extends StatelessWidget {
  final CharacterEntity characterEntity;
  const DetailsCharacterWidget({
    super.key,
    required this.characterEntity,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          DetailListTileWidget(
            icon: Icons.heart_broken_rounded,
            title: 'Status',
            subtitle: characterEntity.status,
          ),
          DetailListTileWidget(
            icon: Icons.pets,
            title: 'Species',
            subtitle: characterEntity.species,
          ),
          DetailListTileWidget(
            icon: Icons.info,
            title: 'Type',
            subtitle:
                characterEntity.type.isEmpty ? 'Unknown' : characterEntity.type,
          ),
          DetailListTileWidget(
            icon: Icons.transgender_rounded,
            title: 'Gender',
            subtitle: characterEntity.gender,
          ),
          DetailListTileWidget(
            icon: Icons.location_on_rounded,
            title: 'Location',
            subtitle: characterEntity.locationName,
            isThreeLine: false,
          ),
        ],
      ),
    );
  }
}
