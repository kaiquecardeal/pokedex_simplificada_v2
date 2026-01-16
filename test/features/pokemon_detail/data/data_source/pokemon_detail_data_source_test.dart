import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/data_source/pokemon_detail_data_source.dart';


class MockDio extends Mock implements Dio {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('PokemonDetailDataSource', () {
    late MockDio mockDio;
    late PokemonDetailDataSource dataSource;

    setUp(() {
      mockDio = MockDio();
      dataSource = PokemonDetailDataSource(mockDio);
    });

    test('fetchPokemonById retorna detalhes do pokemon', () async {
      final responseData = {
        'id': 1,
        'name': 'bulbasaur',
        'height': 7,
        'weight': 69,
        'types': [
          {
            'slot': 1,
            'type': {'name': 'grass', 'url': 'type-url'},
          },
        ],
        'stats': [
          {
            'base_stat': 45,
            'effort': 0,
            'stat': {'name': 'hp', 'url': 'stat-url'},
          },
        ],
        'sprites': {
          'front_default': 'url1',
          'front_shiny': 'url2',
          'other': {
            'official-artwork': {
              'front_default': 'url1',
              'front_shiny': 'url2',
            },
          },
        },
      };
      when(() => mockDio.get('/pokemon/1')).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/pokemon/1'),
        ),
      );
      final result = await dataSource.fetchPokemonById(1);
      expect(result.isSuccess(), true);
      final pokemon = result.getOrNull();
      expect(pokemon, isNotNull);
      expect(pokemon!.id, 1);
      expect(pokemon.name, 'bulbasaur');
      expect(pokemon.height, 7);
      expect(pokemon.weight, 69);
      expect(pokemon.types[0].type.name, 'grass');
      expect(pokemon.stats[0].baseStat, 45);
      expect(pokemon.sprites.imageUrl, 'url1');
      expect(pokemon.sprites.shinyUrl, 'url2');
    });

    test('fetchPokemonById retorna Failure em erro de rede', () async {
      when(() => mockDio.get('/pokemon/1')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/pokemon/1'),
          error: 'Network error',
        ),
      );
      final result = await dataSource.fetchPokemonById(1);
      expect(result.isError(), true);
      expect(result.exceptionOrNull(), isA<Exception>());
    });

    test('fetchPokemonByName retorna detalhes do pokemon', () async {
      final responseData = {
        'id': 25,
        'name': 'pikachu',
        'height': 4,
        'weight': 60,
        'types': [
          {
            'slot': 1,
            'type': {'name': 'electric', 'url': 'type-url'},
          },
        ],
        'stats': [
          {
            'base_stat': 35,
            'effort': 0,
            'stat': {'name': 'hp', 'url': 'stat-url'},
          },
        ],
        'sprites': {
          'front_default': 'urlPika',
          'front_shiny': 'urlPikaShiny',
          'other': {
            'official-artwork': {
              'front_default': 'urlPika',
              'front_shiny': 'urlPikaShiny',
            },
          },
        },
      };
      when(() => mockDio.get('/pokemon/pikachu')).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/pokemon/pikachu'),
        ),
      );
      final result = await dataSource.fetchPokemonByName('pikachu');
      expect(result.isSuccess(), true);
      final pokemon = result.getOrNull();
      expect(pokemon, isNotNull);
      expect(pokemon!.id, 25);
      expect(pokemon.name, 'pikachu');
      expect(pokemon.height, 4);
      expect(pokemon.weight, 60);
      expect(pokemon.types[0].type.name, 'electric');
      expect(pokemon.stats[0].baseStat, 35);
      expect(pokemon.sprites.imageUrl, 'urlPika');
      expect(pokemon.sprites.shinyUrl, 'urlPikaShiny');
    });

    test('fetchPokemonByName retorna Failure em erro de rede', () async {
      when(() => mockDio.get('/pokemon/pikachu')).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/pokemon/pikachu'),
          error: 'Network error',
        ),
      );
      final result = await dataSource.fetchPokemonByName('pikachu');
      expect(result.isError(), true);
      expect(result.exceptionOrNull(), isA<Exception>());
    });
  });
}
