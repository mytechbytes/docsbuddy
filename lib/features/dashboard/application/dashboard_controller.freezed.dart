// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardFilter {

/// Kind filter (empty = everything).
 Set<ReminderKind> get kinds;/// Group the list by asset (design 01) instead of a flat list.
 bool get groupByAsset;
/// Create a copy of DashboardFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardFilterCopyWith<DashboardFilter> get copyWith => _$DashboardFilterCopyWithImpl<DashboardFilter>(this as DashboardFilter, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardFilter;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardFilter&&const DeepCollectionEquality().equals(other.kinds, _this.kinds)&&(identical(other.groupByAsset, _this.groupByAsset) || other.groupByAsset == _this.groupByAsset));
}


@override
int get hashCode {
  final _this = this as DashboardFilter;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.kinds),_this.groupByAsset);
}

@override
String toString() {
  final _this = this as DashboardFilter;
  return 'DashboardFilter(kinds: ${_this.kinds}, groupByAsset: ${_this.groupByAsset})';
}


}

/// @nodoc
abstract mixin class $DashboardFilterCopyWith<$Res>  {
  factory $DashboardFilterCopyWith(DashboardFilter value, $Res Function(DashboardFilter) _then) = _$DashboardFilterCopyWithImpl;
@useResult
$Res call({
 Set<ReminderKind> kinds, bool groupByAsset
});




}
/// @nodoc
class _$DashboardFilterCopyWithImpl<$Res>
    implements $DashboardFilterCopyWith<$Res> {
  _$DashboardFilterCopyWithImpl(this._self, this._then);

  final DashboardFilter _self;
  final $Res Function(DashboardFilter) _then;

/// Create a copy of DashboardFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kinds = null,Object? groupByAsset = null,}) {
  return _then(DashboardFilter(
kinds: null == kinds ? _self.kinds : kinds // ignore: cast_nullable_to_non_nullable
as Set<ReminderKind>,groupByAsset: null == groupByAsset ? _self.groupByAsset : groupByAsset // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardFilter].
extension DashboardFilterPatterns on DashboardFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardFilter value)  $default,){
final _that = this;
switch (_that) {
case _DashboardFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardFilter value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<ReminderKind> kinds,  bool groupByAsset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardFilter() when $default != null:
return $default(_that.kinds,_that.groupByAsset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<ReminderKind> kinds,  bool groupByAsset)  $default,) {final _that = this;
switch (_that) {
case _DashboardFilter():
return $default(_that.kinds,_that.groupByAsset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<ReminderKind> kinds,  bool groupByAsset)?  $default,) {final _that = this;
switch (_that) {
case _DashboardFilter() when $default != null:
return $default(_that.kinds,_that.groupByAsset);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardFilter implements DashboardFilter {
  const _DashboardFilter({ Set<ReminderKind> kinds = const <ReminderKind>{}, this.groupByAsset = false}): _kinds = kinds;
  

/// Kind filter (empty = everything).
 final  Set<ReminderKind> _kinds;
/// Kind filter (empty = everything).
@override@JsonKey() Set<ReminderKind> get kinds {
  if (_kinds is EqualUnmodifiableSetView) return _kinds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_kinds);
}

/// Group the list by asset (design 01) instead of a flat list.
@override@JsonKey() final  bool groupByAsset;

/// Create a copy of DashboardFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardFilterCopyWith<_DashboardFilter> get copyWith => __$DashboardFilterCopyWithImpl<_DashboardFilter>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardFilter&&const DeepCollectionEquality().equals(other.kinds, _kinds)&&(identical(other.groupByAsset, groupByAsset) || other.groupByAsset == groupByAsset));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_kinds),groupByAsset);
}

@override
String toString() {
    return 'DashboardFilter(kinds: $kinds, groupByAsset: $groupByAsset)';
}


}

/// @nodoc
abstract mixin class _$DashboardFilterCopyWith<$Res> implements $DashboardFilterCopyWith<$Res> {
  factory _$DashboardFilterCopyWith(_DashboardFilter value, $Res Function(_DashboardFilter) _then) = __$DashboardFilterCopyWithImpl;
@override @useResult
$Res call({
 Set<ReminderKind> kinds, bool groupByAsset
});




}
/// @nodoc
class __$DashboardFilterCopyWithImpl<$Res>
    implements _$DashboardFilterCopyWith<$Res> {
  __$DashboardFilterCopyWithImpl(this._self, this._then);

  final _DashboardFilter _self;
  final $Res Function(_DashboardFilter) _then;

/// Create a copy of DashboardFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kinds = null,Object? groupByAsset = null,}) {
  return _then(_DashboardFilter(
kinds: null == kinds ? _self._kinds : kinds // ignore: cast_nullable_to_non_nullable
as Set<ReminderKind>,groupByAsset: null == groupByAsset ? _self.groupByAsset : groupByAsset // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$DashboardView {

/// Service count per stat card.
 Map<ReminderFilter, int> get counts; int get assetCount;/// Filtered, soonest first.
 List<Reminder> get visible;/// [visible] bucketed by asset (used when grouping).
 List<List<Reminder>> get groups; Map<String, Asset> get assetsById; DashboardFilter get filter;
/// Create a copy of DashboardView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardViewCopyWith<DashboardView> get copyWith => _$DashboardViewCopyWithImpl<DashboardView>(this as DashboardView, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardView;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardView&&const DeepCollectionEquality().equals(other.counts, _this.counts)&&(identical(other.assetCount, _this.assetCount) || other.assetCount == _this.assetCount)&&const DeepCollectionEquality().equals(other.visible, _this.visible)&&const DeepCollectionEquality().equals(other.groups, _this.groups)&&const DeepCollectionEquality().equals(other.assetsById, _this.assetsById)&&(identical(other.filter, _this.filter) || other.filter == _this.filter));
}


@override
int get hashCode {
  final _this = this as DashboardView;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.counts),_this.assetCount,const DeepCollectionEquality().hash(_this.visible),const DeepCollectionEquality().hash(_this.groups),const DeepCollectionEquality().hash(_this.assetsById),_this.filter);
}

@override
String toString() {
  final _this = this as DashboardView;
  return 'DashboardView(counts: ${_this.counts}, assetCount: ${_this.assetCount}, visible: ${_this.visible}, groups: ${_this.groups}, assetsById: ${_this.assetsById}, filter: ${_this.filter})';
}


}

/// @nodoc
abstract mixin class $DashboardViewCopyWith<$Res>  {
  factory $DashboardViewCopyWith(DashboardView value, $Res Function(DashboardView) _then) = _$DashboardViewCopyWithImpl;
@useResult
$Res call({
 Map<ReminderFilter, int> counts, int assetCount, List<Reminder> visible, List<List<Reminder>> groups, Map<String, Asset> assetsById, DashboardFilter filter
});


$DashboardFilterCopyWith<$Res> get filter;

}
/// @nodoc
class _$DashboardViewCopyWithImpl<$Res>
    implements $DashboardViewCopyWith<$Res> {
  _$DashboardViewCopyWithImpl(this._self, this._then);

  final DashboardView _self;
  final $Res Function(DashboardView) _then;

/// Create a copy of DashboardView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? counts = null,Object? assetCount = null,Object? visible = null,Object? groups = null,Object? assetsById = null,Object? filter = null,}) {
  return _then(DashboardView(
counts: null == counts ? _self.counts : counts // ignore: cast_nullable_to_non_nullable
as Map<ReminderFilter, int>,assetCount: null == assetCount ? _self.assetCount : assetCount // ignore: cast_nullable_to_non_nullable
as int,visible: null == visible ? _self.visible : visible // ignore: cast_nullable_to_non_nullable
as List<Reminder>,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<List<Reminder>>,assetsById: null == assetsById ? _self.assetsById : assetsById // ignore: cast_nullable_to_non_nullable
as Map<String, Asset>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as DashboardFilter,
  ));
}
/// Create a copy of DashboardView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardFilterCopyWith<$Res> get filter {
  
  return $DashboardFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}


/// Adds pattern-matching-related methods to [DashboardView].
extension DashboardViewPatterns on DashboardView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardView value)  $default,){
final _that = this;
switch (_that) {
case _DashboardView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardView value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<ReminderFilter, int> counts,  int assetCount,  List<Reminder> visible,  List<List<Reminder>> groups,  Map<String, Asset> assetsById,  DashboardFilter filter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardView() when $default != null:
return $default(_that.counts,_that.assetCount,_that.visible,_that.groups,_that.assetsById,_that.filter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<ReminderFilter, int> counts,  int assetCount,  List<Reminder> visible,  List<List<Reminder>> groups,  Map<String, Asset> assetsById,  DashboardFilter filter)  $default,) {final _that = this;
switch (_that) {
case _DashboardView():
return $default(_that.counts,_that.assetCount,_that.visible,_that.groups,_that.assetsById,_that.filter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<ReminderFilter, int> counts,  int assetCount,  List<Reminder> visible,  List<List<Reminder>> groups,  Map<String, Asset> assetsById,  DashboardFilter filter)?  $default,) {final _that = this;
switch (_that) {
case _DashboardView() when $default != null:
return $default(_that.counts,_that.assetCount,_that.visible,_that.groups,_that.assetsById,_that.filter);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardView implements DashboardView {
  const _DashboardView({required  Map<ReminderFilter, int> counts, required this.assetCount, required  List<Reminder> visible, required  List<List<Reminder>> groups, required  Map<String, Asset> assetsById, required this.filter}): _counts = counts,_visible = visible,_groups = groups,_assetsById = assetsById;
  

/// Service count per stat card.
 final  Map<ReminderFilter, int> _counts;
/// Service count per stat card.
@override Map<ReminderFilter, int> get counts {
  if (_counts is EqualUnmodifiableMapView) return _counts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_counts);
}

@override final  int assetCount;
/// Filtered, soonest first.
 final  List<Reminder> _visible;
/// Filtered, soonest first.
@override List<Reminder> get visible {
  if (_visible is EqualUnmodifiableListView) return _visible;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_visible);
}

/// [visible] bucketed by asset (used when grouping).
 final  List<List<Reminder>> _groups;
/// [visible] bucketed by asset (used when grouping).
@override List<List<Reminder>> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

 final  Map<String, Asset> _assetsById;
@override Map<String, Asset> get assetsById {
  if (_assetsById is EqualUnmodifiableMapView) return _assetsById;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_assetsById);
}

@override final  DashboardFilter filter;

/// Create a copy of DashboardView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardViewCopyWith<_DashboardView> get copyWith => __$DashboardViewCopyWithImpl<_DashboardView>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardView&&const DeepCollectionEquality().equals(other.counts, _counts)&&(identical(other.assetCount, assetCount) || other.assetCount == assetCount)&&const DeepCollectionEquality().equals(other.visible, _visible)&&const DeepCollectionEquality().equals(other.groups, _groups)&&const DeepCollectionEquality().equals(other.assetsById, _assetsById)&&(identical(other.filter, filter) || other.filter == filter));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_counts),assetCount,const DeepCollectionEquality().hash(_visible),const DeepCollectionEquality().hash(_groups),const DeepCollectionEquality().hash(_assetsById),filter);
}

@override
String toString() {
    return 'DashboardView(counts: $counts, assetCount: $assetCount, visible: $visible, groups: $groups, assetsById: $assetsById, filter: $filter)';
}


}

/// @nodoc
abstract mixin class _$DashboardViewCopyWith<$Res> implements $DashboardViewCopyWith<$Res> {
  factory _$DashboardViewCopyWith(_DashboardView value, $Res Function(_DashboardView) _then) = __$DashboardViewCopyWithImpl;
@override @useResult
$Res call({
 Map<ReminderFilter, int> counts, int assetCount, List<Reminder> visible, List<List<Reminder>> groups, Map<String, Asset> assetsById, DashboardFilter filter
});


@override $DashboardFilterCopyWith<$Res> get filter;

}
/// @nodoc
class __$DashboardViewCopyWithImpl<$Res>
    implements _$DashboardViewCopyWith<$Res> {
  __$DashboardViewCopyWithImpl(this._self, this._then);

  final _DashboardView _self;
  final $Res Function(_DashboardView) _then;

/// Create a copy of DashboardView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? counts = null,Object? assetCount = null,Object? visible = null,Object? groups = null,Object? assetsById = null,Object? filter = null,}) {
  return _then(_DashboardView(
counts: null == counts ? _self._counts : counts // ignore: cast_nullable_to_non_nullable
as Map<ReminderFilter, int>,assetCount: null == assetCount ? _self.assetCount : assetCount // ignore: cast_nullable_to_non_nullable
as int,visible: null == visible ? _self._visible : visible // ignore: cast_nullable_to_non_nullable
as List<Reminder>,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<List<Reminder>>,assetsById: null == assetsById ? _self._assetsById : assetsById // ignore: cast_nullable_to_non_nullable
as Map<String, Asset>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as DashboardFilter,
  ));
}

/// Create a copy of DashboardView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DashboardFilterCopyWith<$Res> get filter {
  
  return $DashboardFilterCopyWith<$Res>(_self.filter, (value) {
    return _then(_self.copyWith(filter: value));
  });
}
}

// dart format on
