import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/data_source/pokemon_detail_data_source.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/models/pokemon_detail_model.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class PokemonDetailViewmodel {
  final int pokemonId;
  final PokemonDetailDataSource _dataSource;

  late final Command0<PokemonDetailModel> fetchPokemonDetailCommand;

  PokemonDetailViewmodel(this.pokemonId, this._dataSource) {
    fetchPokemonDetailCommand = Command0(_fetchPokemon);
  }

  Future<Result<PokemonDetailModel>> _fetchPokemon() async {
    return await _dataSource.fetchPokemonById(pokemonId);
  }
}
