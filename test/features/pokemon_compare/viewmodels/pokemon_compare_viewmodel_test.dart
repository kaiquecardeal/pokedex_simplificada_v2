import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_compare/viewmodels/pokemon_compare_viewmodel.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/data_source/pokemon_detail_data_source.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/models/pokemon_detail_model.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class MockPokemonDetailDataSource extends Mock
    implements PokemonDetailDataSource {}

void main() {
  group('PokemonCompareViewmodel', () {
    late MockPokemonDetailDataSource mockDataSource;
    late PokemonCompareViewmodel viewModel;

    setUp(() {
      mockDataSource = MockPokemonDetailDataSource();
      viewModel = PokemonCompareViewmodel(mockDataSource);
    });

    test('fetchPokemonsCommand retorna detalhes de dois pokemons', () async {
      final p1 = PokemonDetailModel(
        id: 1,
        name: 'bulbasaur',
        height: 7,
        weight: 69,
        types: [],
        stats: [],
        sprites: Sprites(frontDefault: 'img1', frontShiny: 'img2'),
      );
      final p2 = PokemonDetailModel(
        id: 2,
        name: 'ivysaur',
        height: 10,
        weight: 130,
        types: [],
        stats: [],
        sprites: Sprites(frontDefault: 'img3', frontShiny: 'img4'),
      );
      when(
        () => mockDataSource.fetchPokemonByName('bulbasaur'),
      ).thenAnswer((_) async => Success(p1));
      when(
        () => mockDataSource.fetchPokemonByName('ivysaur'),
      ).thenAnswer((_) async => Success(p2));

      await viewModel.fetchPokemonsCommand.execute(('bulbasaur', 'ivysaur'));
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
      final tuple =
          (value as SuccessCommand).value
              as (PokemonDetailModel, PokemonDetailModel);
      expect(tuple.$1, p1);
      expect(tuple.$2, p2);
    });

    test('fetchPokemonsCommand retorna Failure se o primeiro falhar', () async {
      when(
        () => mockDataSource.fetchPokemonByName('bulbasaur'),
      ).thenAnswer((_) async => Failure(Exception('erro1')));
      when(() => mockDataSource.fetchPokemonByName('ivysaur')).thenAnswer(
        (_) async => Success(
          PokemonDetailModel(
            id: 2,
            name: 'ivysaur',
            height: 10,
            weight: 130,
            types: [],
            stats: [],
            sprites: Sprites(frontDefault: 'img3', frontShiny: 'img4'),
          ),
        ),
      );

      await viewModel.fetchPokemonsCommand.execute(('bulbasaur', 'ivysaur'));
      await Future.doWhile(() async {
        final value = viewModel.fetchPokemonsCommand.value;
        if (value is SuccessCommand || value is FailureCommand) {
          return false;
        }
        await Future.delayed(const Duration(milliseconds: 10));
        return true;
      });
      final value = viewModel.fetchPokemonsCommand.value;
      expect(value, isA<FailureCommand>());
      expect((value as FailureCommand).error, isA<Exception>());
    });

    test('fetchPokemonsCommand retorna Failure se o segundo falhar', () async {
      when(() => mockDataSource.fetchPokemonByName('bulbasaur')).thenAnswer(
        (_) async => Success(
          PokemonDetailModel(
            id: 1,
            name: 'bulbasaur',
            height: 7,
            weight: 69,
            types: [],
            stats: [],
            sprites: Sprites(frontDefault: 'img1', frontShiny: 'img2'),
          ),
        ),
      );
      when(
        () => mockDataSource.fetchPokemonByName('ivysaur'),
      ).thenAnswer((_) async => Failure(Exception('erro2')));

      await viewModel.fetchPokemonsCommand.execute(('bulbasaur', 'ivysaur'));
      await Future.doWhile(() async {
        final value = viewModel.fetchPokemonsCommand.value;
        if (value is SuccessCommand || value is FailureCommand) {
          return false;
        }
        await Future.delayed(const Duration(milliseconds: 10));
        return true;
      });
      final value = viewModel.fetchPokemonsCommand.value;
      expect(value, isA<FailureCommand>());
      expect((value as FailureCommand).error, isA<Exception>());
    });
  });
}
