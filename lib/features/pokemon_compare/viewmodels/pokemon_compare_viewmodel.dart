import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/data_source/pokemon_detail_data_source.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/models/pokemon_detail_model.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';



class PokemonCompareViewmodel {
  final PokemonDetailDataSource _dataSource;

  late final Command1<
    (PokemonDetailModel, PokemonDetailModel),
    (String, String)
  >
  fetchPokemonsCommand;

  PokemonCompareViewmodel(this._dataSource) {
    fetchPokemonsCommand = Command1(_fetchPokemons);
  }

  Future<Result<(PokemonDetailModel, PokemonDetailModel)>> _fetchPokemons(
    (String, String) names,
  ) async {
    final (name1, name2) = names;

    final result = await Future.wait([
      _dataSource.fetchPokemonByName(name1),
      _dataSource.fetchPokemonByName(name2),
    ]);

    final result1 = result[0];
    final result2 = result[1];

    if (result1.isError()) {
      return Failure(result1.exceptionOrNull()!);
    } else if (result2.isError()) {
      return Failure(result2.exceptionOrNull()!);
    } else {
      return Success((result1.getOrThrow(), result2.getOrThrow()));
    }
  }
}
