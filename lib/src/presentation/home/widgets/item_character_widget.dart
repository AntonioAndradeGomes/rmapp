import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rmapp/src/domain/character/entities/character_entity.dart';

class ItemCharacterWidget extends StatelessWidget {
  final CharacterEntity item;
  final GestureTapCallback? onTap;

  const ItemCharacterWidget({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: onTap,
              child: CachedNetworkImage(
                imageUrl: item.image,
                fit: BoxFit.cover,
                errorWidget: (_, object, stack) => const Icon(
                  Icons.image_not_supported_outlined,
                  size: 50,
                ),
                imageBuilder: (_, imageProvider) {
                  return Ink.image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: Colors.black45,
                padding: const EdgeInsets.all(5),
                child: Text(
                  item.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
