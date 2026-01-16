// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pokemon_list_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PokemonListItemModel {

 int get id; String get name; String get url; List<String> get types;
/// Create a copy of PokemonListItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PokemonListItemModelCopyWith<PokemonListItemModel> get copyWith => _$PokemonListItemModelCopyWithImpl<PokemonListItemModel>(this as PokemonListItemModel, _$identity);

  /// Serializes this PokemonListItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PokemonListItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other.types, types));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,url,const DeepCollectionEquality().hash(types));

@override
String toString() {
  return 'PokemonListItemModel(id: $id, name: $name, url: $url, types: $types)';
}


}

/// @nodoc
abstract mixin class $PokemonListItemModelCopyWith<$Res>  {
  factory $PokemonListItemModelCopyWith(PokemonListItemModel value, $Res Function(PokemonListItemModel) _then) = _$PokemonListItemModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, String url, List<String> types
});




}
/// @nodoc
class _$PokemonListItemModelCopyWithImpl<$Res>
    implements $PokemonListItemModelCopyWith<$Res> {
  _$PokemonListItemModelCopyWithImpl(this._self, this._then);

  final PokemonListItemModel _self;
  final $Res Function(PokemonListItemModel) _then;

/// Create a copy of PokemonListItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? url = null,Object? types = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,types: null == types ? _self.types : types // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PokemonListItemModel].
extension PokemonListItemModelPatterns on PokemonListItemModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PokemonListItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PokemonListItemModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PokemonListItemModel value)  $default,){
final _that = this;
switch (_that) {
case _PokemonListItemModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PokemonListItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _PokemonListItemModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String url,  List<String> types)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PokemonListItemModel() when $default != null:
return $default(_that.id,_that.name,_that.url,_that.types);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String url,  List<String> types)  $default,) {final _that = this;
switch (_that) {
case _PokemonListItemModel():
return $default(_that.id,_that.name,_that.url,_that.types);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String url,  List<String> types)?  $default,) {final _that = this;
switch (_that) {
case _PokemonListItemModel() when $default != null:
return $default(_that.id,_that.name,_that.url,_that.types);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PokemonListItemModel extends PokemonListItemModel {
  const _PokemonListItemModel({required this.id, required this.name, required this.url, final  List<String> types = const <String>[]}): _types = types,super._();
  factory _PokemonListItemModel.fromJson(Map<String, dynamic> json) => _$PokemonListItemModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  String url;
 final  List<String> _types;
@override@JsonKey() List<String> get types {
  if (_types is EqualUnmodifiableListView) return _types;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_types);
}


/// Create a copy of PokemonListItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PokemonListItemModelCopyWith<_PokemonListItemModel> get copyWith => __$PokemonListItemModelCopyWithImpl<_PokemonListItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PokemonListItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PokemonListItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.url, url) || other.url == url)&&const DeepCollectionEquality().equals(other._types, _types));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,url,const DeepCollectionEquality().hash(_types));

@override
String toString() {
  return 'PokemonListItemModel(id: $id, name: $name, url: $url, types: $types)';
}


}

/// @nodoc
abstract mixin class _$PokemonListItemModelCopyWith<$Res> implements $PokemonListItemModelCopyWith<$Res> {
  factory _$PokemonListItemModelCopyWith(_PokemonListItemModel value, $Res Function(_PokemonListItemModel) _then) = __$PokemonListItemModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String url, List<String> types
});




}
/// @nodoc
class __$PokemonListItemModelCopyWithImpl<$Res>
    implements _$PokemonListItemModelCopyWith<$Res> {
  __$PokemonListItemModelCopyWithImpl(this._self, this._then);

  final _PokemonListItemModel _self;
  final $Res Function(_PokemonListItemModel) _then;

/// Create a copy of PokemonListItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? url = null,Object? types = null,}) {
  return _then(_PokemonListItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,types: null == types ? _self._types : types // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
