import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/data_source/pokemon_detail_data_source.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/models/pokemon_detail_model.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/viewmodels/pokemon_detail_viewmodel.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class MockPokemonDetailDataSource extends Mock
    implements PokemonDetailDataSource {}

void main() {
  group('PokemonDetailViewmodel', () {
    late MockPokemonDetailDataSource mockDataSource;
    late PokemonDetailViewmodel viewModel;

    setUp(() {
      mockDataSource = MockPokemonDetailDataSource();
      viewModel = PokemonDetailViewmodel(1, mockDataSource);
    });

    test('fetchPokemonDetailCommand retorna detalhes do pokemon', () async {
      final detail = PokemonDetailModel(
        id: 1,
        name: 'bulbasaur',
        height: 7,
        weight: 69,
        types: [],
        stats: [],
        sprites: Sprites(frontDefault: 'img1', frontShiny: 'img2'),
      );
      when(
        () => mockDataSource.fetchPokemonById(1),
      ).thenAnswer((_) async => Success(detail));

      await viewModel.fetchPokemonDetailCommand.execute();
      await Future.doWhile(() async {
        final value = viewModel.fetchPokemonDetailCommand.value;
        if (value is SuccessCommand || value is FailureCommand) {
          return false;
        }
        await Future.delayed(const Duration(milliseconds: 10));
        return true;
      });
      final value = viewModel.fetchPokemonDetailCommand.value;
      expect(value, isA<SuccessCommand>());
      expect((value as SuccessCommand).value, detail);
    });

    test('fetchPokemonDetailCommand retorna Failure em erro', () async {
      when(
        () => mockDataSource.fetchPokemonById(1),
      ).thenAnswer((_) async => Failure(Exception('erro')));

      await viewModel.fetchPokemonDetailCommand.execute();
      await Future.doWhile(() async {
        final value = viewModel.fetchPokemonDetailCommand.value;
        if (value is SuccessCommand || value is FailureCommand) {
          return false;
        }
        await Future.delayed(const Duration(milliseconds: 10));
        return true;
      });
      final value = viewModel.fetchPokemonDetailCommand.value;
      expect(value, isA<FailureCommand>());
      expect((value as FailureCommand).error, isA<Exception>());
    });
  });
}
