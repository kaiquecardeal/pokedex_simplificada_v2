import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/data/models/pokemon_list_item_model.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/data/data_sources/pokemon_list_data_source.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/viewmodels/pokemon_list_viewmodel.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/views/pokemon_list_view.dart';
import 'package:result_dart/result_dart.dart';

class MockPokemonListDataSource extends Mock implements PokemonListDataSource {}

void main() {
  late MockPokemonListDataSource mockDataSource;
  late List<PokemonListItemModel> pokemons;
  final getIt = GetIt.instance;

  setUp(() async {
    await getIt.reset();
    mockDataSource = MockPokemonListDataSource();
    pokemons = [
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
    getIt.registerSingleton<PokemonListDataSource>(mockDataSource);
    getIt.registerSingleton<PokemonListViewmodel>(
      PokemonListViewmodel(mockDataSource),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('PokemonListView exibe lista de pokémons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(MaterialApp(home: const PokemonListView()));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Bulbasaur'), findsOneWidget);
    expect(find.text('Ivysaur'), findsOneWidget);
  });
}
