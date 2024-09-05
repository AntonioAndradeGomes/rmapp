import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rmapp/src/common/widgets/error_widget.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/episodes_state.dart';
import 'package:rmapp/src/presentation/character_detail/widgets/episodes_column_widget.dart';

class EpisodesSliverWidget extends StatelessWidget {
  final ValueListenable<EpisodesState> valueListenable;
  final VoidCallback? errorOnPressed;
  const EpisodesSliverWidget({
    super.key,
    required this.valueListenable,
    this.errorOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const ListTile(
            dense: true,
            title: Text(
              'Episodes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            leading: Icon(
              Icons.movie_rounded,
            ),
          ),
          ValueListenableBuilder(
            valueListenable: valueListenable,
            builder: (_, state, __) {
              if (state is LoadingEpisodesState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SuccessEpisodesState) {
                return EpisodesColumnWidget(
                  episodes: state.episodes!,
                );
              }
              if (state is ErrorEpisodesState) {
                return ErrorLoadWidget(
                  message: state.exception!.customMessage!,
                  messageButton: 'Search again',
                  onPressed: errorOnPressed,
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
