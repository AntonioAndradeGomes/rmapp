import 'package:equatable/equatable.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/domain/entities/episode_entity.dart';

sealed class EpisodesState extends Equatable {
  final List<EpisodeEntity>? episodes;
  final CustomException? exception;

  const EpisodesState({
    this.episodes,
    this.exception,
  });

  @override
  List<Object?> get props => [
        exception,
        episodes,
      ];
}

class LoadinEpisodesState extends EpisodesState {}

class SuccessEpisodesState extends EpisodesState {
  const SuccessEpisodesState(
    List<EpisodeEntity> episodes,
  ) : super(
          episodes: episodes,
        );
}

class ErrorEpisodesState extends EpisodesState {
  const ErrorEpisodesState(CustomException customException)
      : super(
          exception: customException,
        );
}
