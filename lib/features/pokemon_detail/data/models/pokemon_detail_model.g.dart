// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PokemonDetailModel _$PokemonDetailModelFromJson(Map<String, dynamic> json) =>
    _PokemonDetailModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      height: (json['height'] as num).toInt(),
      weight: (json['weight'] as num).toInt(),
      types: (json['types'] as List<dynamic>)
          .map((e) => TypeSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: (json['stats'] as List<dynamic>)
          .map((e) => StatSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
      sprites: Sprites.fromJson(json['sprites'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PokemonDetailModelToJson(_PokemonDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'height': instance.height,
      'weight': instance.weight,
      'types': instance.types,
      'stats': instance.stats,
      'sprites': instance.sprites,
    };

_TypeSlot _$TypeSlotFromJson(Map<String, dynamic> json) => _TypeSlot(
  slot: (json['slot'] as num).toInt(),
  type: Type.fromJson(json['type'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TypeSlotToJson(_TypeSlot instance) => <String, dynamic>{
  'slot': instance.slot,
  'type': instance.type,
};

_Type _$TypeFromJson(Map<String, dynamic> json) =>
    _Type(name: json['name'] as String, url: json['url'] as String);

Map<String, dynamic> _$TypeToJson(_Type instance) => <String, dynamic>{
  'name': instance.name,
  'url': instance.url,
};

_StatSlot _$StatSlotFromJson(Map<String, dynamic> json) => _StatSlot(
  baseStat: (json['base_stat'] as num).toInt(),
  effort: (json['effort'] as num).toInt(),
  stat: Stat.fromJson(json['stat'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StatSlotToJson(_StatSlot instance) => <String, dynamic>{
  'base_stat': instance.baseStat,
  'effort': instance.effort,
  'stat': instance.stat,
};

_Stat _$StatFromJson(Map<String, dynamic> json) =>
    _Stat(name: json['name'] as String, url: json['url'] as String);

Map<String, dynamic> _$StatToJson(_Stat instance) => <String, dynamic>{
  'name': instance.name,
  'url': instance.url,
};

_Sprites _$SpritesFromJson(Map<String, dynamic> json) => _Sprites(
  frontDefault: json['front_default'] as String?,
  frontShiny: json['front_shiny'] as String?,
  other: json['other'] == null
      ? null
      : OtherSprites.fromJson(json['other'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SpritesToJson(_Sprites instance) => <String, dynamic>{
  'front_default': instance.frontDefault,
  'front_shiny': instance.frontShiny,
  'other': instance.other,
};

_OtherSprites _$OtherSpritesFromJson(Map<String, dynamic> json) =>
    _OtherSprites(
      officialArtwork: json['official-artwork'] == null
          ? null
          : OfficialArtwork.fromJson(
              json['official-artwork'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$OtherSpritesToJson(_OtherSprites instance) =>
    <String, dynamic>{'official-artwork': instance.officialArtwork};

_OfficialArtwork _$OfficialArtworkFromJson(Map<String, dynamic> json) =>
    _OfficialArtwork(
      frontDefault: json['front_default'] as String?,
      frontShiny: json['front_shiny'] as String?,
    );

Map<String, dynamic> _$OfficialArtworkToJson(_OfficialArtwork instance) =>
    <String, dynamic>{
      'front_default': instance.frontDefault,
      'front_shiny': instance.frontShiny,
    };
