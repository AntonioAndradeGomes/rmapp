import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rmapp/src/common/widgets/error_widget.dart';
import 'package:rmapp/src/presentation/character_detail/controllers/episodes_state.dart';
import 'package:rmapp/src/presentation/character_detail/widgets/episodes_list_widget.dart';

class EpisodesSliverWidget extends StatelessWidget {
  final ValueListenable<EpisodesState> valueListenable;
  final VoidCallback? errorOnPressed;
  final ScrollController? controller;
  const EpisodesSliverWidget({
    super.key,
    required this.valueListenable,
    this.errorOnPressed,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: valueListenable,
      builder: (_, state, __) {
        if (state is LoadingEpisodesState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is SuccessEpisodesState) {
          return EpisodesListWidget(
            episodes: state.episodes!,
            controller: controller,
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
    );
  }
}
