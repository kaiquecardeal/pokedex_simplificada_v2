// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_detail_model.freezed.dart';
part 'pokemon_detail_model.g.dart';

@freezed
sealed class PokemonDetailModel with _$PokemonDetailModel {
  const factory PokemonDetailModel({
    required int id,
    required String name,
    required int height,
    required int weight,
    required List<TypeSlot> types,
    required List<StatSlot> stats,
    required Sprites sprites,
  }) = _PokemonDetailModel;

  factory PokemonDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailModelFromJson(json);
}

@freezed
sealed class TypeSlot with _$TypeSlot {
  const factory TypeSlot({required int slot, required Type type}) = _TypeSlot;

  factory TypeSlot.fromJson(Map<String, dynamic> json) =>
      _$TypeSlotFromJson(json);
}

@freezed
sealed class Type with _$Type {
  const factory Type({required String name, required String url}) = _Type;

  factory Type.fromJson(Map<String, dynamic> json) => _$TypeFromJson(json);
}

@freezed
sealed class StatSlot with _$StatSlot {
  const factory StatSlot({
    @JsonKey(name: 'base_stat') required int baseStat,
    required int effort,
    required Stat stat,
  }) = _StatSlot;

  factory StatSlot.fromJson(Map<String, dynamic> json) =>
      _$StatSlotFromJson(json);
}

@freezed
sealed class Stat with _$Stat {
  const factory Stat({required String name, required String url}) = _Stat;

  factory Stat.fromJson(Map<String, dynamic> json) => _$StatFromJson(json);
}

@freezed
sealed class Sprites with _$Sprites {
  const Sprites._(); // Necessário para getters customizados

  const factory Sprites({
    @JsonKey(name: 'front_default') String? frontDefault,
    @JsonKey(name: 'front_shiny') String? frontShiny,
    @JsonKey(name: 'other') OtherSprites? other,
  }) = _Sprites;

  factory Sprites.fromJson(Map<String, dynamic> json) =>
      _$SpritesFromJson(json);

  String get imageUrl =>
      other?.officialArtwork?.frontDefault ?? frontDefault ?? '';

  String get shinyUrl => other?.officialArtwork?.frontShiny ?? frontShiny ?? '';
}

@freezed
sealed class OtherSprites with _$OtherSprites {
  const factory OtherSprites({
    @JsonKey(name: 'official-artwork') OfficialArtwork? officialArtwork,
  }) = _OtherSprites;

  factory OtherSprites.fromJson(Map<String, dynamic> json) =>
      _$OtherSpritesFromJson(json);
}

@freezed
sealed class OfficialArtwork with _$OfficialArtwork {
  const factory OfficialArtwork({
    @JsonKey(name: 'front_default') String? frontDefault,
    @JsonKey(name: 'front_shiny') String? frontShiny,
  }) = _OfficialArtwork;

  factory OfficialArtwork.fromJson(Map<String, dynamic> json) =>
      _$OfficialArtworkFromJson(json);
}
