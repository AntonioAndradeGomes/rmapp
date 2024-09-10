import 'package:flutter/material.dart';
import 'package:rmapp/providers.dart';
import 'package:rmapp/src/common/widgets/error_widget.dart';
import 'package:rmapp/src/presentation/favorites/pages/favorites_page.dart';
import 'package:rmapp/src/presentation/home/controllers/characters/characters_controller.dart';
import 'package:rmapp/src/presentation/home/controllers/characters/characters_state.dart';
import 'package:rmapp/src/presentation/home/widgets/itens_characters_grid_widget.dart';
import 'package:rmapp/src/presentation/home/widgets/loading_more_items_widget.dart';
import 'package:rmapp/src/presentation/home/widgets/search_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = getIt<CharactersController>();

  @override
  void initState() {
    super.initState();
    _controller.loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick & Morty'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const FavoritesPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.favorite,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SearchWidget(
              hintText: 'Search',
              onChanged: (value) {
                _controller.onFilter(value);
              },
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _controller,
              builder: (_, state, __) {
                if (state is LoadingCharactersState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is SuccessCharactersState) {
                  final items = state.characterReturnEntity!.results;
                  return Stack(
                    children: [
                      ItensCharactersGridWidget(
                        items: items,
                        scrollController: _controller.scrollController,
                        loadMore: _controller.loadMoreItens,
                      ),
                      LoadingMoreItemsWidget(
                        valueListenable: _controller.loadingMore,
                      ),
                    ],
                  );
                }
                if (state is ErrorCharactersState) {
                  return ErrorLoadWidget(
                    message: state.customException!.customMessage!,
                    messageButton: 'Search again',
                    onPressed: _controller.loadData,
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
