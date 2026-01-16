import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_compare/views/pokemon_compare_view.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_compare/viewmodels/pokemon_compare_viewmodel.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/data_source/pokemon_detail_data_source.dart';
import 'package:result_dart/result_dart.dart';

class MockPokemonDetailDataSource extends Mock
    implements PokemonDetailDataSource {}

void main() {
  late MockPokemonDetailDataSource mockDataSource;
  final getIt = GetIt.instance;

  setUp(() async {
    await getIt.reset();
    mockDataSource = MockPokemonDetailDataSource();
    getIt.registerSingleton<PokemonDetailDataSource>(mockDataSource);
    getIt.registerFactory<PokemonCompareViewmodel>(() {
      final vm = PokemonCompareViewmodel(mockDataSource);
      return vm;
    });
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('Exibe mensagem de erro ao comparar', (tester) async {
    when(
      () => mockDataSource.fetchPokemonByName(any()),
    ).thenAnswer((_) async => Failure(Exception('Erro de rede')));
    await tester.pumpWidget(
      const MaterialApp(
        home: PokemonCompareView(pokemon1: 'bulbasaur', pokemon2: 'charmander'),
      ),
    );
    final vm = getIt<PokemonCompareViewmodel>();
    await vm.fetchPokemonsCommand.execute(('bulbasaur', 'charmander'));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('Erro', findRichText: true), findsWidgets);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });
}
