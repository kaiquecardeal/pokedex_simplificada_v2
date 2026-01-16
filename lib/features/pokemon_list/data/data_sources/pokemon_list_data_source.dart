import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/data/models/pokemon_list_item_model.dart';

class PokemonListDataSource {
  final Dio _dio;

  PokemonListDataSource(this._dio);

  Future<Result<List<PokemonListItemModel>>> fetchPokemons({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await _dio.get(
        '/pokemon',
        queryParameters: {
          'limit': limit.toString(),
          'offset': offset.toString(),
        },
      );
      final results = response.data['results'] as List? ?? <dynamic>[];
      final pokemons = await Future.wait(
        results.map((e) async {
          final base = e is Map<String, dynamic> ? e : Map<String, dynamic>.from(e as Map);
          final url = base['url'] as String? ?? '';
          final idFromUrl = int.tryParse(url.split('/').where((e) => e.isNotEmpty).last) ?? 0;
          try {
            final detailResp = await _dio.get('/pokemon/$idFromUrl');
            final typesList = detailResp.data['types'] as List? ?? <dynamic>[];
            final types = typesList
                .map((t) => t is Map && t['type'] is Map && t['type']['name'] != null ? t['type']['name'] as String : '')
                .where((t) => t.isNotEmpty)
                .toList();
            return PokemonListItemModel(
              id: idFromUrl,
              name: base['name'] as String? ?? '',
              url: url,
              types: types,
            );
          } catch (_) {
            return PokemonListItemModel(
              id: idFromUrl,
              name: base['name'] as String? ?? '',
              url: url,
              types: [],
            );
          }
        }),
      );
      return Success(pokemons);
    } on DioException catch (e) {
      return Failure(Exception('Erro de rede: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro inesperado: $e'));
    }
  }

  Future<Result<PokemonListItemModel>> fetchPokemonByName(String name) async {
    try {
      final response = await _dio.get('/pokemon/${name.toLowerCase()}');
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data as Map);
      final url = data['url'] as String? ?? '';
      final idFromUrl = int.tryParse(url.split('/').where((e) => e.isNotEmpty).last) ?? 0;
      final typesList = data['types'] as List? ?? <dynamic>[];
      final types = typesList
          .map((t) => t is Map && t['type'] is Map && t['type']['name'] != null ? t['type']['name'] as String : '')
          .where((t) => t.isNotEmpty)
          .toList();
      return Success(PokemonListItemModel(
        id: idFromUrl,
        name: data['name'] as String? ?? '',
        url: url,
        types: types,
      ));
    } catch (e) {
      return Failure(Exception('Erro ao buscar Pokémon: $e'));
    }
  }

  Future<Result<List<PokemonListItemModel>>> fetchPokemonsByType(String type) async {
    try {
      final response = await _dio.get('/type/${type.toLowerCase()}');
      final pokemonList = response.data['pokemon'] as List? ?? <dynamic>[];
      final pokemons = pokemonList.map((e) {
        final pokeData = e['pokemon'] is Map<String, dynamic>
            ? e['pokemon'] as Map<String, dynamic>
            : Map<String, dynamic>.from(e['pokemon'] as Map);
        final url = pokeData['url'] as String? ?? '';
        final idFromUrl = int.tryParse(url.split('/').where((e) => e.isNotEmpty).last) ?? 0;
        return PokemonListItemModel(
          id: idFromUrl,
          name: pokeData['name'] as String? ?? '',
          url: url,
          types: [],
        );
      }).toList();
      return Success(pokemons);
    } catch (e) {
      return Failure(Exception('Erro ao buscar Pokémons por tipo: $e'));
    }
  }
}