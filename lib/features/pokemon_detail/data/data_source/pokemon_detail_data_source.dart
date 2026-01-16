import 'package:dio/dio.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/models/pokemon_detail_model.dart';
import 'package:result_dart/result_dart.dart';

class PokemonDetailDataSource {
  final Dio _dio;

  PokemonDetailDataSource(this._dio);

  Future<Result<PokemonDetailModel>> fetchPokemonById(int id) async {
    try {
      final response = await _dio.get('/pokemon/$id');
      final pokemon = PokemonDetailModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Success(pokemon);
    } on DioException catch (e) {
      return Failure(Exception('Erro de rede: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro inesperado: $e'));
    }
  }

  Future<Result<PokemonDetailModel>> fetchPokemonByName(String name) async {
    try {
      final response = await _dio.get('/pokemon/${name.toLowerCase()}');
      final pokemon = PokemonDetailModel.fromJson(
        response.data as Map<String, dynamic>,
      );
      return Success(pokemon);
    } on DioException catch (e) {
      return Failure(Exception('Erro de rede: ${e.message}'));
    } catch (e) {
      return Failure(Exception('Erro inesperado: $e'));
    }
  }
}
