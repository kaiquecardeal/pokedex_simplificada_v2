import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/data/data_sources/pokemon_list_data_source.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/data/models/pokemon_list_item_model.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/viewmodels/pokemon_list_viewmodel.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class MockPokemonListDataSource extends Mock implements PokemonListDataSource {}

void main() {
  group('PokemonListViewmodel', () {
    late MockPokemonListDataSource mockDataSource;
    late PokemonListViewmodel viewModel;

    setUp(() {
      mockDataSource = MockPokemonListDataSource();
      viewModel = PokemonListViewmodel(mockDataSource);
    });

    test('fetchPokemonsCommand retorna lista inicial', () async {
      final pokemons = [
        PokemonListItemModel(
          id: 1,
          name: 'bulbasaur',
          url: 'url1',
          types: ['grass'],
        ),
        PokemonListItemModel(
          id: 2,
          name: 'ivysaur',
          url: 'url2',
          types: ['grass', 'poison'],
        ),
      ];
      when(
        () => mockDataSource.fetchPokemons(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => Success(pokemons));

      await viewModel.fetchPokemonsCommand.execute();
      // Aguarda até o comando ser Success ou Failure
      await Future.doWhile(() async {
        final value = viewModel.fetchPokemonsCommand.value;
        if (value is SuccessCommand || value is FailureCommand) {
          return false;
        }
        await Future.delayed(const Duration(milliseconds: 10));
        return true;
      });
      final value = viewModel.fetchPokemonsCommand.value;
      expect(value, isA<SuccessCommand>());
      expect(viewModel.pokemons.length, 2);
      expect(viewModel.pokemons[0].name, 'bulbasaur');
      expect(viewModel.hasMore, false);
    });

    test('fetchPokemonsCommand adiciona novos pokemons sem duplicar', () async {
      final firstBatch = [
        PokemonListItemModel(
          id: 1,
          name: 'bulbasaur',
          url: 'url1',
          types: ['grass'],
        ),
      ];
      final secondBatch = [
        PokemonListItemModel(
          id: 2,
          name: 'ivysaur',
          url: 'url2',
          types: ['grass', 'poison'],
        ),
      ];
      when(
        () =>
            mockDataSource.fetchPokemons(limit: any(named: 'limit'), offset: 0),
      ).thenAnswer((_) async => Success(firstBatch));
      when(
        () => mockDataSource.fetchPokemons(
          limit: any(named: 'limit'),
          offset: 20,
        ),
      ).thenAnswer((_) async => Success(secondBatch));

      await viewModel.fetchPokemonsCommand.execute();
      await viewModel.fetchPokemonsCommand.execute();
      // Aguarda até o comando ser Success ou Failure
      await Future.doWhile(() async {
        final value = viewModel.fetchPokemonsCommand.value;
        print('Command value: ${value.runtimeType}');
        if (value is SuccessCommand || value is FailureCommand) {
          return false;
        }
        await Future.delayed(const Duration(milliseconds: 10));
        return true;
      });
      final value = viewModel.fetchPokemonsCommand.value;
      expect(value, isA<SuccessCommand>());
      expect(viewModel.pokemons.length, 2);
      expect(viewModel.pokemons[1].name, 'ivysaur');
    });

    test('fetchPokemonsCommand retorna Failure em erro', () async {
      when(
        () => mockDataSource.fetchPokemons(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => Failure(Exception('Erro de rede')));
      await viewModel.fetchPokemonsCommand.execute();
      // Aguarda até o comando ser Success ou Failure
      await Future.doWhile(() async {
        final value = viewModel.fetchPokemonsCommand.value;
        if (value is SuccessCommand<List<PokemonListItemModel>> ||
            value is FailureCommand<List<PokemonListItemModel>>) {
          return false;
        }
        await Future.delayed(const Duration(milliseconds: 10));
        return true;
      });
      final value = viewModel.fetchPokemonsCommand.value;
      expect(value, isA<FailureCommand<List<PokemonListItemModel>>>());
      expect(viewModel.pokemons, isEmpty);
    });

    test('reset limpa lista e offset', () async {
      final pokemons = [
        PokemonListItemModel(
          id: 1,
          name: 'bulbasaur',
          url: 'url1',
          types: ['grass'],
        ),
      ];
      when(
        () => mockDataSource.fetchPokemons(
          limit: any(named: 'limit'),
          offset: any(named: 'offset'),
        ),
      ).thenAnswer((_) async => Success(pokemons));
      await viewModel.fetchPokemonsCommand.execute();
      viewModel.reset();
      expect(viewModel.pokemons, isEmpty);
      expect(viewModel.hasMore, true);
    });
  });
}
