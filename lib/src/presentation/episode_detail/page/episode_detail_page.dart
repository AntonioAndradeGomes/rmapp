import 'package:flutter/material.dart';
import 'package:rmapp/providers.dart';
import 'package:rmapp/src/common/widgets/error_widget.dart';
import 'package:rmapp/src/domain/entities/episode_entity.dart';
import 'package:rmapp/src/presentation/episode_detail/controllers/list_characteres_controller.dart';
import 'package:rmapp/src/presentation/episode_detail/controllers/list_characteres_state.dart';
import 'package:rmapp/src/presentation/episode_detail/widgets/episode_details_widget.dart';
import 'package:rmapp/src/presentation/episode_detail/widgets/list_characters_widget.dart';

class EpisodeDetailPage extends StatefulWidget {
  final EpisodeEntity episodeEntity;
  const EpisodeDetailPage({
    super.key,
    required this.episodeEntity,
  });

  @override
  State<EpisodeDetailPage> createState() => _EpisodeDetailPageState();
}

class _EpisodeDetailPageState extends State<EpisodeDetailPage> {
  final _controller = getIt<ListCharacteresController>();

  @override
  void initState() {
    _controller.loadData(
      urls: widget.episodeEntity.characters,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.episodeEntity.episode,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: EpisodeDetailsWidget(
              episodeEntity: widget.episodeEntity,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _controller,
            builder: (_, state, __) {
              if (state is LoadingListCharacteresState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SuccessListCharacteresState) {
                final items = state.characteres!;
                return Expanded(
                  child: ListCharactersWidget(
                    items: items,
                  ),
                );
              }
              if (state is ErrorListCharacteresState) {
                return ErrorLoadWidget(
                  message: state.exception!.customMessage!,
                  messageButton: 'Search again',
                  onPressed: () {
                    _controller.loadData(
                      urls: widget.episodeEntity.characters,
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
