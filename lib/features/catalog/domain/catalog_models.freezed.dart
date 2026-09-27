// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DefaultReminder {

 ReminderKind get kind; String get label;/// Months after the purchase date (or creation date) the first due falls.
 int get startMonths; Recurrence get recurrence;
/// Create a copy of DefaultReminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DefaultReminderCopyWith<DefaultReminder> get copyWith => _$DefaultReminderCopyWithImpl<DefaultReminder>(this as DefaultReminder, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DefaultReminder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DefaultReminder&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.startMonths, _this.startMonths) || other.startMonths == _this.startMonths)&&(identical(other.recurrence, _this.recurrence) || other.recurrence == _this.recurrence));
}


@override
int get hashCode {
  final _this = this as DefaultReminder;
  return Object.hash(runtimeType,_this.kind,_this.label,_this.startMonths,_this.recurrence);
}

@override
String toString() {
  final _this = this as DefaultReminder;
  return 'DefaultReminder(kind: ${_this.kind}, label: ${_this.label}, startMonths: ${_this.startMonths}, recurrence: ${_this.recurrence})';
}


}

/// @nodoc
abstract mixin class $DefaultReminderCopyWith<$Res>  {
  factory $DefaultReminderCopyWith(DefaultReminder value, $Res Function(DefaultReminder) _then) = _$DefaultReminderCopyWithImpl;
@useResult
$Res call({
 ReminderKind kind, String label, int startMonths, Recurrence recurrence
});




}
/// @nodoc
class _$DefaultReminderCopyWithImpl<$Res>
    implements $DefaultReminderCopyWith<$Res> {
  _$DefaultReminderCopyWithImpl(this._self, this._then);

  final DefaultReminder _self;
  final $Res Function(DefaultReminder) _then;

/// Create a copy of DefaultReminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? label = null,Object? startMonths = null,Object? recurrence = null,}) {
  return _then(DefaultReminder(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ReminderKind,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,startMonths: null == startMonths ? _self.startMonths : startMonths // ignore: cast_nullable_to_non_nullable
as int,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as Recurrence,
  ));
}

}


/// Adds pattern-matching-related methods to [DefaultReminder].
extension DefaultReminderPatterns on DefaultReminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DefaultReminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DefaultReminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DefaultReminder value)  $default,){
final _that = this;
switch (_that) {
case _DefaultReminder():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DefaultReminder value)?  $default,){
final _that = this;
switch (_that) {
case _DefaultReminder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReminderKind kind,  String label,  int startMonths,  Recurrence recurrence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DefaultReminder() when $default != null:
return $default(_that.kind,_that.label,_that.startMonths,_that.recurrence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReminderKind kind,  String label,  int startMonths,  Recurrence recurrence)  $default,) {final _that = this;
switch (_that) {
case _DefaultReminder():
return $default(_that.kind,_that.label,_that.startMonths,_that.recurrence);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReminderKind kind,  String label,  int startMonths,  Recurrence recurrence)?  $default,) {final _that = this;
switch (_that) {
case _DefaultReminder() when $default != null:
return $default(_that.kind,_that.label,_that.startMonths,_that.recurrence);case _:
  return null;

}
}

}

/// @nodoc


class _DefaultReminder implements DefaultReminder {
  const _DefaultReminder({required this.kind, required this.label, required this.startMonths, this.recurrence = Recurrence.none});
  

@override final  ReminderKind kind;
@override final  String label;
/// Months after the purchase date (or creation date) the first due falls.
@override final  int startMonths;
@override@JsonKey() final  Recurrence recurrence;

/// Create a copy of DefaultReminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DefaultReminderCopyWith<_DefaultReminder> get copyWith => __$DefaultReminderCopyWithImpl<_DefaultReminder>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DefaultReminder&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.label, label) || other.label == label)&&(identical(other.startMonths, startMonths) || other.startMonths == startMonths)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence));
}


@override
int get hashCode {
    return Object.hash(runtimeType,kind,label,startMonths,recurrence);
}

@override
String toString() {
    return 'DefaultReminder(kind: $kind, label: $label, startMonths: $startMonths, recurrence: $recurrence)';
}


}

/// @nodoc
abstract mixin class _$DefaultReminderCopyWith<$Res> implements $DefaultReminderCopyWith<$Res> {
  factory _$DefaultReminderCopyWith(_DefaultReminder value, $Res Function(_DefaultReminder) _then) = __$DefaultReminderCopyWithImpl;
@override @useResult
$Res call({
 ReminderKind kind, String label, int startMonths, Recurrence recurrence
});




}
/// @nodoc
class __$DefaultReminderCopyWithImpl<$Res>
    implements _$DefaultReminderCopyWith<$Res> {
  __$DefaultReminderCopyWithImpl(this._self, this._then);

  final _DefaultReminder _self;
  final $Res Function(_DefaultReminder) _then;

/// Create a copy of DefaultReminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? label = null,Object? startMonths = null,Object? recurrence = null,}) {
  return _then(_DefaultReminder(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ReminderKind,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,startMonths: null == startMonths ? _self.startMonths : startMonths // ignore: cast_nullable_to_non_nullable
as int,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as Recurrence,
  ));
}


}

/// @nodoc
mixin _$AssetCategory {

 String get id; String get slug; String get name;/// Icon key (`car`, `fridge`, …) — mapped to an icon by the UI.
 String? get iconToken; List<DefaultReminder> get defaults;
/// Create a copy of AssetCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssetCategoryCopyWith<AssetCategory> get copyWith => _$AssetCategoryCopyWithImpl<AssetCategory>(this as AssetCategory, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AssetCategory;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssetCategory&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.slug, _this.slug) || other.slug == _this.slug)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.iconToken, _this.iconToken) || other.iconToken == _this.iconToken)&&const DeepCollectionEquality().equals(other.defaults, _this.defaults));
}


@override
int get hashCode {
  final _this = this as AssetCategory;
  return Object.hash(runtimeType,_this.id,_this.slug,_this.name,_this.iconToken,const DeepCollectionEquality().hash(_this.defaults));
}

@override
String toString() {
  final _this = this as AssetCategory;
  return 'AssetCategory(id: ${_this.id}, slug: ${_this.slug}, name: ${_this.name}, iconToken: ${_this.iconToken}, defaults: ${_this.defaults})';
}


}

/// @nodoc
abstract mixin class $AssetCategoryCopyWith<$Res>  {
  factory $AssetCategoryCopyWith(AssetCategory value, $Res Function(AssetCategory) _then) = _$AssetCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String slug, String name, String? iconToken, List<DefaultReminder> defaults
});




}
/// @nodoc
class _$AssetCategoryCopyWithImpl<$Res>
    implements $AssetCategoryCopyWith<$Res> {
  _$AssetCategoryCopyWithImpl(this._self, this._then);

  final AssetCategory _self;
  final $Res Function(AssetCategory) _then;

/// Create a copy of AssetCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? iconToken = freezed,Object? defaults = null,}) {
  return _then(AssetCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconToken: freezed == iconToken ? _self.iconToken : iconToken // ignore: cast_nullable_to_non_nullable
as String?,defaults: null == defaults ? _self.defaults : defaults // ignore: cast_nullable_to_non_nullable
as List<DefaultReminder>,
  ));
}

}


/// Adds pattern-matching-related methods to [AssetCategory].
extension AssetCategoryPatterns on AssetCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssetCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssetCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssetCategory value)  $default,){
final _that = this;
switch (_that) {
case _AssetCategory():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssetCategory value)?  $default,){
final _that = this;
switch (_that) {
case _AssetCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String? iconToken,  List<DefaultReminder> defaults)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssetCategory() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.iconToken,_that.defaults);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String slug,  String name,  String? iconToken,  List<DefaultReminder> defaults)  $default,) {final _that = this;
switch (_that) {
case _AssetCategory():
return $default(_that.id,_that.slug,_that.name,_that.iconToken,_that.defaults);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String slug,  String name,  String? iconToken,  List<DefaultReminder> defaults)?  $default,) {final _that = this;
switch (_that) {
case _AssetCategory() when $default != null:
return $default(_that.id,_that.slug,_that.name,_that.iconToken,_that.defaults);case _:
  return null;

}
}

}

/// @nodoc


class _AssetCategory extends AssetCategory {
  const _AssetCategory({required this.id, required this.slug, required this.name, this.iconToken,  List<DefaultReminder> defaults = const <DefaultReminder>[]}): _defaults = defaults,super._();
  

@override final  String id;
@override final  String slug;
@override final  String name;
/// Icon key (`car`, `fridge`, …) — mapped to an icon by the UI.
@override final  String? iconToken;
 final  List<DefaultReminder> _defaults;
@override@JsonKey() List<DefaultReminder> get defaults {
  if (_defaults is EqualUnmodifiableListView) return _defaults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_defaults);
}


/// Create a copy of AssetCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetCategoryCopyWith<_AssetCategory> get copyWith => __$AssetCategoryCopyWithImpl<_AssetCategory>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconToken, iconToken) || other.iconToken == iconToken)&&const DeepCollectionEquality().equals(other.defaults, _defaults));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,slug,name,iconToken,const DeepCollectionEquality().hash(_defaults));
}

@override
String toString() {
    return 'AssetCategory(id: $id, slug: $slug, name: $name, iconToken: $iconToken, defaults: $defaults)';
}


}

/// @nodoc
abstract mixin class _$AssetCategoryCopyWith<$Res> implements $AssetCategoryCopyWith<$Res> {
  factory _$AssetCategoryCopyWith(_AssetCategory value, $Res Function(_AssetCategory) _then) = __$AssetCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String slug, String name, String? iconToken, List<DefaultReminder> defaults
});




}
/// @nodoc
class __$AssetCategoryCopyWithImpl<$Res>
    implements _$AssetCategoryCopyWith<$Res> {
  __$AssetCategoryCopyWithImpl(this._self, this._then);

  final _AssetCategory _self;
  final $Res Function(_AssetCategory) _then;

/// Create a copy of AssetCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? slug = null,Object? name = null,Object? iconToken = freezed,Object? defaults = null,}) {
  return _then(_AssetCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconToken: freezed == iconToken ? _self.iconToken : iconToken // ignore: cast_nullable_to_non_nullable
as String?,defaults: null == defaults ? _self._defaults : defaults // ignore: cast_nullable_to_non_nullable
as List<DefaultReminder>,
  ));
}


}

/// @nodoc
mixin _$Location {

 String get id; String get name; int get assetCount; String? get kind; String? get imageUrl; String? get parentId;
/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationCopyWith<Location> get copyWith => _$LocationCopyWithImpl<Location>(this as Location, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Location;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Location&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.assetCount, _this.assetCount) || other.assetCount == _this.assetCount)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.parentId, _this.parentId) || other.parentId == _this.parentId));
}


@override
int get hashCode {
  final _this = this as Location;
  return Object.hash(runtimeType,_this.id,_this.name,_this.assetCount,_this.kind,_this.imageUrl,_this.parentId);
}

@override
String toString() {
  final _this = this as Location;
  return 'Location(id: ${_this.id}, name: ${_this.name}, assetCount: ${_this.assetCount}, kind: ${_this.kind}, imageUrl: ${_this.imageUrl}, parentId: ${_this.parentId})';
}


}

/// @nodoc
abstract mixin class $LocationCopyWith<$Res>  {
  factory $LocationCopyWith(Location value, $Res Function(Location) _then) = _$LocationCopyWithImpl;
@useResult
$Res call({
 String id, String name, int assetCount, String? kind, String? imageUrl, String? parentId
});




}
/// @nodoc
class _$LocationCopyWithImpl<$Res>
    implements $LocationCopyWith<$Res> {
  _$LocationCopyWithImpl(this._self, this._then);

  final Location _self;
  final $Res Function(Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? assetCount = null,Object? kind = freezed,Object? imageUrl = freezed,Object? parentId = freezed,}) {
  return _then(Location(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,assetCount: null == assetCount ? _self.assetCount : assetCount // ignore: cast_nullable_to_non_nullable
as int,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Location].
extension LocationPatterns on Location {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Location value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Location() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Location value)  $default,){
final _that = this;
switch (_that) {
case _Location():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Location value)?  $default,){
final _that = this;
switch (_that) {
case _Location() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int assetCount,  String? kind,  String? imageUrl,  String? parentId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that.id,_that.name,_that.assetCount,_that.kind,_that.imageUrl,_that.parentId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int assetCount,  String? kind,  String? imageUrl,  String? parentId)  $default,) {final _that = this;
switch (_that) {
case _Location():
return $default(_that.id,_that.name,_that.assetCount,_that.kind,_that.imageUrl,_that.parentId);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int assetCount,  String? kind,  String? imageUrl,  String? parentId)?  $default,) {final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that.id,_that.name,_that.assetCount,_that.kind,_that.imageUrl,_that.parentId);case _:
  return null;

}
}

}

/// @nodoc


class _Location implements Location {
  const _Location({required this.id, required this.name, this.assetCount = 0, this.kind, this.imageUrl, this.parentId});
  

@override final  String id;
@override final  String name;
@override@JsonKey() final  int assetCount;
@override final  String? kind;
@override final  String? imageUrl;
@override final  String? parentId;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationCopyWith<_Location> get copyWith => __$LocationCopyWithImpl<_Location>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Location&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.assetCount, assetCount) || other.assetCount == assetCount)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.parentId, parentId) || other.parentId == parentId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,assetCount,kind,imageUrl,parentId);
}

@override
String toString() {
    return 'Location(id: $id, name: $name, assetCount: $assetCount, kind: $kind, imageUrl: $imageUrl, parentId: $parentId)';
}


}

/// @nodoc
abstract mixin class _$LocationCopyWith<$Res> implements $LocationCopyWith<$Res> {
  factory _$LocationCopyWith(_Location value, $Res Function(_Location) _then) = __$LocationCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int assetCount, String? kind, String? imageUrl, String? parentId
});




}
/// @nodoc
class __$LocationCopyWithImpl<$Res>
    implements _$LocationCopyWith<$Res> {
  __$LocationCopyWithImpl(this._self, this._then);

  final _Location _self;
  final $Res Function(_Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? assetCount = null,Object? kind = freezed,Object? imageUrl = freezed,Object? parentId = freezed,}) {
  return _then(_Location(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,assetCount: null == assetCount ? _self.assetCount : assetCount // ignore: cast_nullable_to_non_nullable
as int,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,parentId: freezed == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$Asset {

 String get id; String get name; AssetCategoryKind get category;/// FK into `asset_categories` (specific type, e.g. "Air Conditioner").
 String? get categoryId;/// Specific type name — the joined catalog row, a built-in fallback type,
/// or a user-entered custom type ("Others" on Add asset).
 String? get categoryName; String? get locationName; String? get locationId; String? get brand; String? get model; String? get serialNo; DateTime? get purchaseDate; double? get purchasePrice; String? get store; String? get imageUrl;/// Type-specific extras (e.g. Tonnage, IMEI) — `assets.metadata.properties`.
 Map<String, String> get properties;
/// Create a copy of Asset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssetCopyWith<Asset> get copyWith => _$AssetCopyWithImpl<Asset>(this as Asset, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Asset;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Asset&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.categoryName, _this.categoryName) || other.categoryName == _this.categoryName)&&(identical(other.locationName, _this.locationName) || other.locationName == _this.locationName)&&(identical(other.locationId, _this.locationId) || other.locationId == _this.locationId)&&(identical(other.brand, _this.brand) || other.brand == _this.brand)&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.serialNo, _this.serialNo) || other.serialNo == _this.serialNo)&&(identical(other.purchaseDate, _this.purchaseDate) || other.purchaseDate == _this.purchaseDate)&&(identical(other.purchasePrice, _this.purchasePrice) || other.purchasePrice == _this.purchasePrice)&&(identical(other.store, _this.store) || other.store == _this.store)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&const DeepCollectionEquality().equals(other.properties, _this.properties));
}


@override
int get hashCode {
  final _this = this as Asset;
  return Object.hash(runtimeType,_this.id,_this.name,_this.category,_this.categoryId,_this.categoryName,_this.locationName,_this.locationId,_this.brand,_this.model,_this.serialNo,_this.purchaseDate,_this.purchasePrice,_this.store,_this.imageUrl,const DeepCollectionEquality().hash(_this.properties));
}

@override
String toString() {
  final _this = this as Asset;
  return 'Asset(id: ${_this.id}, name: ${_this.name}, category: ${_this.category}, categoryId: ${_this.categoryId}, categoryName: ${_this.categoryName}, locationName: ${_this.locationName}, locationId: ${_this.locationId}, brand: ${_this.brand}, model: ${_this.model}, serialNo: ${_this.serialNo}, purchaseDate: ${_this.purchaseDate}, purchasePrice: ${_this.purchasePrice}, store: ${_this.store}, imageUrl: ${_this.imageUrl}, properties: ${_this.properties})';
}


}

/// @nodoc
abstract mixin class $AssetCopyWith<$Res>  {
  factory $AssetCopyWith(Asset value, $Res Function(Asset) _then) = _$AssetCopyWithImpl;
@useResult
$Res call({
 String id, String name, AssetCategoryKind category, String? categoryId, String? categoryName, String? locationName, String? locationId, String? brand, String? model, String? serialNo, DateTime? purchaseDate, double? purchasePrice, String? store, String? imageUrl, Map<String, String> properties
});




}
/// @nodoc
class _$AssetCopyWithImpl<$Res>
    implements $AssetCopyWith<$Res> {
  _$AssetCopyWithImpl(this._self, this._then);

  final Asset _self;
  final $Res Function(Asset) _then;

/// Create a copy of Asset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? categoryId = freezed,Object? categoryName = freezed,Object? locationName = freezed,Object? locationId = freezed,Object? brand = freezed,Object? model = freezed,Object? serialNo = freezed,Object? purchaseDate = freezed,Object? purchasePrice = freezed,Object? store = freezed,Object? imageUrl = freezed,Object? properties = null,}) {
  return _then(Asset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as AssetCategoryKind,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,serialNo: freezed == serialNo ? _self.serialNo : serialNo // ignore: cast_nullable_to_non_nullable
as String?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double?,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,properties: null == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Asset].
extension AssetPatterns on Asset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Asset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Asset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Asset value)  $default,){
final _that = this;
switch (_that) {
case _Asset():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Asset value)?  $default,){
final _that = this;
switch (_that) {
case _Asset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  AssetCategoryKind category,  String? categoryId,  String? categoryName,  String? locationName,  String? locationId,  String? brand,  String? model,  String? serialNo,  DateTime? purchaseDate,  double? purchasePrice,  String? store,  String? imageUrl,  Map<String, String> properties)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Asset() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.categoryId,_that.categoryName,_that.locationName,_that.locationId,_that.brand,_that.model,_that.serialNo,_that.purchaseDate,_that.purchasePrice,_that.store,_that.imageUrl,_that.properties);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  AssetCategoryKind category,  String? categoryId,  String? categoryName,  String? locationName,  String? locationId,  String? brand,  String? model,  String? serialNo,  DateTime? purchaseDate,  double? purchasePrice,  String? store,  String? imageUrl,  Map<String, String> properties)  $default,) {final _that = this;
switch (_that) {
case _Asset():
return $default(_that.id,_that.name,_that.category,_that.categoryId,_that.categoryName,_that.locationName,_that.locationId,_that.brand,_that.model,_that.serialNo,_that.purchaseDate,_that.purchasePrice,_that.store,_that.imageUrl,_that.properties);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  AssetCategoryKind category,  String? categoryId,  String? categoryName,  String? locationName,  String? locationId,  String? brand,  String? model,  String? serialNo,  DateTime? purchaseDate,  double? purchasePrice,  String? store,  String? imageUrl,  Map<String, String> properties)?  $default,) {final _that = this;
switch (_that) {
case _Asset() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.categoryId,_that.categoryName,_that.locationName,_that.locationId,_that.brand,_that.model,_that.serialNo,_that.purchaseDate,_that.purchasePrice,_that.store,_that.imageUrl,_that.properties);case _:
  return null;

}
}

}

/// @nodoc


class _Asset extends Asset {
  const _Asset({required this.id, required this.name, required this.category, this.categoryId, this.categoryName, this.locationName, this.locationId, this.brand, this.model, this.serialNo, this.purchaseDate, this.purchasePrice, this.store, this.imageUrl,  Map<String, String> properties = const <String, String>{}}): _properties = properties,super._();
  

@override final  String id;
@override final  String name;
@override final  AssetCategoryKind category;
/// FK into `asset_categories` (specific type, e.g. "Air Conditioner").
@override final  String? categoryId;
/// Specific type name — the joined catalog row, a built-in fallback type,
/// or a user-entered custom type ("Others" on Add asset).
@override final  String? categoryName;
@override final  String? locationName;
@override final  String? locationId;
@override final  String? brand;
@override final  String? model;
@override final  String? serialNo;
@override final  DateTime? purchaseDate;
@override final  double? purchasePrice;
@override final  String? store;
@override final  String? imageUrl;
/// Type-specific extras (e.g. Tonnage, IMEI) — `assets.metadata.properties`.
 final  Map<String, String> _properties;
/// Type-specific extras (e.g. Tonnage, IMEI) — `assets.metadata.properties`.
@override@JsonKey() Map<String, String> get properties {
  if (_properties is EqualUnmodifiableMapView) return _properties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_properties);
}


/// Create a copy of Asset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetCopyWith<_Asset> get copyWith => __$AssetCopyWithImpl<_Asset>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Asset&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model)&&(identical(other.serialNo, serialNo) || other.serialNo == serialNo)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.store, store) || other.store == store)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.properties, _properties));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,category,categoryId,categoryName,locationName,locationId,brand,model,serialNo,purchaseDate,purchasePrice,store,imageUrl,const DeepCollectionEquality().hash(_properties));
}

@override
String toString() {
    return 'Asset(id: $id, name: $name, category: $category, categoryId: $categoryId, categoryName: $categoryName, locationName: $locationName, locationId: $locationId, brand: $brand, model: $model, serialNo: $serialNo, purchaseDate: $purchaseDate, purchasePrice: $purchasePrice, store: $store, imageUrl: $imageUrl, properties: $properties)';
}


}

/// @nodoc
abstract mixin class _$AssetCopyWith<$Res> implements $AssetCopyWith<$Res> {
  factory _$AssetCopyWith(_Asset value, $Res Function(_Asset) _then) = __$AssetCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, AssetCategoryKind category, String? categoryId, String? categoryName, String? locationName, String? locationId, String? brand, String? model, String? serialNo, DateTime? purchaseDate, double? purchasePrice, String? store, String? imageUrl, Map<String, String> properties
});




}
/// @nodoc
class __$AssetCopyWithImpl<$Res>
    implements _$AssetCopyWith<$Res> {
  __$AssetCopyWithImpl(this._self, this._then);

  final _Asset _self;
  final $Res Function(_Asset) _then;

/// Create a copy of Asset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? categoryId = freezed,Object? categoryName = freezed,Object? locationName = freezed,Object? locationId = freezed,Object? brand = freezed,Object? model = freezed,Object? serialNo = freezed,Object? purchaseDate = freezed,Object? purchasePrice = freezed,Object? store = freezed,Object? imageUrl = freezed,Object? properties = null,}) {
  return _then(_Asset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as AssetCategoryKind,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,locationId: freezed == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as String?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,serialNo: freezed == serialNo ? _self.serialNo : serialNo // ignore: cast_nullable_to_non_nullable
as String?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double?,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,properties: null == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

/// @nodoc
mixin _$Reminder {

 String get id; String get assetId; String get assetName; ReminderKind get kind; String get label; DateTime get dueDate; Recurrence get recurrence;/// Days-before-due to notify at (per service, `asset_dates.notify_offsets`).
 List<int> get notifyOffsets; String? get provider; String? get policyNo; double? get cost; String? get notes;/// The parent asset's photo reference (bucket path or URL), for list rows.
 String? get assetImageUrl;
/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderCopyWith<Reminder> get copyWith => _$ReminderCopyWithImpl<Reminder>(this as Reminder, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Reminder;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reminder&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.assetId, _this.assetId) || other.assetId == _this.assetId)&&(identical(other.assetName, _this.assetName) || other.assetName == _this.assetName)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.recurrence, _this.recurrence) || other.recurrence == _this.recurrence)&&const DeepCollectionEquality().equals(other.notifyOffsets, _this.notifyOffsets)&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.policyNo, _this.policyNo) || other.policyNo == _this.policyNo)&&(identical(other.cost, _this.cost) || other.cost == _this.cost)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.assetImageUrl, _this.assetImageUrl) || other.assetImageUrl == _this.assetImageUrl));
}


@override
int get hashCode {
  final _this = this as Reminder;
  return Object.hash(runtimeType,_this.id,_this.assetId,_this.assetName,_this.kind,_this.label,_this.dueDate,_this.recurrence,const DeepCollectionEquality().hash(_this.notifyOffsets),_this.provider,_this.policyNo,_this.cost,_this.notes,_this.assetImageUrl);
}

@override
String toString() {
  final _this = this as Reminder;
  return 'Reminder(id: ${_this.id}, assetId: ${_this.assetId}, assetName: ${_this.assetName}, kind: ${_this.kind}, label: ${_this.label}, dueDate: ${_this.dueDate}, recurrence: ${_this.recurrence}, notifyOffsets: ${_this.notifyOffsets}, provider: ${_this.provider}, policyNo: ${_this.policyNo}, cost: ${_this.cost}, notes: ${_this.notes}, assetImageUrl: ${_this.assetImageUrl})';
}


}

/// @nodoc
abstract mixin class $ReminderCopyWith<$Res>  {
  factory $ReminderCopyWith(Reminder value, $Res Function(Reminder) _then) = _$ReminderCopyWithImpl;
@useResult
$Res call({
 String id, String assetId, String assetName, ReminderKind kind, String label, DateTime dueDate, Recurrence recurrence, List<int> notifyOffsets, String? provider, String? policyNo, double? cost, String? notes, String? assetImageUrl
});




}
/// @nodoc
class _$ReminderCopyWithImpl<$Res>
    implements $ReminderCopyWith<$Res> {
  _$ReminderCopyWithImpl(this._self, this._then);

  final Reminder _self;
  final $Res Function(Reminder) _then;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? assetId = null,Object? assetName = null,Object? kind = null,Object? label = null,Object? dueDate = null,Object? recurrence = null,Object? notifyOffsets = null,Object? provider = freezed,Object? policyNo = freezed,Object? cost = freezed,Object? notes = freezed,Object? assetImageUrl = freezed,}) {
  return _then(Reminder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,assetName: null == assetName ? _self.assetName : assetName // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ReminderKind,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as Recurrence,notifyOffsets: null == notifyOffsets ? _self.notifyOffsets : notifyOffsets // ignore: cast_nullable_to_non_nullable
as List<int>,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,policyNo: freezed == policyNo ? _self.policyNo : policyNo // ignore: cast_nullable_to_non_nullable
as String?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,assetImageUrl: freezed == assetImageUrl ? _self.assetImageUrl : assetImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Reminder].
extension ReminderPatterns on Reminder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reminder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reminder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reminder value)  $default,){
final _that = this;
switch (_that) {
case _Reminder():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reminder value)?  $default,){
final _that = this;
switch (_that) {
case _Reminder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String assetId,  String assetName,  ReminderKind kind,  String label,  DateTime dueDate,  Recurrence recurrence,  List<int> notifyOffsets,  String? provider,  String? policyNo,  double? cost,  String? notes,  String? assetImageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reminder() when $default != null:
return $default(_that.id,_that.assetId,_that.assetName,_that.kind,_that.label,_that.dueDate,_that.recurrence,_that.notifyOffsets,_that.provider,_that.policyNo,_that.cost,_that.notes,_that.assetImageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String assetId,  String assetName,  ReminderKind kind,  String label,  DateTime dueDate,  Recurrence recurrence,  List<int> notifyOffsets,  String? provider,  String? policyNo,  double? cost,  String? notes,  String? assetImageUrl)  $default,) {final _that = this;
switch (_that) {
case _Reminder():
return $default(_that.id,_that.assetId,_that.assetName,_that.kind,_that.label,_that.dueDate,_that.recurrence,_that.notifyOffsets,_that.provider,_that.policyNo,_that.cost,_that.notes,_that.assetImageUrl);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String assetId,  String assetName,  ReminderKind kind,  String label,  DateTime dueDate,  Recurrence recurrence,  List<int> notifyOffsets,  String? provider,  String? policyNo,  double? cost,  String? notes,  String? assetImageUrl)?  $default,) {final _that = this;
switch (_that) {
case _Reminder() when $default != null:
return $default(_that.id,_that.assetId,_that.assetName,_that.kind,_that.label,_that.dueDate,_that.recurrence,_that.notifyOffsets,_that.provider,_that.policyNo,_that.cost,_that.notes,_that.assetImageUrl);case _:
  return null;

}
}

}

/// @nodoc


class _Reminder extends Reminder {
  const _Reminder({required this.id, required this.assetId, required this.assetName, required this.kind, required this.label, required this.dueDate, this.recurrence = Recurrence.none,  List<int> notifyOffsets = const <int>[30, 7, 1], this.provider, this.policyNo, this.cost, this.notes, this.assetImageUrl}): _notifyOffsets = notifyOffsets,super._();
  

@override final  String id;
@override final  String assetId;
@override final  String assetName;
@override final  ReminderKind kind;
@override final  String label;
@override final  DateTime dueDate;
@override@JsonKey() final  Recurrence recurrence;
/// Days-before-due to notify at (per service, `asset_dates.notify_offsets`).
 final  List<int> _notifyOffsets;
/// Days-before-due to notify at (per service, `asset_dates.notify_offsets`).
@override@JsonKey() List<int> get notifyOffsets {
  if (_notifyOffsets is EqualUnmodifiableListView) return _notifyOffsets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notifyOffsets);
}

@override final  String? provider;
@override final  String? policyNo;
@override final  double? cost;
@override final  String? notes;
/// The parent asset's photo reference (bucket path or URL), for list rows.
@override final  String? assetImageUrl;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderCopyWith<_Reminder> get copyWith => __$ReminderCopyWithImpl<_Reminder>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reminder&&(identical(other.id, id) || other.id == id)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.assetName, assetName) || other.assetName == assetName)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.label, label) || other.label == label)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&const DeepCollectionEquality().equals(other.notifyOffsets, _notifyOffsets)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.policyNo, policyNo) || other.policyNo == policyNo)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.assetImageUrl, assetImageUrl) || other.assetImageUrl == assetImageUrl));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,assetId,assetName,kind,label,dueDate,recurrence,const DeepCollectionEquality().hash(_notifyOffsets),provider,policyNo,cost,notes,assetImageUrl);
}

@override
String toString() {
    return 'Reminder(id: $id, assetId: $assetId, assetName: $assetName, kind: $kind, label: $label, dueDate: $dueDate, recurrence: $recurrence, notifyOffsets: $notifyOffsets, provider: $provider, policyNo: $policyNo, cost: $cost, notes: $notes, assetImageUrl: $assetImageUrl)';
}


}

/// @nodoc
abstract mixin class _$ReminderCopyWith<$Res> implements $ReminderCopyWith<$Res> {
  factory _$ReminderCopyWith(_Reminder value, $Res Function(_Reminder) _then) = __$ReminderCopyWithImpl;
@override @useResult
$Res call({
 String id, String assetId, String assetName, ReminderKind kind, String label, DateTime dueDate, Recurrence recurrence, List<int> notifyOffsets, String? provider, String? policyNo, double? cost, String? notes, String? assetImageUrl
});




}
/// @nodoc
class __$ReminderCopyWithImpl<$Res>
    implements _$ReminderCopyWith<$Res> {
  __$ReminderCopyWithImpl(this._self, this._then);

  final _Reminder _self;
  final $Res Function(_Reminder) _then;

/// Create a copy of Reminder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? assetId = null,Object? assetName = null,Object? kind = null,Object? label = null,Object? dueDate = null,Object? recurrence = null,Object? notifyOffsets = null,Object? provider = freezed,Object? policyNo = freezed,Object? cost = freezed,Object? notes = freezed,Object? assetImageUrl = freezed,}) {
  return _then(_Reminder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,assetName: null == assetName ? _self.assetName : assetName // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ReminderKind,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as Recurrence,notifyOffsets: null == notifyOffsets ? _self._notifyOffsets : notifyOffsets // ignore: cast_nullable_to_non_nullable
as List<int>,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,policyNo: freezed == policyNo ? _self.policyNo : policyNo // ignore: cast_nullable_to_non_nullable
as String?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,assetImageUrl: freezed == assetImageUrl ? _self.assetImageUrl : assetImageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
