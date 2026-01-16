import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/data_source/pokemon_detail_data_source.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/models/pokemon_detail_model.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/viewmodels/pokemon_detail_viewmodel.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/views/pokemon_detail_view.dart';
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
    getIt.registerFactoryParam<PokemonDetailViewmodel, int, void>((id, _) {
      final vm = PokemonDetailViewmodel(id, mockDataSource);
      // Mocka o stream para emitir valor imediatamente
      return vm;
    });
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('PokemonDetailView exibe detalhes do pokémon', (
    WidgetTester tester,
  ) async {
    final detail = PokemonDetailModel(
      id: 1,
      name: 'bulbasaur',
      height: 7,
      weight: 69,
      types: [
        TypeSlot(
          slot: 1,
          type: Type(name: 'grass', url: ''),
        ),
        TypeSlot(
          slot: 2,
          type: Type(name: 'poison', url: ''),
        ),
      ],
      stats: [],
      sprites: Sprites(frontDefault: 'img1', frontShiny: 'img2'),
    );
    when(
      () => mockDataSource.fetchPokemonById(1),
    ).thenAnswer((_) async => Success(detail));

    await tester.pumpWidget(MaterialApp(home: PokemonDetailView(id: 1)));
    // Executa o comando manualmente para simular carregamento
    final vm = getIt<PokemonDetailViewmodel>(param1: 1);
    await vm.fetchPokemonDetailCommand.execute();
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      find.textContaining('Bulbasaur', findRichText: true),
      findsAtLeastNWidgets(1),
    );
    expect(find.textContaining('Altura', findRichText: true), findsOneWidget);
    expect(find.textContaining('Peso', findRichText: true), findsOneWidget);
    expect(find.textContaining('GRASS', findRichText: true), findsOneWidget);
    expect(find.textContaining('POISON', findRichText: true), findsOneWidget);
  });
}
