// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_list_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PokemonListItemModel _$PokemonListItemModelFromJson(
  Map<String, dynamic> json,
) => _PokemonListItemModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  url: json['url'] as String,
  types:
      (json['types'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
);

Map<String, dynamic> _$PokemonListItemModelToJson(
  _PokemonListItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'url': instance.url,
  'types': instance.types,
};
