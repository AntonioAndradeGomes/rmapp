import 'package:flutter/material.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';

import 'package:rmapp/src/common/widgets/error_widget.dart';
import 'package:rmapp/src/dependencies/dependencies_injector.dart';

import 'package:rmapp/src/presentation/favorites/controllers/favorites_controller.dart';
import 'package:rmapp/src/presentation/favorites/controllers/favorites_state.dart';
import 'package:rmapp/src/presentation/favorites/widgets/list_view_favorites_characters_widget.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final _controller = injector<FavoritesController>();

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
            return ListViewFavoritesCharactersWidget(
              items: list,
              onRemove: (value) {
                try {
                  _controller.removeCharacter(value);
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
