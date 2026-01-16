import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_list_item_model.freezed.dart';
part 'pokemon_list_item_model.g.dart';

@freezed
sealed class PokemonListItemModel with _$PokemonListItemModel {
  const PokemonListItemModel._();

  const factory PokemonListItemModel({
    required int id,
    required String name,
    required String url,
    @Default(<String>[]) List<String> types,
    // isFavorite removido
  }) = _PokemonListItemModel;

  factory PokemonListItemModel.fromJson(Map<String, dynamic> json) =>
      _$PokemonListItemModelFromJson(json);

  factory PokemonListItemModel.fromApi(Map<String, dynamic> json) {
    final url = json['url'] as String? ?? '';
    final idFromUrl =
        int.tryParse(url.split('/').where((e) => e.isNotEmpty).last) ?? 0;

    return PokemonListItemModel(
      id: idFromUrl,
      name: json['name'] as String? ?? '',
      url: url,
    );
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}
