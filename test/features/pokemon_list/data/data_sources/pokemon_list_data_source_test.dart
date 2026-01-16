// ignore_for_file: unused_element
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/data/data_sources/pokemon_list_data_source.dart';

class MockDio extends Mock implements Dio {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  group('PokemonListDataSource', () {
    late MockDio mockDio;
    late PokemonListDataSource dataSource;

    setUp(() {
      mockDio = MockDio();
      dataSource = PokemonListDataSource(mockDio);
    });

    test('fetchPokemons retorna lista de pokemons', () async {
      final responseData = {
        'results': [
          {'name': 'bulbasaur', 'url': 'https://pokeapi.co/api/v2/pokemon/1/'},
        ],
      };
      final detailData = {
        'types': [
          {
            'type': {'name': 'grass'},
          },
        ],
      };
      when(
        () => mockDio.get(
          '/pokemon',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: responseData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/pokemon'),
        ),
      );
      when(() => mockDio.get('/pokemon/1')).thenAnswer(
        (_) async => Response(
          data: detailData,
          statusCode: 200,
          requestOptions: RequestOptions(path: '/pokemon/1'),
        ),
      );

      final result = await dataSource.fetchPokemons(limit: 1, offset: 0);
      expect(result.isSuccess(), true);
      final pokemons = result.getOrNull();
      expect(pokemons, isNotNull);
      expect(pokemons!.length, 1);
      expect(pokemons[0].name, 'bulbasaur');
      expect(pokemons[0].types, ['grass']);
    });

    test('fetchPokemons retorna Failure em erro de rede', () async {
      when(
        () => mockDio.get(
          '/pokemon',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/pokemon'),
          error: 'Network error',
        ),
      );
      final result = await dataSource.fetchPokemons(limit: 1, offset: 0);
      expect(result.isError(), true);
      expect(result.exceptionOrNull(), isA<Exception>());
    });
  });
}
