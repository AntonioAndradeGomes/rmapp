import 'package:flutter/material.dart';
import 'package:rmapp/providers.dart';
import 'package:rmapp/src/presentation/home/controllers/characters/characters_controller.dart';
import 'package:rmapp/src/presentation/home/controllers/characters/characters_state.dart';
import 'package:rmapp/src/presentation/home/widgets/itens_characters_grid_widget.dart';
import 'package:rmapp/src/presentation/home/widgets/loading_more_items_widget.dart';

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
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: const Icon(
                  Icons.search,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
              ),
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
                      ),
                      LoadingMoreItemsWidget(
                        valueListenable: _controller.loadingMore,
                      ),
                    ],
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
