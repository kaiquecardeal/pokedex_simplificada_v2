import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_simplificada_v2/app.dart';
import 'package:pokedex_simplificada_v2/core/di/dependency_injector.dart' as di;
import 'package:pokedex_simplificada_v2/features/pokemon_list/data/data_sources/pokemon_list_data_source.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/data/models/pokemon_list_item_model.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/data_source/pokemon_detail_data_source.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/models/pokemon_detail_model.dart';
import 'package:result_dart/result_dart.dart';

class MockPokemonListDataSource extends Mock implements PokemonListDataSource {}

class MockPokemonDetailDataSource extends Mock
    implements PokemonDetailDataSource {}

void main() {
  final getIt = GetIt.instance;
  late MockPokemonListDataSource mockListDataSource;
  late MockPokemonDetailDataSource mockDetailDataSource;

  setUpAll(() async {
    await getIt.reset();
    di.init();
    mockListDataSource = MockPokemonListDataSource();
    mockDetailDataSource = MockPokemonDetailDataSource();
    getIt.unregister<PokemonListDataSource>();
    getIt.unregister<PokemonDetailDataSource>();
    getIt.registerSingleton<PokemonListDataSource>(mockListDataSource);
    getIt.registerSingleton<PokemonDetailDataSource>(mockDetailDataSource);
  });

  tearDownAll(() async {
    await getIt.reset();
  });

  testWidgets('Navegação principal exibe as telas corretas', (tester) async {
    // Mock lista
    when(
      () => mockListDataSource.fetchPokemons(
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer(
      (_) async => Success([
        PokemonListItemModel(id: 1, name: 'bulbasaur', url: ''),
        PokemonListItemModel(id: 4, name: 'charmander', url: ''),
      ]),
    );
    // Mock detalhe
    when(() => mockDetailDataSource.fetchPokemonById(1)).thenAnswer(
      (_) async => Success(
        PokemonDetailModel(
          id: 1,
          name: 'bulbasaur',
          height: 7,
          weight: 69,
          types: [
            TypeSlot(
              slot: 1,
              type: Type(name: 'grass', url: ''),
            ),
          ],
          stats: [],
          sprites: Sprites(frontDefault: '', frontShiny: ''),
        ),
      ),
    );
    when(() => mockDetailDataSource.fetchPokemonByName('bulbasaur')).thenAnswer(
      (_) async => Success(
        PokemonDetailModel(
          id: 1,
          name: 'bulbasaur',
          height: 7,
          weight: 69,
          types: [
            TypeSlot(
              slot: 1,
              type: Type(name: 'grass', url: ''),
            ),
          ],
          stats: [],
          sprites: Sprites(frontDefault: '', frontShiny: ''),
        ),
      ),
    );
    when(
      () => mockDetailDataSource.fetchPokemonByName('charmander'),
    ).thenAnswer(
      (_) async => Success(
        PokemonDetailModel(
          id: 4,
          name: 'charmander',
          height: 6,
          weight: 85,
          types: [
            TypeSlot(
              slot: 1,
              type: Type(name: 'fire', url: ''),
            ),
          ],
          stats: [],
          sprites: Sprites(frontDefault: '', frontShiny: ''),
        ),
      ),
    );

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 1));

    // Deve exibir a lista
    expect(
      find.textContaining('Bulbasaur', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Charmander', findRichText: true),
      findsOneWidget,
    );

    // Navega para detalhe
    await tester.tap(find.textContaining('Bulbasaur', findRichText: true));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Altura'), findsOneWidget);
    expect(find.text('GRASS'), findsOneWidget);

    // Volta para a lista (tap no botão de voltar da AppBar)
    await tester.tap(find.byIcon(Icons.home));
    await tester.pump(const Duration(seconds: 1));
    // Tap no item de índice 1 do BottomNavigationBar (Comparar)
    final bottomNavBar = find.byType(BottomNavigationBar);
    expect(bottomNavBar, findsOneWidget);
    await tester.tap(
      find
          .descendant(of: bottomNavBar, matching: find.byType(InkResponse))
          .at(1),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    final textFields = find.byType(TextField);
    print('TextFields encontrados: {textFields.evaluate().length}');
    expect(textFields, findsAtLeastNWidgets(2));
    await tester.enterText(textFields.at(0), 'bulbasaur');
    await tester.enterText(textFields.at(1), 'charmander');
    await tester.tap(find.byIcon(Icons.search));
    await tester.pump(const Duration(seconds: 1));
    expect(
      find.textContaining('Bulbasaur', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Charmander', findRichText: true),
      findsOneWidget,
    );
    expect(find.textContaining('GRASS', findRichText: true), findsOneWidget);
    expect(find.text('FIRE'), findsOneWidget);
  });
}
