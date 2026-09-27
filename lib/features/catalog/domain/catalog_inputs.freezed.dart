// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog_inputs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AssetInput {

 String get name; AssetCategoryKind get category; String? get categoryId; String? get typeName; String? get locationName; String? get brand; String? get model; String? get serialNo; DateTime? get purchaseDate; double? get purchasePrice; String? get store; Map<String, String> get properties;
/// Create a copy of AssetInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssetInputCopyWith<AssetInput> get copyWith => _$AssetInputCopyWithImpl<AssetInput>(this as AssetInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AssetInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssetInput&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.categoryId, _this.categoryId) || other.categoryId == _this.categoryId)&&(identical(other.typeName, _this.typeName) || other.typeName == _this.typeName)&&(identical(other.locationName, _this.locationName) || other.locationName == _this.locationName)&&(identical(other.brand, _this.brand) || other.brand == _this.brand)&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.serialNo, _this.serialNo) || other.serialNo == _this.serialNo)&&(identical(other.purchaseDate, _this.purchaseDate) || other.purchaseDate == _this.purchaseDate)&&(identical(other.purchasePrice, _this.purchasePrice) || other.purchasePrice == _this.purchasePrice)&&(identical(other.store, _this.store) || other.store == _this.store)&&const DeepCollectionEquality().equals(other.properties, _this.properties));
}


@override
int get hashCode {
  final _this = this as AssetInput;
  return Object.hash(runtimeType,_this.name,_this.category,_this.categoryId,_this.typeName,_this.locationName,_this.brand,_this.model,_this.serialNo,_this.purchaseDate,_this.purchasePrice,_this.store,const DeepCollectionEquality().hash(_this.properties));
}

@override
String toString() {
  final _this = this as AssetInput;
  return 'AssetInput(name: ${_this.name}, category: ${_this.category}, categoryId: ${_this.categoryId}, typeName: ${_this.typeName}, locationName: ${_this.locationName}, brand: ${_this.brand}, model: ${_this.model}, serialNo: ${_this.serialNo}, purchaseDate: ${_this.purchaseDate}, purchasePrice: ${_this.purchasePrice}, store: ${_this.store}, properties: ${_this.properties})';
}


}

/// @nodoc
abstract mixin class $AssetInputCopyWith<$Res>  {
  factory $AssetInputCopyWith(AssetInput value, $Res Function(AssetInput) _then) = _$AssetInputCopyWithImpl;
@useResult
$Res call({
 String name, AssetCategoryKind category, String? categoryId, String? typeName, String? locationName, String? brand, String? model, String? serialNo, DateTime? purchaseDate, double? purchasePrice, String? store, Map<String, String> properties
});




}
/// @nodoc
class _$AssetInputCopyWithImpl<$Res>
    implements $AssetInputCopyWith<$Res> {
  _$AssetInputCopyWithImpl(this._self, this._then);

  final AssetInput _self;
  final $Res Function(AssetInput) _then;

/// Create a copy of AssetInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? category = null,Object? categoryId = freezed,Object? typeName = freezed,Object? locationName = freezed,Object? brand = freezed,Object? model = freezed,Object? serialNo = freezed,Object? purchaseDate = freezed,Object? purchasePrice = freezed,Object? store = freezed,Object? properties = null,}) {
  return _then(AssetInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as AssetCategoryKind,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,typeName: freezed == typeName ? _self.typeName : typeName // ignore: cast_nullable_to_non_nullable
as String?,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,serialNo: freezed == serialNo ? _self.serialNo : serialNo // ignore: cast_nullable_to_non_nullable
as String?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double?,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as String?,properties: null == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AssetInput].
extension AssetInputPatterns on AssetInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssetInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssetInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssetInput value)  $default,){
final _that = this;
switch (_that) {
case _AssetInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssetInput value)?  $default,){
final _that = this;
switch (_that) {
case _AssetInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  AssetCategoryKind category,  String? categoryId,  String? typeName,  String? locationName,  String? brand,  String? model,  String? serialNo,  DateTime? purchaseDate,  double? purchasePrice,  String? store,  Map<String, String> properties)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssetInput() when $default != null:
return $default(_that.name,_that.category,_that.categoryId,_that.typeName,_that.locationName,_that.brand,_that.model,_that.serialNo,_that.purchaseDate,_that.purchasePrice,_that.store,_that.properties);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  AssetCategoryKind category,  String? categoryId,  String? typeName,  String? locationName,  String? brand,  String? model,  String? serialNo,  DateTime? purchaseDate,  double? purchasePrice,  String? store,  Map<String, String> properties)  $default,) {final _that = this;
switch (_that) {
case _AssetInput():
return $default(_that.name,_that.category,_that.categoryId,_that.typeName,_that.locationName,_that.brand,_that.model,_that.serialNo,_that.purchaseDate,_that.purchasePrice,_that.store,_that.properties);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  AssetCategoryKind category,  String? categoryId,  String? typeName,  String? locationName,  String? brand,  String? model,  String? serialNo,  DateTime? purchaseDate,  double? purchasePrice,  String? store,  Map<String, String> properties)?  $default,) {final _that = this;
switch (_that) {
case _AssetInput() when $default != null:
return $default(_that.name,_that.category,_that.categoryId,_that.typeName,_that.locationName,_that.brand,_that.model,_that.serialNo,_that.purchaseDate,_that.purchasePrice,_that.store,_that.properties);case _:
  return null;

}
}

}

/// @nodoc


class _AssetInput implements AssetInput {
  const _AssetInput({required this.name, required this.category, this.categoryId, this.typeName, this.locationName, this.brand, this.model, this.serialNo, this.purchaseDate, this.purchasePrice, this.store,  Map<String, String> properties = const <String, String>{}}): _properties = properties;
  

@override final  String name;
@override final  AssetCategoryKind category;
@override final  String? categoryId;
@override final  String? typeName;
@override final  String? locationName;
@override final  String? brand;
@override final  String? model;
@override final  String? serialNo;
@override final  DateTime? purchaseDate;
@override final  double? purchasePrice;
@override final  String? store;
 final  Map<String, String> _properties;
@override@JsonKey() Map<String, String> get properties {
  if (_properties is EqualUnmodifiableMapView) return _properties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_properties);
}


/// Create a copy of AssetInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetInputCopyWith<_AssetInput> get copyWith => __$AssetInputCopyWithImpl<_AssetInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetInput&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.typeName, typeName) || other.typeName == typeName)&&(identical(other.locationName, locationName) || other.locationName == locationName)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model)&&(identical(other.serialNo, serialNo) || other.serialNo == serialNo)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&(identical(other.purchasePrice, purchasePrice) || other.purchasePrice == purchasePrice)&&(identical(other.store, store) || other.store == store)&&const DeepCollectionEquality().equals(other.properties, _properties));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,category,categoryId,typeName,locationName,brand,model,serialNo,purchaseDate,purchasePrice,store,const DeepCollectionEquality().hash(_properties));
}

@override
String toString() {
    return 'AssetInput(name: $name, category: $category, categoryId: $categoryId, typeName: $typeName, locationName: $locationName, brand: $brand, model: $model, serialNo: $serialNo, purchaseDate: $purchaseDate, purchasePrice: $purchasePrice, store: $store, properties: $properties)';
}


}

/// @nodoc
abstract mixin class _$AssetInputCopyWith<$Res> implements $AssetInputCopyWith<$Res> {
  factory _$AssetInputCopyWith(_AssetInput value, $Res Function(_AssetInput) _then) = __$AssetInputCopyWithImpl;
@override @useResult
$Res call({
 String name, AssetCategoryKind category, String? categoryId, String? typeName, String? locationName, String? brand, String? model, String? serialNo, DateTime? purchaseDate, double? purchasePrice, String? store, Map<String, String> properties
});




}
/// @nodoc
class __$AssetInputCopyWithImpl<$Res>
    implements _$AssetInputCopyWith<$Res> {
  __$AssetInputCopyWithImpl(this._self, this._then);

  final _AssetInput _self;
  final $Res Function(_AssetInput) _then;

/// Create a copy of AssetInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? category = null,Object? categoryId = freezed,Object? typeName = freezed,Object? locationName = freezed,Object? brand = freezed,Object? model = freezed,Object? serialNo = freezed,Object? purchaseDate = freezed,Object? purchasePrice = freezed,Object? store = freezed,Object? properties = null,}) {
  return _then(_AssetInput(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as AssetCategoryKind,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,typeName: freezed == typeName ? _self.typeName : typeName // ignore: cast_nullable_to_non_nullable
as String?,locationName: freezed == locationName ? _self.locationName : locationName // ignore: cast_nullable_to_non_nullable
as String?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,serialNo: freezed == serialNo ? _self.serialNo : serialNo // ignore: cast_nullable_to_non_nullable
as String?,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,purchasePrice: freezed == purchasePrice ? _self.purchasePrice : purchasePrice // ignore: cast_nullable_to_non_nullable
as double?,store: freezed == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as String?,properties: null == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

/// @nodoc
mixin _$ReminderInput {

 ReminderKind get kind; String get label; DateTime get dueDate; Recurrence get recurrence;/// Days before due, largest first. Null = the backend default.
 List<int>? get notifyOffsets; String? get provider; String? get policyNo; double? get cost; String? get notes;
/// Create a copy of ReminderInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderInputCopyWith<ReminderInput> get copyWith => _$ReminderInputCopyWithImpl<ReminderInput>(this as ReminderInput, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReminderInput;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderInput&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.recurrence, _this.recurrence) || other.recurrence == _this.recurrence)&&const DeepCollectionEquality().equals(other.notifyOffsets, _this.notifyOffsets)&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.policyNo, _this.policyNo) || other.policyNo == _this.policyNo)&&(identical(other.cost, _this.cost) || other.cost == _this.cost)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}


@override
int get hashCode {
  final _this = this as ReminderInput;
  return Object.hash(runtimeType,_this.kind,_this.label,_this.dueDate,_this.recurrence,const DeepCollectionEquality().hash(_this.notifyOffsets),_this.provider,_this.policyNo,_this.cost,_this.notes);
}

@override
String toString() {
  final _this = this as ReminderInput;
  return 'ReminderInput(kind: ${_this.kind}, label: ${_this.label}, dueDate: ${_this.dueDate}, recurrence: ${_this.recurrence}, notifyOffsets: ${_this.notifyOffsets}, provider: ${_this.provider}, policyNo: ${_this.policyNo}, cost: ${_this.cost}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $ReminderInputCopyWith<$Res>  {
  factory $ReminderInputCopyWith(ReminderInput value, $Res Function(ReminderInput) _then) = _$ReminderInputCopyWithImpl;
@useResult
$Res call({
 ReminderKind kind, String label, DateTime dueDate, Recurrence recurrence, List<int>? notifyOffsets, String? provider, String? policyNo, double? cost, String? notes
});




}
/// @nodoc
class _$ReminderInputCopyWithImpl<$Res>
    implements $ReminderInputCopyWith<$Res> {
  _$ReminderInputCopyWithImpl(this._self, this._then);

  final ReminderInput _self;
  final $Res Function(ReminderInput) _then;

/// Create a copy of ReminderInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? label = null,Object? dueDate = null,Object? recurrence = null,Object? notifyOffsets = freezed,Object? provider = freezed,Object? policyNo = freezed,Object? cost = freezed,Object? notes = freezed,}) {
  return _then(ReminderInput(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ReminderKind,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as Recurrence,notifyOffsets: freezed == notifyOffsets ? _self.notifyOffsets : notifyOffsets // ignore: cast_nullable_to_non_nullable
as List<int>?,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,policyNo: freezed == policyNo ? _self.policyNo : policyNo // ignore: cast_nullable_to_non_nullable
as String?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderInput].
extension ReminderInputPatterns on ReminderInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderInput value)  $default,){
final _that = this;
switch (_that) {
case _ReminderInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderInput value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReminderKind kind,  String label,  DateTime dueDate,  Recurrence recurrence,  List<int>? notifyOffsets,  String? provider,  String? policyNo,  double? cost,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderInput() when $default != null:
return $default(_that.kind,_that.label,_that.dueDate,_that.recurrence,_that.notifyOffsets,_that.provider,_that.policyNo,_that.cost,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReminderKind kind,  String label,  DateTime dueDate,  Recurrence recurrence,  List<int>? notifyOffsets,  String? provider,  String? policyNo,  double? cost,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _ReminderInput():
return $default(_that.kind,_that.label,_that.dueDate,_that.recurrence,_that.notifyOffsets,_that.provider,_that.policyNo,_that.cost,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReminderKind kind,  String label,  DateTime dueDate,  Recurrence recurrence,  List<int>? notifyOffsets,  String? provider,  String? policyNo,  double? cost,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _ReminderInput() when $default != null:
return $default(_that.kind,_that.label,_that.dueDate,_that.recurrence,_that.notifyOffsets,_that.provider,_that.policyNo,_that.cost,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _ReminderInput implements ReminderInput {
  const _ReminderInput({required this.kind, required this.label, required this.dueDate, this.recurrence = Recurrence.none,  List<int>? notifyOffsets, this.provider, this.policyNo, this.cost, this.notes}): _notifyOffsets = notifyOffsets;
  

@override final  ReminderKind kind;
@override final  String label;
@override final  DateTime dueDate;
@override@JsonKey() final  Recurrence recurrence;
/// Days before due, largest first. Null = the backend default.
 final  List<int>? _notifyOffsets;
/// Days before due, largest first. Null = the backend default.
@override List<int>? get notifyOffsets {
  final value = _notifyOffsets;
  if (value == null) return null;
  if (_notifyOffsets is EqualUnmodifiableListView) return _notifyOffsets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? provider;
@override final  String? policyNo;
@override final  double? cost;
@override final  String? notes;

/// Create a copy of ReminderInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderInputCopyWith<_ReminderInput> get copyWith => __$ReminderInputCopyWithImpl<_ReminderInput>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderInput&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.label, label) || other.label == label)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&const DeepCollectionEquality().equals(other.notifyOffsets, _notifyOffsets)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.policyNo, policyNo) || other.policyNo == policyNo)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,kind,label,dueDate,recurrence,const DeepCollectionEquality().hash(_notifyOffsets),provider,policyNo,cost,notes);
}

@override
String toString() {
    return 'ReminderInput(kind: $kind, label: $label, dueDate: $dueDate, recurrence: $recurrence, notifyOffsets: $notifyOffsets, provider: $provider, policyNo: $policyNo, cost: $cost, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ReminderInputCopyWith<$Res> implements $ReminderInputCopyWith<$Res> {
  factory _$ReminderInputCopyWith(_ReminderInput value, $Res Function(_ReminderInput) _then) = __$ReminderInputCopyWithImpl;
@override @useResult
$Res call({
 ReminderKind kind, String label, DateTime dueDate, Recurrence recurrence, List<int>? notifyOffsets, String? provider, String? policyNo, double? cost, String? notes
});




}
/// @nodoc
class __$ReminderInputCopyWithImpl<$Res>
    implements _$ReminderInputCopyWith<$Res> {
  __$ReminderInputCopyWithImpl(this._self, this._then);

  final _ReminderInput _self;
  final $Res Function(_ReminderInput) _then;

/// Create a copy of ReminderInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? label = null,Object? dueDate = null,Object? recurrence = null,Object? notifyOffsets = freezed,Object? provider = freezed,Object? policyNo = freezed,Object? cost = freezed,Object? notes = freezed,}) {
  return _then(_ReminderInput(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ReminderKind,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as Recurrence,notifyOffsets: freezed == notifyOffsets ? _self._notifyOffsets : notifyOffsets // ignore: cast_nullable_to_non_nullable
as List<int>?,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,policyNo: freezed == policyNo ? _self.policyNo : policyNo // ignore: cast_nullable_to_non_nullable
as String?,cost: freezed == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as double?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PropertyEntry {

 String get label; String get value;
/// Create a copy of PropertyEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PropertyEntryCopyWith<PropertyEntry> get copyWith => _$PropertyEntryCopyWithImpl<PropertyEntry>(this as PropertyEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PropertyEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PropertyEntry&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.value, _this.value) || other.value == _this.value));
}


@override
int get hashCode {
  final _this = this as PropertyEntry;
  return Object.hash(runtimeType,_this.label,_this.value);
}

@override
String toString() {
  final _this = this as PropertyEntry;
  return 'PropertyEntry(label: ${_this.label}, value: ${_this.value})';
}


}

/// @nodoc
abstract mixin class $PropertyEntryCopyWith<$Res>  {
  factory $PropertyEntryCopyWith(PropertyEntry value, $Res Function(PropertyEntry) _then) = _$PropertyEntryCopyWithImpl;
@useResult
$Res call({
 String label, String value
});




}
/// @nodoc
class _$PropertyEntryCopyWithImpl<$Res>
    implements $PropertyEntryCopyWith<$Res> {
  _$PropertyEntryCopyWithImpl(this._self, this._then);

  final PropertyEntry _self;
  final $Res Function(PropertyEntry) _then;

/// Create a copy of PropertyEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? value = null,}) {
  return _then(PropertyEntry(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PropertyEntry].
extension PropertyEntryPatterns on PropertyEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PropertyEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PropertyEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PropertyEntry value)  $default,){
final _that = this;
switch (_that) {
case _PropertyEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PropertyEntry value)?  $default,){
final _that = this;
switch (_that) {
case _PropertyEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PropertyEntry() when $default != null:
return $default(_that.label,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String value)  $default,) {final _that = this;
switch (_that) {
case _PropertyEntry():
return $default(_that.label,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String value)?  $default,) {final _that = this;
switch (_that) {
case _PropertyEntry() when $default != null:
return $default(_that.label,_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _PropertyEntry implements PropertyEntry {
  const _PropertyEntry({required this.label, required this.value});
  

@override final  String label;
@override final  String value;

/// Create a copy of PropertyEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PropertyEntryCopyWith<_PropertyEntry> get copyWith => __$PropertyEntryCopyWithImpl<_PropertyEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PropertyEntry&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode {
    return Object.hash(runtimeType,label,value);
}

@override
String toString() {
    return 'PropertyEntry(label: $label, value: $value)';
}


}

/// @nodoc
abstract mixin class _$PropertyEntryCopyWith<$Res> implements $PropertyEntryCopyWith<$Res> {
  factory _$PropertyEntryCopyWith(_PropertyEntry value, $Res Function(_PropertyEntry) _then) = __$PropertyEntryCopyWithImpl;
@override @useResult
$Res call({
 String label, String value
});




}
/// @nodoc
class __$PropertyEntryCopyWithImpl<$Res>
    implements _$PropertyEntryCopyWith<$Res> {
  __$PropertyEntryCopyWithImpl(this._self, this._then);

  final _PropertyEntry _self;
  final $Res Function(_PropertyEntry) _then;

/// Create a copy of PropertyEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? value = null,}) {
  return _then(_PropertyEntry(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AssetDraft {

 String get name; AssetCategoryKind get category;/// Chosen catalog/built-in type; null with [customType] set = "Others".
 AssetCategory? get type; String? get customType;/// Slug whose spec fields the form showed (defaults to [type]'s).
 String? get specSlug; String? get roomName; String get brand; String get model; String get serialNo; String get price; String get store; DateTime? get purchaseDate;/// Values for the type's [PropertySpec] fields, keyed by spec label.
 Map<String, String> get specValues; List<PropertyEntry> get extraProperties;
/// Create a copy of AssetDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssetDraftCopyWith<AssetDraft> get copyWith => _$AssetDraftCopyWithImpl<AssetDraft>(this as AssetDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AssetDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssetDraft&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.customType, _this.customType) || other.customType == _this.customType)&&(identical(other.specSlug, _this.specSlug) || other.specSlug == _this.specSlug)&&(identical(other.roomName, _this.roomName) || other.roomName == _this.roomName)&&(identical(other.brand, _this.brand) || other.brand == _this.brand)&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.serialNo, _this.serialNo) || other.serialNo == _this.serialNo)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.store, _this.store) || other.store == _this.store)&&(identical(other.purchaseDate, _this.purchaseDate) || other.purchaseDate == _this.purchaseDate)&&const DeepCollectionEquality().equals(other.specValues, _this.specValues)&&const DeepCollectionEquality().equals(other.extraProperties, _this.extraProperties));
}


@override
int get hashCode {
  final _this = this as AssetDraft;
  return Object.hash(runtimeType,_this.name,_this.category,_this.type,_this.customType,_this.specSlug,_this.roomName,_this.brand,_this.model,_this.serialNo,_this.price,_this.store,_this.purchaseDate,const DeepCollectionEquality().hash(_this.specValues),const DeepCollectionEquality().hash(_this.extraProperties));
}

@override
String toString() {
  final _this = this as AssetDraft;
  return 'AssetDraft(name: ${_this.name}, category: ${_this.category}, type: ${_this.type}, customType: ${_this.customType}, specSlug: ${_this.specSlug}, roomName: ${_this.roomName}, brand: ${_this.brand}, model: ${_this.model}, serialNo: ${_this.serialNo}, price: ${_this.price}, store: ${_this.store}, purchaseDate: ${_this.purchaseDate}, specValues: ${_this.specValues}, extraProperties: ${_this.extraProperties})';
}


}

/// @nodoc
abstract mixin class $AssetDraftCopyWith<$Res>  {
  factory $AssetDraftCopyWith(AssetDraft value, $Res Function(AssetDraft) _then) = _$AssetDraftCopyWithImpl;
@useResult
$Res call({
 String name, AssetCategoryKind category, AssetCategory? type, String? customType, String? specSlug, String? roomName, String brand, String model, String serialNo, String price, String store, DateTime? purchaseDate, Map<String, String> specValues, List<PropertyEntry> extraProperties
});


$AssetCategoryCopyWith<$Res>? get type;

}
/// @nodoc
class _$AssetDraftCopyWithImpl<$Res>
    implements $AssetDraftCopyWith<$Res> {
  _$AssetDraftCopyWithImpl(this._self, this._then);

  final AssetDraft _self;
  final $Res Function(AssetDraft) _then;

/// Create a copy of AssetDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? category = null,Object? type = freezed,Object? customType = freezed,Object? specSlug = freezed,Object? roomName = freezed,Object? brand = null,Object? model = null,Object? serialNo = null,Object? price = null,Object? store = null,Object? purchaseDate = freezed,Object? specValues = null,Object? extraProperties = null,}) {
  return _then(AssetDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as AssetCategoryKind,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AssetCategory?,customType: freezed == customType ? _self.customType : customType // ignore: cast_nullable_to_non_nullable
as String?,specSlug: freezed == specSlug ? _self.specSlug : specSlug // ignore: cast_nullable_to_non_nullable
as String?,roomName: freezed == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String?,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,serialNo: null == serialNo ? _self.serialNo : serialNo // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as String,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,specValues: null == specValues ? _self.specValues : specValues // ignore: cast_nullable_to_non_nullable
as Map<String, String>,extraProperties: null == extraProperties ? _self.extraProperties : extraProperties // ignore: cast_nullable_to_non_nullable
as List<PropertyEntry>,
  ));
}
/// Create a copy of AssetDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssetCategoryCopyWith<$Res>? get type {
    if (_self.type == null) {
    return null;
  }

  return $AssetCategoryCopyWith<$Res>(_self.type!, (value) {
    return _then(_self.copyWith(type: value));
  });
}
}


/// Adds pattern-matching-related methods to [AssetDraft].
extension AssetDraftPatterns on AssetDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssetDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssetDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssetDraft value)  $default,){
final _that = this;
switch (_that) {
case _AssetDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssetDraft value)?  $default,){
final _that = this;
switch (_that) {
case _AssetDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  AssetCategoryKind category,  AssetCategory? type,  String? customType,  String? specSlug,  String? roomName,  String brand,  String model,  String serialNo,  String price,  String store,  DateTime? purchaseDate,  Map<String, String> specValues,  List<PropertyEntry> extraProperties)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssetDraft() when $default != null:
return $default(_that.name,_that.category,_that.type,_that.customType,_that.specSlug,_that.roomName,_that.brand,_that.model,_that.serialNo,_that.price,_that.store,_that.purchaseDate,_that.specValues,_that.extraProperties);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  AssetCategoryKind category,  AssetCategory? type,  String? customType,  String? specSlug,  String? roomName,  String brand,  String model,  String serialNo,  String price,  String store,  DateTime? purchaseDate,  Map<String, String> specValues,  List<PropertyEntry> extraProperties)  $default,) {final _that = this;
switch (_that) {
case _AssetDraft():
return $default(_that.name,_that.category,_that.type,_that.customType,_that.specSlug,_that.roomName,_that.brand,_that.model,_that.serialNo,_that.price,_that.store,_that.purchaseDate,_that.specValues,_that.extraProperties);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  AssetCategoryKind category,  AssetCategory? type,  String? customType,  String? specSlug,  String? roomName,  String brand,  String model,  String serialNo,  String price,  String store,  DateTime? purchaseDate,  Map<String, String> specValues,  List<PropertyEntry> extraProperties)?  $default,) {final _that = this;
switch (_that) {
case _AssetDraft() when $default != null:
return $default(_that.name,_that.category,_that.type,_that.customType,_that.specSlug,_that.roomName,_that.brand,_that.model,_that.serialNo,_that.price,_that.store,_that.purchaseDate,_that.specValues,_that.extraProperties);case _:
  return null;

}
}

}

/// @nodoc


class _AssetDraft extends AssetDraft {
  const _AssetDraft({required this.name, required this.category, this.type, this.customType, this.specSlug, this.roomName, this.brand = '', this.model = '', this.serialNo = '', this.price = '', this.store = '', this.purchaseDate,  Map<String, String> specValues = const <String, String>{},  List<PropertyEntry> extraProperties = const <PropertyEntry>[]}): _specValues = specValues,_extraProperties = extraProperties,super._();
  

@override final  String name;
@override final  AssetCategoryKind category;
/// Chosen catalog/built-in type; null with [customType] set = "Others".
@override final  AssetCategory? type;
@override final  String? customType;
/// Slug whose spec fields the form showed (defaults to [type]'s).
@override final  String? specSlug;
@override final  String? roomName;
@override@JsonKey() final  String brand;
@override@JsonKey() final  String model;
@override@JsonKey() final  String serialNo;
@override@JsonKey() final  String price;
@override@JsonKey() final  String store;
@override final  DateTime? purchaseDate;
/// Values for the type's [PropertySpec] fields, keyed by spec label.
 final  Map<String, String> _specValues;
/// Values for the type's [PropertySpec] fields, keyed by spec label.
@override@JsonKey() Map<String, String> get specValues {
  if (_specValues is EqualUnmodifiableMapView) return _specValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_specValues);
}

 final  List<PropertyEntry> _extraProperties;
@override@JsonKey() List<PropertyEntry> get extraProperties {
  if (_extraProperties is EqualUnmodifiableListView) return _extraProperties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_extraProperties);
}


/// Create a copy of AssetDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetDraftCopyWith<_AssetDraft> get copyWith => __$AssetDraftCopyWithImpl<_AssetDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetDraft&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.type, type) || other.type == type)&&(identical(other.customType, customType) || other.customType == customType)&&(identical(other.specSlug, specSlug) || other.specSlug == specSlug)&&(identical(other.roomName, roomName) || other.roomName == roomName)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.model, model) || other.model == model)&&(identical(other.serialNo, serialNo) || other.serialNo == serialNo)&&(identical(other.price, price) || other.price == price)&&(identical(other.store, store) || other.store == store)&&(identical(other.purchaseDate, purchaseDate) || other.purchaseDate == purchaseDate)&&const DeepCollectionEquality().equals(other.specValues, _specValues)&&const DeepCollectionEquality().equals(other.extraProperties, _extraProperties));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,category,type,customType,specSlug,roomName,brand,model,serialNo,price,store,purchaseDate,const DeepCollectionEquality().hash(_specValues),const DeepCollectionEquality().hash(_extraProperties));
}

@override
String toString() {
    return 'AssetDraft(name: $name, category: $category, type: $type, customType: $customType, specSlug: $specSlug, roomName: $roomName, brand: $brand, model: $model, serialNo: $serialNo, price: $price, store: $store, purchaseDate: $purchaseDate, specValues: $specValues, extraProperties: $extraProperties)';
}


}

/// @nodoc
abstract mixin class _$AssetDraftCopyWith<$Res> implements $AssetDraftCopyWith<$Res> {
  factory _$AssetDraftCopyWith(_AssetDraft value, $Res Function(_AssetDraft) _then) = __$AssetDraftCopyWithImpl;
@override @useResult
$Res call({
 String name, AssetCategoryKind category, AssetCategory? type, String? customType, String? specSlug, String? roomName, String brand, String model, String serialNo, String price, String store, DateTime? purchaseDate, Map<String, String> specValues, List<PropertyEntry> extraProperties
});


@override $AssetCategoryCopyWith<$Res>? get type;

}
/// @nodoc
class __$AssetDraftCopyWithImpl<$Res>
    implements _$AssetDraftCopyWith<$Res> {
  __$AssetDraftCopyWithImpl(this._self, this._then);

  final _AssetDraft _self;
  final $Res Function(_AssetDraft) _then;

/// Create a copy of AssetDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? category = null,Object? type = freezed,Object? customType = freezed,Object? specSlug = freezed,Object? roomName = freezed,Object? brand = null,Object? model = null,Object? serialNo = null,Object? price = null,Object? store = null,Object? purchaseDate = freezed,Object? specValues = null,Object? extraProperties = null,}) {
  return _then(_AssetDraft(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as AssetCategoryKind,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AssetCategory?,customType: freezed == customType ? _self.customType : customType // ignore: cast_nullable_to_non_nullable
as String?,specSlug: freezed == specSlug ? _self.specSlug : specSlug // ignore: cast_nullable_to_non_nullable
as String?,roomName: freezed == roomName ? _self.roomName : roomName // ignore: cast_nullable_to_non_nullable
as String?,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,serialNo: null == serialNo ? _self.serialNo : serialNo // ignore: cast_nullable_to_non_nullable
as String,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as String,purchaseDate: freezed == purchaseDate ? _self.purchaseDate : purchaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,specValues: null == specValues ? _self._specValues : specValues // ignore: cast_nullable_to_non_nullable
as Map<String, String>,extraProperties: null == extraProperties ? _self._extraProperties : extraProperties // ignore: cast_nullable_to_non_nullable
as List<PropertyEntry>,
  ));
}

/// Create a copy of AssetDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssetCategoryCopyWith<$Res>? get type {
    if (_self.type == null) {
    return null;
  }

  return $AssetCategoryCopyWith<$Res>(_self.type!, (value) {
    return _then(_self.copyWith(type: value));
  });
}
}

/// @nodoc
mixin _$ReminderDraft {

 ReminderKind get kind; DateTime get dueDate; Recurrence get recurrence; Set<int> get notifyOffsets; String get label; String get provider; String get policyNo; String get cost; String get notes;
/// Create a copy of ReminderDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReminderDraftCopyWith<ReminderDraft> get copyWith => _$ReminderDraftCopyWithImpl<ReminderDraft>(this as ReminderDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReminderDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReminderDraft&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.recurrence, _this.recurrence) || other.recurrence == _this.recurrence)&&const DeepCollectionEquality().equals(other.notifyOffsets, _this.notifyOffsets)&&(identical(other.label, _this.label) || other.label == _this.label)&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.policyNo, _this.policyNo) || other.policyNo == _this.policyNo)&&(identical(other.cost, _this.cost) || other.cost == _this.cost)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}


@override
int get hashCode {
  final _this = this as ReminderDraft;
  return Object.hash(runtimeType,_this.kind,_this.dueDate,_this.recurrence,const DeepCollectionEquality().hash(_this.notifyOffsets),_this.label,_this.provider,_this.policyNo,_this.cost,_this.notes);
}

@override
String toString() {
  final _this = this as ReminderDraft;
  return 'ReminderDraft(kind: ${_this.kind}, dueDate: ${_this.dueDate}, recurrence: ${_this.recurrence}, notifyOffsets: ${_this.notifyOffsets}, label: ${_this.label}, provider: ${_this.provider}, policyNo: ${_this.policyNo}, cost: ${_this.cost}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $ReminderDraftCopyWith<$Res>  {
  factory $ReminderDraftCopyWith(ReminderDraft value, $Res Function(ReminderDraft) _then) = _$ReminderDraftCopyWithImpl;
@useResult
$Res call({
 ReminderKind kind, DateTime dueDate, Recurrence recurrence, Set<int> notifyOffsets, String label, String provider, String policyNo, String cost, String notes
});




}
/// @nodoc
class _$ReminderDraftCopyWithImpl<$Res>
    implements $ReminderDraftCopyWith<$Res> {
  _$ReminderDraftCopyWithImpl(this._self, this._then);

  final ReminderDraft _self;
  final $Res Function(ReminderDraft) _then;

/// Create a copy of ReminderDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? dueDate = null,Object? recurrence = null,Object? notifyOffsets = null,Object? label = null,Object? provider = null,Object? policyNo = null,Object? cost = null,Object? notes = null,}) {
  return _then(ReminderDraft(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ReminderKind,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as Recurrence,notifyOffsets: null == notifyOffsets ? _self.notifyOffsets : notifyOffsets // ignore: cast_nullable_to_non_nullable
as Set<int>,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,policyNo: null == policyNo ? _self.policyNo : policyNo // ignore: cast_nullable_to_non_nullable
as String,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReminderDraft].
extension ReminderDraftPatterns on ReminderDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReminderDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReminderDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReminderDraft value)  $default,){
final _that = this;
switch (_that) {
case _ReminderDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReminderDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ReminderDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReminderKind kind,  DateTime dueDate,  Recurrence recurrence,  Set<int> notifyOffsets,  String label,  String provider,  String policyNo,  String cost,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReminderDraft() when $default != null:
return $default(_that.kind,_that.dueDate,_that.recurrence,_that.notifyOffsets,_that.label,_that.provider,_that.policyNo,_that.cost,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReminderKind kind,  DateTime dueDate,  Recurrence recurrence,  Set<int> notifyOffsets,  String label,  String provider,  String policyNo,  String cost,  String notes)  $default,) {final _that = this;
switch (_that) {
case _ReminderDraft():
return $default(_that.kind,_that.dueDate,_that.recurrence,_that.notifyOffsets,_that.label,_that.provider,_that.policyNo,_that.cost,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReminderKind kind,  DateTime dueDate,  Recurrence recurrence,  Set<int> notifyOffsets,  String label,  String provider,  String policyNo,  String cost,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _ReminderDraft() when $default != null:
return $default(_that.kind,_that.dueDate,_that.recurrence,_that.notifyOffsets,_that.label,_that.provider,_that.policyNo,_that.cost,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _ReminderDraft extends ReminderDraft {
  const _ReminderDraft({required this.kind, required this.dueDate, required this.recurrence, required  Set<int> notifyOffsets, this.label = '', this.provider = '', this.policyNo = '', this.cost = '', this.notes = ''}): _notifyOffsets = notifyOffsets,super._();
  

@override final  ReminderKind kind;
@override final  DateTime dueDate;
@override final  Recurrence recurrence;
 final  Set<int> _notifyOffsets;
@override Set<int> get notifyOffsets {
  if (_notifyOffsets is EqualUnmodifiableSetView) return _notifyOffsets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_notifyOffsets);
}

@override@JsonKey() final  String label;
@override@JsonKey() final  String provider;
@override@JsonKey() final  String policyNo;
@override@JsonKey() final  String cost;
@override@JsonKey() final  String notes;

/// Create a copy of ReminderDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReminderDraftCopyWith<_ReminderDraft> get copyWith => __$ReminderDraftCopyWithImpl<_ReminderDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReminderDraft&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.recurrence, recurrence) || other.recurrence == recurrence)&&const DeepCollectionEquality().equals(other.notifyOffsets, _notifyOffsets)&&(identical(other.label, label) || other.label == label)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.policyNo, policyNo) || other.policyNo == policyNo)&&(identical(other.cost, cost) || other.cost == cost)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,kind,dueDate,recurrence,const DeepCollectionEquality().hash(_notifyOffsets),label,provider,policyNo,cost,notes);
}

@override
String toString() {
    return 'ReminderDraft(kind: $kind, dueDate: $dueDate, recurrence: $recurrence, notifyOffsets: $notifyOffsets, label: $label, provider: $provider, policyNo: $policyNo, cost: $cost, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$ReminderDraftCopyWith<$Res> implements $ReminderDraftCopyWith<$Res> {
  factory _$ReminderDraftCopyWith(_ReminderDraft value, $Res Function(_ReminderDraft) _then) = __$ReminderDraftCopyWithImpl;
@override @useResult
$Res call({
 ReminderKind kind, DateTime dueDate, Recurrence recurrence, Set<int> notifyOffsets, String label, String provider, String policyNo, String cost, String notes
});




}
/// @nodoc
class __$ReminderDraftCopyWithImpl<$Res>
    implements _$ReminderDraftCopyWith<$Res> {
  __$ReminderDraftCopyWithImpl(this._self, this._then);

  final _ReminderDraft _self;
  final $Res Function(_ReminderDraft) _then;

/// Create a copy of ReminderDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? dueDate = null,Object? recurrence = null,Object? notifyOffsets = null,Object? label = null,Object? provider = null,Object? policyNo = null,Object? cost = null,Object? notes = null,}) {
  return _then(_ReminderDraft(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ReminderKind,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as Recurrence,notifyOffsets: null == notifyOffsets ? _self._notifyOffsets : notifyOffsets // ignore: cast_nullable_to_non_nullable
as Set<int>,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,policyNo: null == policyNo ? _self.policyNo : policyNo // ignore: cast_nullable_to_non_nullable
as String,cost: null == cost ? _self.cost : cost // ignore: cast_nullable_to_non_nullable
as String,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
