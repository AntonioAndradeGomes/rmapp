import 'package:flutter/material.dart';
import 'package:rmapp/providers.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/widgets/error_widget.dart';
import 'package:rmapp/src/presentation/character_detail/pages/character_detail_page.dart';
import 'package:rmapp/src/presentation/favorites/controllers/favorites_controller.dart';
import 'package:rmapp/src/presentation/favorites/controllers/favorites_state.dart';
import 'package:rmapp/src/presentation/widgets/character_item_widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final _controller = getIt<FavoritesController>();

  @override
  void initState() {
    _controller.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favorites',
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: _controller,
        builder: (_, state, __) {
          if (state is LoadingFavoritesState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SuccessFavoritesState) {
            final list = state.characteres!;
            if (list.isEmpty) {
              return const Center(
                child: Text(
                  'There is no favorite character!',
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(10),
              itemBuilder: (_, index) {
                final item = list[index];
                return CharacterItemWidget(
                  item: item,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CharacterDetailPage(
                          characterEntity: item,
                        ),
                      ),
                    );
                  },
                  onPressedRemove: () {
                    try {
                      _controller.removeCharacter(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Theme.of(context).primaryColor,
                          content: const Text(
                            'Character removed successfully!',
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
                );
              },
              separatorBuilder: (_, __) => const SizedBox(
                height: 10,
              ),
              itemCount: list.length,
            );
          }

          if (state is ErrorFavoritesState) {
            final err = state.exception!;
            return ErrorLoadWidget(
              message: err.customMessage!,
              messageButton: 'Try again',
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
