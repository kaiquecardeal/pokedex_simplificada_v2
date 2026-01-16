import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex_simplificada_v2/core/network/dio_client.dart';
import 'package:pokedex_simplificada_v2/core/router/app_router.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_compare/viewmodels/pokemon_compare_viewmodel.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/data_source/pokemon_detail_data_source.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/viewmodels/pokemon_detail_viewmodel.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/data/data_sources/pokemon_list_data_source.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/viewmodels/pokemon_list_viewmodel.dart';

final getIt = GetIt.instance;

void init() {
  // Core - Network
  getIt.registerLazySingleton<Dio>(() => createDio());

  // Data Sources
  getIt.registerLazySingleton<PokemonListDataSource>(
    () => PokemonListDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<PokemonDetailDataSource>(
    () => PokemonDetailDataSource(getIt<Dio>()),
  );

  // ViewModels
  getIt.registerFactory<PokemonListViewmodel>(
    () => PokemonListViewmodel(getIt<PokemonListDataSource>()),
  );

  getIt.registerFactoryParam<PokemonDetailViewmodel, int, void>(
    (id, _) => PokemonDetailViewmodel(id, getIt<PokemonDetailDataSource>()),
  );

  getIt.registerFactory<PokemonCompareViewmodel>(
    () => PokemonCompareViewmodel(getIt<PokemonDetailDataSource>()),
  );

  getIt.registerLazySingleton<GoRouter>(() => appRouter);
}
