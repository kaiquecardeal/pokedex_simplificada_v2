# Copilot Instructions - Pokedex Simplificada v2

## Project Overview
A Flutter Pokedex application consuming the [PokeAPI](https://pokeapi.co/). The project applies **MVVM architecture** to learn common Flutter ecosystem libraries.

## Features
1. **Listagem de Pokémon**: Lista com nome, imagem, número na Pokedex e tipos
2. **Detalhes do Pokémon**: Tela de detalhes via route params/extras
3. **Comparação de Pokémon**: Comparar dois Pokémon lado a lado (via query params)
  - Para visualizar a comparação, acesse a rota `/compare?pokemon1=pikachu&pokemon2=charizard` (ou substitua pelos nomes desejados). Ambos os parâmetros são obrigatórios na URL.
4. **Bottom Navigation**: Navegação usando `ShellRoute` do go_router

## Architecture (MVVM)
```
lib/
├── main.dart                    # Entry point com DI (get_it)
├── app.dart                     # MyApp widget com MaterialApp.router
├── core/
│   ├── di/
│   │   └── dependency_injector.dart  # Configuração do get_it
│   ├── network/
│   │   └── dio_client.dart           # Cliente Dio configurado
│   ├── router/
│   │   └── app_router.dart           # Configuração do GoRouter
│   └── widgets/
│       └── command_builder.dart      # Widget utilitário para Commands
└── features/
    ├── pokemon_list/
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── pokemon_list_item_model.dart
    │   │   └── data_sources/
    │   │       └── pokemon_list_data_source.dart
    │   ├── viewmodels/
    │   │   └── pokemon_list_viewmodel.dart
    │   └── views/
    │       └── pokemon_list_view.dart
    ├── pokemon_detail/
    │   ├── data/
    │   │   ├── models/
    │   │   │   └── pokemon_detail_model.dart
    │   │   └── data_source/
    │   │       └── pokemon_detail_data_source.dart
    │   ├── viewmodels/
    │   │   └── pokemon_detail_viewmodel.dart
    │   └── views/
    │       └── pokemon_detail_view.dart
    └── pokemon_compare/
        ├── viewmodels/
        │   └── pokemon_compare_viewmodel.dart
        └── views/
            └── pokemon_compare_view.dart
```

## Required Libraries
| Package | Purpose |
|---------|---------|
| `dio` | Requisições HTTP |
| `json_annotation` | Anotações para serialização |
| `json_serializable` | Serialização de models (dev) |
| `go_router` | Navegação (inclui ShellRoute) |
| `get_it` | Injeção de dependência |
| `result_dart` | Tratamento de erros funcional (Success/Failure) |
| `result_command` | Gerenciamento de estado com Commands |
| `build_runner` | Geração de código (dev) |

## Key Patterns

### DI (get_it)
Inicializar em `main.dart` antes de `runApp()`:
```dart
import 'package:flutter/material.dart';
import 'package:pokedex_simplificada_v2/app.dart';
import 'package:pokedex_simplificada_v2/core/di/dependency_injector.dart' as di;

### Command Pattern (result_command)
```dart
// ViewModel
class PokemonListViewmodel {
  late final Command0<List<PokemonListItemModel>> fetchPokemonsCommand;

  PokemonListViewmodel(this._dataSource) {
    fetchPokemonsCommand = Command0(_fetchPokemons);
  }

  Future<Result<List<PokemonListItemModel>>> _fetchPokemons() async {
    // retorna Success ou Failure
  }
}

// Recomenda-se usar CommandBuilder em todas as views principais:

// 1. Lista de Pokémon
CommandBuilder<List<PokemonListItemModel>>(
  command: viewModel.fetchPokemonsCommand,
  idle: const Center(child: Text('Carregando...')),
  loading: const Center(child: CircularProgressIndicator()),
  success: (context, pokemons) => ListView.builder(
    // ...
  ),
  error: (context, error) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Erro: $error'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: viewModel.fetchPokemonsCommand.execute,
          child: const Text('Tentar novamente'),
        ),
      ],
    ),
  ),
)

// 2. Detalhe do Pokémon
CommandBuilder<PokemonDetailModel>(
  command: viewModel.fetchPokemonDetailCommand,
  idle: const Center(child: Text('Carregando...')),
  loading: const Center(child: CircularProgressIndicator()),
  success: (context, pokemon) => _PokemonDetailContent(pokemon: pokemon),
  error: (context, error) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Erro: $error'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: viewModel.fetchPokemonDetailCommand.execute,
          child: const Text('Tentar novamente'),
        ),
      ],
    ),
  ),
)

// 3. Comparação de Pokémon
CommandBuilder<(PokemonDetailModel, PokemonDetailModel)>(
  command: viewModel.fetchPokemonsCommand,
  idle: const Center(child: Text('Carregando...')),
  loading: const Center(child: CircularProgressIndicator()),
  success: (context, value) => _CompareContent(
    pokemon1: value.$1,
    pokemon2: value.$2,
  ),
  error: (context, error) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Erro: $error'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: viewModel.fetchPokemonsCommand.execute,
          child: const Text('Tentar novamente'),
        ),
      ],
    ),
  ),
)
```
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: command,
      builder: (context, _) {
        final value = command.value;
        if (value is IdleCommand) {
          return idle ?? const SizedBox.shrink();
        }
        if (value is RunningCommand) {
          return loading ?? const Center(child: CircularProgressIndicator());
        }
        if (value is SuccessCommand<T>) {
          return success(context, value.value);
        }
        if (value is FailureCommand<T>) {
          if (error != null) {
            return error!(context, value.error);
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Erro: {value.error}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: command is Command0<T> || command is Command1<T, dynamic>
                      ? () => (command as dynamic).execute()
                      : null,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
```

### Navigation (go_router)
```dart
final goRouter = GoRouter(
  initialLocation: '/list',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/list', builder: (_, __) => const PokemonListView()),
        GoRoute(path: '/compare', builder: (_, state) {
          final pokemon1 = state.uri.queryParameters['pokemon1'];
          final pokemon2 = state.uri.queryParameters['pokemon2'];
          return PokemonCompareView(pokemon1: pokemon1, pokemon2: pokemon2);
        }),
      ],
    ),
    GoRoute(
      path: '/pokemon/:id',
      builder: (_, state) => PokemonDetailView(
        id: int.parse(state.pathParameters['id']!),
      ),
    ),
  ],
)

### Freezed Data Classes

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main.freezed.dart';
part 'main.g.dart';

@freezed
abstract class MyClass with _$MyClass {
  factory MyClass({String? a, int? b}) = _MyClass;
}

@freezed
sealed class Union with _$Union {
  const factory Union(int value) = Data;
  const factory Union.loading() = Loading;
  const factory Union.error([String? message]) = ErrorDetails;
  const factory Union.complex(int a, String b) = Complex;

  factory Union.fromJson(Map<String, Object?> json) => _$UnionFromJson(json);
}

@freezed
abstract class SharedProperty with _$SharedProperty {
  factory SharedProperty.person({String? name, int? age}) = SharedProperty0;

  factory SharedProperty.city({String? name, int? population}) =
      SharedProperty1;
}

void main() {
  final myClassexample = MyClass(a: '42', b: 42);

  // clone
  print(myClassexample.copyWith(a: null)); // MyClass(a: null, b: 42)
  print(myClassexample.copyWith()); // MyClass(a: '42', b: 42)

  // ------------------

  // == override
  print(MyClass(a: '42', b: 42) == MyClass(a: '42', b: 42)); // true
  print(MyClass(a: '42', b: 42) == MyClass()); // false

  // ------------------

  // destructuring pattern-matching
  const unionExample = Union(42);
  print(switch (unionExample) {
    Data value => '$value',
    Loading _ => 'loading',
    ErrorDetails(:final message) => 'Error: $message',
    Complex(:final a, :final b) => 'complex $a $b',
  }); // 42

  print(switch (unionExample) {
    Loading _ => 'loading',
    // voluntarily didn't handle error/complex cases
    _ => 42,
  }); // 42

  // ------------------

  // non-destructuring pattern-matching
  // works the same as `when`, but the callback is slightly different
  print(switch (unionExample) {
    Data value => '$value',
    Loading _ => 'loading',
    ErrorDetails(:final message) => 'Error: $message',
    Complex(:final a, :final b) => 'complex $a $b',
  }); // 42

  print(switch (unionExample) {
    ErrorDetails(:final message) => message,
    // voluntarily didn't handle error/complex cases
    _ => 'fallthrough',
  }); // fallthrough

  // ------------------

  // nice toString
  print(const Union(42)); // Union(value: 42)
  print(const Union.loading()); // Union.loading()
  print(
    const Union.error('Failed to fetch'),
  ); // Union.error(message: Failed to fetch)

  // ------------------

  // shared properties between union possibilities
  var example = SharedProperty.person(name: 'Remi', age: 24);
  // OK, `name` is shared between both .person and .city constructor
  print(example.name); // Remi
  example = SharedProperty.city(name: 'London', population: 8900000);
  print(example.name); // London

  // COMPILE ERROR
  // print(example.age);
  // print(example.population);
}

### Json Serializable

import 'package:json_annotation/json_annotation.dart';

part 'example.g.dart';

@JsonSerializable()
class Person {
  /// The generated code assumes these values exist in JSON.
  final String firstName, lastName;

  /// The generated code below handles if the corresponding JSON value doesn't
  /// exist or is empty.
  final DateTime? dateOfBirth;

  Person({required this.firstName, required this.lastName, this.dateOfBirth});

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}





```

## Development Commands
```bash
# Run the app
flutter run

# Generate code (json_serializable)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
dart run build_runner watch --delete-conflicting-outputs

# Run tests
flutter test

# Analyze code
flutter analyze
```

## Conventions
- **Linting**: `flutter_lints` - seguir `analysis_options.yaml`
- **Naming**: snake_case para arquivos, PascalCase para classes
- **Models**: Sufixo `Model` (ex: `PokemonModel`)
- **ViewModels**: Sufixo `Viewmodel` (ex: `PokemonListViewmodel`)
- **Views**: Sufixo `View` (ex: `PokemonListView`)
- **Data Sources**: Sufixo `DataSource` (ex: `PokemonListDataSource`)


## Status Atual do Projeto (2026)

### O que está COMPLETO:

### Pontos FALTANTES para excelência máxima:

### Recomendações para Excelência
1. Implementar autocomplete/sugestão na busca de pokémons.
2. (removido)
3. Utilizar cache de imagens para performance (CachedNetworkImage).
4. Adicionar botão de voltar ao topo na lista.
5. Enriquecer o README com instruções detalhadas, arquitetura e exemplos de uso/teste.
6. Garantir navegação por teclado e acessibilidade total.
7. Revisar contraste de chips e elementos no dark mode.

Sempre que adicionar novos recursos, criar os testes correspondentes (unitário, widget e/ou integração) para manter a cobertura.

---

## Quem desenvolveu

- Projeto desenvolvido por [Kaique Cardeal](https://github.com/kaiquecardeal) em 2026.
	- Contato: kaiquecardeal@outlook.com
