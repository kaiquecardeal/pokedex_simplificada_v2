import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/data/data_sources/pokemon_list_data_source.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/viewmodels/pokemon_list_viewmodel.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/views/pokemon_list_view.dart';
import 'package:result_dart/result_dart.dart';

class MockPokemonListDataSource extends Mock implements PokemonListDataSource {}

void main() {
  late MockPokemonListDataSource mockDataSource;
  final getIt = GetIt.instance;

  setUp(() async {
    await getIt.reset();
    mockDataSource = MockPokemonListDataSource();
    getIt.registerSingleton<PokemonListDataSource>(mockDataSource);
    getIt.registerSingleton<PokemonListViewmodel>(
      PokemonListViewmodel(mockDataSource),
    );
  });

  tearDown(() async {
    await getIt.reset();
  });

  testWidgets('Exibe loader inicial na lista', (tester) async {
    when(
      () => mockDataSource.fetchPokemons(
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer((_) async => const Success([]));
    await tester.pumpWidget(const MaterialApp(home: PokemonListView()));
    expect(
      find.byType(CircularProgressIndicator),
      findsNothing,
    ); // Loader é Lottie
    expect(find.textContaining('Carregando', findRichText: true), findsWidgets);
  });

  testWidgets('Exibe mensagem de erro', (tester) async {
    when(
      () => mockDataSource.fetchPokemons(
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer((_) async => Failure('Erro de rede' as Exception));
    await tester.pumpWidget(const MaterialApp(home: PokemonListView()));
    await tester.pumpAndSettle();
    expect(find.textContaining('Erro', findRichText: true), findsWidgets);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });

  testWidgets('Exibe mensagem de nenhum pokémon encontrado', (tester) async {
    when(
      () => mockDataSource.fetchPokemons(
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer((_) async => const Success([]));
    await tester.pumpWidget(const MaterialApp(home: PokemonListView()));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Nenhum Pokémon encontrado', findRichText: true),
      findsWidgets,
    );
  });
}
