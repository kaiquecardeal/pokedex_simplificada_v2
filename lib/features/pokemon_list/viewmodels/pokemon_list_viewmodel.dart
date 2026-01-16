import 'dart:async';

import 'package:pokedex_simplificada_v2/features/pokemon_list/data/data_sources/pokemon_list_data_source.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/data/models/pokemon_list_item_model.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class PokemonListViewmodel {
  final PokemonListDataSource _dataSource;
  final _pokemonController =
      StreamController<List<PokemonListItemModel>>.broadcast();
  Stream<List<PokemonListItemModel>> get pokemonsStream =>
      _pokemonController.stream;

  late final Command0<List<PokemonListItemModel>> fetchPokemonsCommand;
  late final Command1<List<PokemonListItemModel>, String> searchPokemonsCommand;

  final List<PokemonListItemModel> _pokemons = [];
  List<PokemonListItemModel> get pokemons => _pokemons;

  int _offset = 0;
  final int _limit = 20;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  PokemonListViewmodel(this._dataSource) {
    fetchPokemonsCommand = Command0(_fetchPokemons);
    searchPokemonsCommand = Command1(_searchPokemons);
  }

  void _updatePokemons() {
    _pokemonController.add(_pokemons);
  }

  Future<Result<List<PokemonListItemModel>>> _fetchPokemons() async {
    final result = await _dataSource.fetchPokemons(
      limit: _limit,
      offset: _offset,
    );

    return result.fold(
      (pokemons) {
        // Adiciona apenas pokémons que ainda não estão na lista
        final existingIds = _pokemons.map((p) => p.id).toSet();
        final newPokemons = pokemons
            .where((p) => !existingIds.contains(p.id))
            .toList();
        _pokemons.addAll(newPokemons);
        _updatePokemons();
        _offset += _limit;
        _hasMore = pokemons.length == _limit;
        return Success(_pokemons);
      },
      (error) {
        return Failure(error);
      },
    );
  }

  Future<Result<List<PokemonListItemModel>>> _searchPokemons(
    String query,
  ) async {
    if (query.isEmpty) return Success(_pokemons);
    final byName = await _dataSource.fetchPokemonByName(query);
    if (byName.isSuccess()) return Success([byName.getOrThrow()]);
    final byType = await _dataSource.fetchPokemonsByType(query);
    return byType;
  }

  void reset() {
    _pokemons.clear();
    _offset = 0;
    _hasMore = true;
  }

  void dispose() {
    _pokemonController.close();
  }
}
