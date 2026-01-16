import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_compare/views/pokemon_compare_view.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_compare/viewmodels/pokemon_compare_viewmodel.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/data_source/pokemon_detail_data_source.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/models/pokemon_detail_model.dart';
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
      // Mocka o stream para emitir valor imediatamente
      return vm;
    });
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('PokemonCompareView exibe dados de dois pokémon', (tester) async {
    final bulbasaur = PokemonDetailModel(
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
      sprites: Sprites(frontDefault: 'img1', frontShiny: 'img2'),
    );
    final charmander = PokemonDetailModel(
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
      sprites: Sprites(frontDefault: 'img3', frontShiny: 'img4'),
    );
    when(
      () => mockDataSource.fetchPokemonByName('bulbasaur'),
    ).thenAnswer((_) async => Success(bulbasaur));
    when(
      () => mockDataSource.fetchPokemonByName('charmander'),
    ).thenAnswer((_) async => Success(charmander));

    await tester.pumpWidget(
      MaterialApp(
        home: PokemonCompareView(pokemon1: 'bulbasaur', pokemon2: 'charmander'),
      ),
    );
    // Executa o comando manualmente para simular carregamento
    final vm = GetIt.instance<PokemonCompareViewmodel>();
    await vm.fetchPokemonsCommand.execute(('bulbasaur', 'charmander'));
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      find.textContaining('Bulbasaur', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Charmander', findRichText: true),
      findsOneWidget,
    );
    expect(find.textContaining('GRASS', findRichText: true), findsOneWidget);
    expect(find.textContaining('FIRE', findRichText: true), findsOneWidget);
  });
}
