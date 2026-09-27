// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_prefs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationPrefs {

 List<String> get channels;/// Days-before-due used to pre-fill new reminders, largest first.
 List<int> get defaultOffsets;/// Quiet hours as `HH:mm` local time.
 String get quietStart; String get quietEnd;
/// Create a copy of NotificationPrefs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPrefsCopyWith<NotificationPrefs> get copyWith => _$NotificationPrefsCopyWithImpl<NotificationPrefs>(this as NotificationPrefs, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as NotificationPrefs;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPrefs&&const DeepCollectionEquality().equals(other.channels, _this.channels)&&const DeepCollectionEquality().equals(other.defaultOffsets, _this.defaultOffsets)&&(identical(other.quietStart, _this.quietStart) || other.quietStart == _this.quietStart)&&(identical(other.quietEnd, _this.quietEnd) || other.quietEnd == _this.quietEnd));
}


@override
int get hashCode {
  final _this = this as NotificationPrefs;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.channels),const DeepCollectionEquality().hash(_this.defaultOffsets),_this.quietStart,_this.quietEnd);
}

@override
String toString() {
  final _this = this as NotificationPrefs;
  return 'NotificationPrefs(channels: ${_this.channels}, defaultOffsets: ${_this.defaultOffsets}, quietStart: ${_this.quietStart}, quietEnd: ${_this.quietEnd})';
}


}

/// @nodoc
abstract mixin class $NotificationPrefsCopyWith<$Res>  {
  factory $NotificationPrefsCopyWith(NotificationPrefs value, $Res Function(NotificationPrefs) _then) = _$NotificationPrefsCopyWithImpl;
@useResult
$Res call({
 List<String> channels, List<int> defaultOffsets, String quietStart, String quietEnd
});




}
/// @nodoc
class _$NotificationPrefsCopyWithImpl<$Res>
    implements $NotificationPrefsCopyWith<$Res> {
  _$NotificationPrefsCopyWithImpl(this._self, this._then);

  final NotificationPrefs _self;
  final $Res Function(NotificationPrefs) _then;

/// Create a copy of NotificationPrefs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channels = null,Object? defaultOffsets = null,Object? quietStart = null,Object? quietEnd = null,}) {
  return _then(NotificationPrefs(
channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as List<String>,defaultOffsets: null == defaultOffsets ? _self.defaultOffsets : defaultOffsets // ignore: cast_nullable_to_non_nullable
as List<int>,quietStart: null == quietStart ? _self.quietStart : quietStart // ignore: cast_nullable_to_non_nullable
as String,quietEnd: null == quietEnd ? _self.quietEnd : quietEnd // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationPrefs].
extension NotificationPrefsPatterns on NotificationPrefs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPrefs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPrefs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPrefs value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPrefs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPrefs value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPrefs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> channels,  List<int> defaultOffsets,  String quietStart,  String quietEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPrefs() when $default != null:
return $default(_that.channels,_that.defaultOffsets,_that.quietStart,_that.quietEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> channels,  List<int> defaultOffsets,  String quietStart,  String quietEnd)  $default,) {final _that = this;
switch (_that) {
case _NotificationPrefs():
return $default(_that.channels,_that.defaultOffsets,_that.quietStart,_that.quietEnd);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> channels,  List<int> defaultOffsets,  String quietStart,  String quietEnd)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPrefs() when $default != null:
return $default(_that.channels,_that.defaultOffsets,_that.quietStart,_that.quietEnd);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationPrefs extends NotificationPrefs {
  const _NotificationPrefs({ List<String> channels = const <String>['push', 'local'],  List<int> defaultOffsets = const <int>[30, 7, 1], this.quietStart = '22:00', this.quietEnd = '07:00'}): _channels = channels,_defaultOffsets = defaultOffsets,super._();
  

 final  List<String> _channels;
@override@JsonKey() List<String> get channels {
  if (_channels is EqualUnmodifiableListView) return _channels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_channels);
}

/// Days-before-due used to pre-fill new reminders, largest first.
 final  List<int> _defaultOffsets;
/// Days-before-due used to pre-fill new reminders, largest first.
@override@JsonKey() List<int> get defaultOffsets {
  if (_defaultOffsets is EqualUnmodifiableListView) return _defaultOffsets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_defaultOffsets);
}

/// Quiet hours as `HH:mm` local time.
@override@JsonKey() final  String quietStart;
@override@JsonKey() final  String quietEnd;

/// Create a copy of NotificationPrefs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPrefsCopyWith<_NotificationPrefs> get copyWith => __$NotificationPrefsCopyWithImpl<_NotificationPrefs>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPrefs&&const DeepCollectionEquality().equals(other.channels, _channels)&&const DeepCollectionEquality().equals(other.defaultOffsets, _defaultOffsets)&&(identical(other.quietStart, quietStart) || other.quietStart == quietStart)&&(identical(other.quietEnd, quietEnd) || other.quietEnd == quietEnd));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_channels),const DeepCollectionEquality().hash(_defaultOffsets),quietStart,quietEnd);
}

@override
String toString() {
    return 'NotificationPrefs(channels: $channels, defaultOffsets: $defaultOffsets, quietStart: $quietStart, quietEnd: $quietEnd)';
}


}

/// @nodoc
abstract mixin class _$NotificationPrefsCopyWith<$Res> implements $NotificationPrefsCopyWith<$Res> {
  factory _$NotificationPrefsCopyWith(_NotificationPrefs value, $Res Function(_NotificationPrefs) _then) = __$NotificationPrefsCopyWithImpl;
@override @useResult
$Res call({
 List<String> channels, List<int> defaultOffsets, String quietStart, String quietEnd
});




}
/// @nodoc
class __$NotificationPrefsCopyWithImpl<$Res>
    implements _$NotificationPrefsCopyWith<$Res> {
  __$NotificationPrefsCopyWithImpl(this._self, this._then);

  final _NotificationPrefs _self;
  final $Res Function(_NotificationPrefs) _then;

/// Create a copy of NotificationPrefs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channels = null,Object? defaultOffsets = null,Object? quietStart = null,Object? quietEnd = null,}) {
  return _then(_NotificationPrefs(
channels: null == channels ? _self._channels : channels // ignore: cast_nullable_to_non_nullable
as List<String>,defaultOffsets: null == defaultOffsets ? _self._defaultOffsets : defaultOffsets // ignore: cast_nullable_to_non_nullable
as List<int>,quietStart: null == quietStart ? _self.quietStart : quietStart // ignore: cast_nullable_to_non_nullable
as String,quietEnd: null == quietEnd ? _self.quietEnd : quietEnd // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
