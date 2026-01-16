import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_list/data/models/pokemon_list_item_model.dart';

void main() {
  group('PokemonListItemModel', () {
    test('Construtor e propriedades básicas', () {
      final model = PokemonListItemModel(
        id: 25,
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon/25/',
      );
      expect(model.id, 25);
      expect(model.name, 'pikachu');
      expect(model.url, contains('25'));
      expect(model.imageUrl, contains('25.png'));
    });

    test('fromJson e toJson', () {
      final json = {
        'id': 1,
        'name': 'bulbasaur',
        'url': 'https://pokeapi.co/api/v2/pokemon/1/',
        'types': [],
      };
      final model = PokemonListItemModel.fromJson(json);
      expect(model.id, 1);
      expect(model.name, 'bulbasaur');
      expect(model.url, contains('1'));
      expect(model.imageUrl, contains('1.png'));
      final modelJson = model.toJson();
      // Deve conter todos os campos do json original
      for (final entry in json.entries) {
        expect(modelJson[entry.key], entry.value);
      }
      // Teste de isFavorite removido
    });

    test('equality e hashCode', () {
      final m1 = PokemonListItemModel(
        id: 7,
        name: 'squirtle',
        url: 'https://pokeapi.co/api/v2/pokemon/7/',
        types: [],
      );
      final m2 = PokemonListItemModel(
        id: 7,
        name: 'squirtle',
        url: 'https://pokeapi.co/api/v2/pokemon/7/',
        types: [],
      );
      expect(m1, m2);
      expect(m1.hashCode, m2.hashCode);
    });
  });

  test('fromApi factory', () {
    final pokeApiJson = {
      'name': 'charmander',
      'url': 'https://pokeapi.co/api/v2/pokemon/4/',
    };
    final model = PokemonListItemModel.fromApi(pokeApiJson);
    expect(model.id, 4);
    expect(model.name, 'charmander');
    expect(model.url, pokeApiJson['url']);
    expect(model.imageUrl, contains('4.png'));
  });

  test('imageUrl padrão', () {
    final model = PokemonListItemModel(
      id: 10,
      name: 'caterpie',
      url: 'https://pokeapi.co/api/v2/pokemon/10/',
    );
    expect(model.imageUrl, contains('10.png'));
  });

  test('Construtor com types preenchido', () {
    final model = PokemonListItemModel(
      id: 6,
      name: 'charizard',
      url: 'https://pokeapi.co/api/v2/pokemon/6/',
      types: ['fire', 'flying'],
    );
    expect(model.types, ['fire', 'flying']);
  });

  test('Construtor com types vazio', () {
    final model = PokemonListItemModel(
      id: 1,
      name: 'bulbasaur',
      url: 'https://pokeapi.co/api/v2/pokemon/1/',
      types: [],
    );
    expect(model.types, isEmpty);
  });

  test('fromJson com types preenchido', () {
    final json = {
      'id': 3,
      'name': 'venusaur',
      'url': 'https://pokeapi.co/api/v2/pokemon/3/',
      'types': ['grass', 'poison'],
    };
    final model = PokemonListItemModel.fromJson(json);
    expect(model.types, ['grass', 'poison']);
  });

  test('toJson com types preenchido', () {
    final model = PokemonListItemModel(
      id: 9,
      name: 'blastoise',
      url: 'https://pokeapi.co/api/v2/pokemon/9/',
      types: ['water'],
    );
    final json = model.toJson();
    expect(json['types'], ['water']);
  });
}
