import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_simplificada_v2/features/pokemon_detail/data/models/pokemon_detail_model.dart';

void main() {
  group('PokemonDetailModel', () {
    test('Construtor e propriedades básicas', () {
      final model = PokemonDetailModel(
        id: 1,
        name: 'bulbasaur',
        height: 7,
        weight: 69,
        types: [
          TypeSlot(
            slot: 1,
            type: Type(name: 'grass', url: 'type-url'),
          ),
          TypeSlot(
            slot: 2,
            type: Type(name: 'poison', url: 'type-url'),
          ),
        ],
        stats: [
          StatSlot(
            baseStat: 45,
            effort: 0,
            stat: Stat(name: 'hp', url: 'stat-url'),
          ),
        ],
        sprites: Sprites(
          frontDefault: 'url1',
          frontShiny: 'url2',
          other: OtherSprites(
            officialArtwork: OfficialArtwork(
              frontDefault: 'url1',
              frontShiny: 'url2',
            ),
          ),
        ),
      );
      expect(model.id, 1);
      expect(model.name, 'bulbasaur');
      expect(model.height, 7);
      expect(model.weight, 69);
      expect(model.types.length, 2);
      expect(model.stats.length, 1);
      expect(model.sprites.imageUrl, 'url1');
      expect(model.sprites.shinyUrl, 'url2');
    });

    test('fromJson e toJson', () {
      final json = {
        'id': 2,
        'name': 'ivysaur',
        'height': 10,
        'weight': 130,
        'types': [
          {
            'slot': 1,
            'type': {'name': 'grass', 'url': 'type-url'},
          },
          {
            'slot': 2,
            'type': {'name': 'poison', 'url': 'type-url'},
          },
        ],
        'stats': [
          {
            'base_stat': 60,
            'effort': 0,
            'stat': {'name': 'hp', 'url': 'stat-url'},
          },
        ],
        'sprites': {
          'front_default': 'img2',
          'front_shiny': 'shiny2',
          'other': {
            'official-artwork': {
              'front_default': 'img2',
              'front_shiny': 'shiny2',
            },
          },
        },
      };
      final model = PokemonDetailModel.fromJson(json);
      expect(model.id, 2);
      expect(model.name, 'ivysaur');
      expect(model.height, 10);
      expect(model.weight, 130);
      expect(model.types[0].type.name, 'grass');
      expect(model.stats[0].baseStat, 60);
      expect(model.sprites.imageUrl, 'img2');
      final modelJson = model.toJson();
      // Checa apenas os campos principais, ignora diferenças de snake/camel case
      expect(modelJson['id'], json['id']);
      expect(modelJson['name'], json['name']);
      expect(modelJson['height'], json['height']);
      expect(modelJson['weight'], json['weight']);
    });

    test('Construtor com listas vazias', () {
      final model = PokemonDetailModel(
        id: 4,
        name: 'charmander',
        height: 6,
        weight: 85,
        types: [],
        stats: [],
        sprites: Sprites(
          frontDefault: 'img4',
          frontShiny: 'shiny4',
          other: OtherSprites(
            officialArtwork: OfficialArtwork(
              frontDefault: 'img4',
              frontShiny: 'shiny4',
            ),
          ),
        ),
      );
      expect(model.types, isEmpty);
      expect(model.stats, isEmpty);
    });
  });

  group('TypeSlot', () {
    test('fromJson e toJson', () {
      final json = {
        'slot': 1,
        'type': {'name': 'fire', 'url': 'type-url'},
      };
      final model = TypeSlot.fromJson(json);
      expect(model.slot, 1);
      expect(model.type.name, 'fire');
      final modelJson = model.toJson();
      expect(modelJson['slot'], json['slot']);
      expect(model.type.name, (json['type'] as Map<String, dynamic>)['name']);
      expect(model.type.url, (json['type'] as Map<String, dynamic>)['url']);
    });
  });

  group('Type', () {
    test('fromJson e toJson', () {
      final json = {'name': 'water', 'url': 'type-url'};
      final model = Type.fromJson(json);
      expect(model.name, 'water');
      final modelJson = model.toJson();
      expect(modelJson['name'], json['name']);
      expect(modelJson['url'], json['url']);
    });
  });

  group('StatSlot', () {
    test('fromJson e toJson', () {
      final json = {
        'base_stat': 50,
        'effort': 1,
        'stat': {'name': 'attack', 'url': 'stat-url'},
      };
      final model = StatSlot.fromJson(json);
      expect(model.baseStat, 50);
      expect(model.stat.name, 'attack');
      final modelJson = model.toJson();
      // Checa apenas os campos principais, respeitando o mapeamento do .g.dart
      expect(modelJson['base_stat'], 50);
      expect(modelJson['effort'], 1);
      expect(model.stat.name, (json['stat'] as Map<String, dynamic>)['name']);
      expect(model.stat.url, (json['stat'] as Map<String, dynamic>)['url']);
    });
  });

  group('Stat', () {
    test('fromJson e toJson', () {
      final json = {'name': 'defense', 'url': 'stat-url'};
      final model = Stat.fromJson(json);
      expect(model.name, 'defense');
      final modelJson = model.toJson();
      expect(modelJson['name'], json['name']);
      expect(modelJson['url'], json['url']);
    });
  });

  group('Sprites', () {
    test('fromJson e toJson', () {
      final json = {
        'front_default': 'img',
        'front_shiny': 'shiny',
        'other': {
          'official-artwork': {'front_default': 'img', 'front_shiny': 'shiny'},
        },
      };
      final model = Sprites.fromJson(json);
      expect(model.imageUrl, 'img');
      expect(model.shinyUrl, 'shiny');
      final modelJson = model.toJson();
      // Checa apenas os campos principais, respeitando o mapeamento do .g.dart
      expect(modelJson['front_default'], 'img');
      expect(modelJson['front_shiny'], 'shiny');
      final officialArtwork = model.other?.officialArtwork;
      expect(officialArtwork?.frontDefault, 'img');
      expect(officialArtwork?.frontShiny, 'shiny');
    });
  });
}
