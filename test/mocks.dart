import 'package:mocktail/mocktail.dart';
import 'package:rmapp/src/common/error/custom_exception.dart';
import 'package:rmapp/src/common/models/info_model.dart';
import 'package:rmapp/src/data/models/character_model.dart';
import 'package:rmapp/src/data/models/character_return_model.dart';
import 'package:rmapp/src/data/models/episode_model.dart';
import 'package:rmapp/src/domain/repositories/characters_repository.dart';

class CharactersRepositoryMock extends Mock implements CharactersRepository {}

const characterListMock = <CharacterModel>[
  CharacterModel(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    type: '',
    gender: 'Male',
    locationName: 'Citadel of Ricks',
    episodes:
        '[https://rickandmortyapi.com/api/episode/1, https://rickandmortyapi.com/api/episode/2]',
    image: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
  ),
  CharacterModel(
    id: 2,
    name: 'Morty Smith',
    status: 'Alive',
    species: 'Human',
    type: '',
    gender: 'Male',
    locationName: 'Earth (Replacement Dimension)',
    episodes:
        '[https://rickandmortyapi.com/api/episode/1, https://rickandmortyapi.com/api/episode/2]',
    image: 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
  ),
  CharacterModel(
    id: 3,
    name: 'Summer Smith',
    status: 'Alive',
    species: 'Human',
    type: '',
    gender: 'Female',
    locationName: 'Earth (Replacement Dimension)',
    episodes:
        '[https://rickandmortyapi.com/api/episode/6, https://rickandmortyapi.com/api/episode/7]',
    image: 'https://rickandmortyapi.com/api/character/avatar/3.jpeg',
  ),
  CharacterModel(
    id: 4,
    name: 'Beth Smith',
    status: 'Alive',
    species: 'Human',
    type: '',
    gender: 'Female',
    locationName: 'Earth (Replacement Dimension)',
    episodes:
        '[https://rickandmortyapi.com/api/episode/2, https://rickandmortyapi.com/api/episode/3]',
    image: 'https://rickandmortyapi.com/api/character/avatar/4.jpeg',
  ),
  CharacterModel(
    id: 5,
    name: 'Jerry Smith',
    status: 'Alive',
    species: 'Human',
    type: '',
    gender: 'Male',
    locationName: 'Earth (Replacement Dimension)',
    episodes:
        '[https://rickandmortyapi.com/api/episode/1, https://rickandmortyapi.com/api/episode/4]',
    image: 'https://rickandmortyapi.com/api/character/avatar/5.jpeg',
  ),
];

const resultCharacterReturnModel = CharacterReturnModel(
  info: InfoModel(
    count: 826,
    pages: 42,
    next: 'https://rickandmortyapi.com/api/character?page=2',
    prev: null,
  ),
  results: characterListMock,
);

const mockEpisodeList = [
  EpisodeModel(
    id: 1,
    name: 'Pilot',
    airDate: 'December 2, 2013',
    episode: 'S01E01',
    characters: [
      'https://rickandmortyapi.com/api/character/1',
      'https://rickandmortyapi.com/api/character/2',
    ],
    url: 'https://rickandmortyapi.com/api/episode/1',
    created: '2017-11-10T12:56:33.798Z',
  ),
  EpisodeModel(
    id: 2,
    name: 'Lawnmower Dog',
    airDate: 'December 9, 2013',
    episode: 'S01E02',
    characters: [
      'https://rickandmortyapi.com/api/character/1',
      'https://rickandmortyapi.com/api/character/3',
    ],
    url: 'https://rickandmortyapi.com/api/episode/2',
    created: '2017-11-10T12:56:33.916Z',
  ),
  EpisodeModel(
    id: 3,
    name: 'Anatomy Park',
    airDate: 'December 16, 2013',
    episode: 'S01E03',
    characters: [
      'https://rickandmortyapi.com/api/character/4',
      'https://rickandmortyapi.com/api/character/5',
    ],
    url: 'https://rickandmortyapi.com/api/episode/3',
    created: '2017-11-10T12:56:34.022Z',
  ),
  EpisodeModel(
    id: 4,
    name: 'M. Night Shaym-Aliens!',
    airDate: 'January 13, 2014',
    episode: 'S01E04',
    characters: [
      'https://rickandmortyapi.com/api/character/1',
      'https://rickandmortyapi.com/api/character/6',
    ],
    url: 'https://rickandmortyapi.com/api/episode/4',
    created: '2017-11-10T12:56:34.129Z',
  ),
  EpisodeModel(
    id: 5,
    name: 'Meeseeks and Destroy',
    airDate: 'January 20, 2014',
    episode: 'S01E05',
    characters: [
      'https://rickandmortyapi.com/api/character/1',
      'https://rickandmortyapi.com/api/character/7',
    ],
    url: 'https://rickandmortyapi.com/api/episode/5',
    created: '2017-11-10T12:56:34.236Z',
  ),
];

const customExceptionMock = CustomException(
  code: '123',
  messageError: 'err',
  customMessage: 'customMessage',
);

final episodesUrlsMock = [
  'https://rickandmortyapi.com/api/episode/1',
  'https://rickandmortyapi.com/api/episode/2',
  'https://rickandmortyapi.com/api/episode/3',
  'https://rickandmortyapi.com/api/episode/4',
  'https://rickandmortyapi.com/api/episode/5',
];

final charactersUrlsMock = [
  'https://rickandmortyapi.com/api/character/1',
  'https://rickandmortyapi.com/api/character/2',
  'https://rickandmortyapi.com/api/character/3',
  'https://rickandmortyapi.com/api/character/4',
  'https://rickandmortyapi.com/api/character/5',
];
