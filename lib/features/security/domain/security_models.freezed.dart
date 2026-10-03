// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'security_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TotpEnrollment {

 String get factorId; String get secret;/// `otpauth://` URI for the authenticator-app QR.
 String get uri;
/// Create a copy of TotpEnrollment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TotpEnrollmentCopyWith<TotpEnrollment> get copyWith => _$TotpEnrollmentCopyWithImpl<TotpEnrollment>(this as TotpEnrollment, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TotpEnrollment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TotpEnrollment&&(identical(other.factorId, _this.factorId) || other.factorId == _this.factorId)&&(identical(other.secret, _this.secret) || other.secret == _this.secret)&&(identical(other.uri, _this.uri) || other.uri == _this.uri));
}


@override
int get hashCode {
  final _this = this as TotpEnrollment;
  return Object.hash(runtimeType,_this.factorId,_this.secret,_this.uri);
}

@override
String toString() {
  final _this = this as TotpEnrollment;
  return 'TotpEnrollment(factorId: ${_this.factorId}, secret: ${_this.secret}, uri: ${_this.uri})';
}


}

/// @nodoc
abstract mixin class $TotpEnrollmentCopyWith<$Res>  {
  factory $TotpEnrollmentCopyWith(TotpEnrollment value, $Res Function(TotpEnrollment) _then) = _$TotpEnrollmentCopyWithImpl;
@useResult
$Res call({
 String factorId, String secret, String uri
});




}
/// @nodoc
class _$TotpEnrollmentCopyWithImpl<$Res>
    implements $TotpEnrollmentCopyWith<$Res> {
  _$TotpEnrollmentCopyWithImpl(this._self, this._then);

  final TotpEnrollment _self;
  final $Res Function(TotpEnrollment) _then;

/// Create a copy of TotpEnrollment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? factorId = null,Object? secret = null,Object? uri = null,}) {
  return _then(TotpEnrollment(
factorId: null == factorId ? _self.factorId : factorId // ignore: cast_nullable_to_non_nullable
as String,secret: null == secret ? _self.secret : secret // ignore: cast_nullable_to_non_nullable
as String,uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TotpEnrollment].
extension TotpEnrollmentPatterns on TotpEnrollment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TotpEnrollment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TotpEnrollment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TotpEnrollment value)  $default,){
final _that = this;
switch (_that) {
case _TotpEnrollment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TotpEnrollment value)?  $default,){
final _that = this;
switch (_that) {
case _TotpEnrollment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String factorId,  String secret,  String uri)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TotpEnrollment() when $default != null:
return $default(_that.factorId,_that.secret,_that.uri);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String factorId,  String secret,  String uri)  $default,) {final _that = this;
switch (_that) {
case _TotpEnrollment():
return $default(_that.factorId,_that.secret,_that.uri);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String factorId,  String secret,  String uri)?  $default,) {final _that = this;
switch (_that) {
case _TotpEnrollment() when $default != null:
return $default(_that.factorId,_that.secret,_that.uri);case _:
  return null;

}
}

}

/// @nodoc


class _TotpEnrollment implements TotpEnrollment {
  const _TotpEnrollment({required this.factorId, required this.secret, required this.uri});
  

@override final  String factorId;
@override final  String secret;
/// `otpauth://` URI for the authenticator-app QR.
@override final  String uri;

/// Create a copy of TotpEnrollment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TotpEnrollmentCopyWith<_TotpEnrollment> get copyWith => __$TotpEnrollmentCopyWithImpl<_TotpEnrollment>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TotpEnrollment&&(identical(other.factorId, factorId) || other.factorId == factorId)&&(identical(other.secret, secret) || other.secret == secret)&&(identical(other.uri, uri) || other.uri == uri));
}


@override
int get hashCode {
    return Object.hash(runtimeType,factorId,secret,uri);
}

@override
String toString() {
    return 'TotpEnrollment(factorId: $factorId, secret: $secret, uri: $uri)';
}


}

/// @nodoc
abstract mixin class _$TotpEnrollmentCopyWith<$Res> implements $TotpEnrollmentCopyWith<$Res> {
  factory _$TotpEnrollmentCopyWith(_TotpEnrollment value, $Res Function(_TotpEnrollment) _then) = __$TotpEnrollmentCopyWithImpl;
@override @useResult
$Res call({
 String factorId, String secret, String uri
});




}
/// @nodoc
class __$TotpEnrollmentCopyWithImpl<$Res>
    implements _$TotpEnrollmentCopyWith<$Res> {
  __$TotpEnrollmentCopyWithImpl(this._self, this._then);

  final _TotpEnrollment _self;
  final $Res Function(_TotpEnrollment) _then;

/// Create a copy of TotpEnrollment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? factorId = null,Object? secret = null,Object? uri = null,}) {
  return _then(_TotpEnrollment(
factorId: null == factorId ? _self.factorId : factorId // ignore: cast_nullable_to_non_nullable
as String,secret: null == secret ? _self.secret : secret // ignore: cast_nullable_to_non_nullable
as String,uri: null == uri ? _self.uri : uri // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SecurityStatus {

 String? get totpFactorId; DateTime? get enrolledAt;
/// Create a copy of SecurityStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecurityStatusCopyWith<SecurityStatus> get copyWith => _$SecurityStatusCopyWithImpl<SecurityStatus>(this as SecurityStatus, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SecurityStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecurityStatus&&(identical(other.totpFactorId, _this.totpFactorId) || other.totpFactorId == _this.totpFactorId)&&(identical(other.enrolledAt, _this.enrolledAt) || other.enrolledAt == _this.enrolledAt));
}


@override
int get hashCode {
  final _this = this as SecurityStatus;
  return Object.hash(runtimeType,_this.totpFactorId,_this.enrolledAt);
}

@override
String toString() {
  final _this = this as SecurityStatus;
  return 'SecurityStatus(totpFactorId: ${_this.totpFactorId}, enrolledAt: ${_this.enrolledAt})';
}


}

/// @nodoc
abstract mixin class $SecurityStatusCopyWith<$Res>  {
  factory $SecurityStatusCopyWith(SecurityStatus value, $Res Function(SecurityStatus) _then) = _$SecurityStatusCopyWithImpl;
@useResult
$Res call({
 String? totpFactorId, DateTime? enrolledAt
});




}
/// @nodoc
class _$SecurityStatusCopyWithImpl<$Res>
    implements $SecurityStatusCopyWith<$Res> {
  _$SecurityStatusCopyWithImpl(this._self, this._then);

  final SecurityStatus _self;
  final $Res Function(SecurityStatus) _then;

/// Create a copy of SecurityStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totpFactorId = freezed,Object? enrolledAt = freezed,}) {
  return _then(SecurityStatus(
totpFactorId: freezed == totpFactorId ? _self.totpFactorId : totpFactorId // ignore: cast_nullable_to_non_nullable
as String?,enrolledAt: freezed == enrolledAt ? _self.enrolledAt : enrolledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SecurityStatus].
extension SecurityStatusPatterns on SecurityStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SecurityStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SecurityStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SecurityStatus value)  $default,){
final _that = this;
switch (_that) {
case _SecurityStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SecurityStatus value)?  $default,){
final _that = this;
switch (_that) {
case _SecurityStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? totpFactorId,  DateTime? enrolledAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SecurityStatus() when $default != null:
return $default(_that.totpFactorId,_that.enrolledAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? totpFactorId,  DateTime? enrolledAt)  $default,) {final _that = this;
switch (_that) {
case _SecurityStatus():
return $default(_that.totpFactorId,_that.enrolledAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? totpFactorId,  DateTime? enrolledAt)?  $default,) {final _that = this;
switch (_that) {
case _SecurityStatus() when $default != null:
return $default(_that.totpFactorId,_that.enrolledAt);case _:
  return null;

}
}

}

/// @nodoc


class _SecurityStatus extends SecurityStatus {
  const _SecurityStatus({this.totpFactorId, this.enrolledAt}): super._();
  

@override final  String? totpFactorId;
@override final  DateTime? enrolledAt;

/// Create a copy of SecurityStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecurityStatusCopyWith<_SecurityStatus> get copyWith => __$SecurityStatusCopyWithImpl<_SecurityStatus>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecurityStatus&&(identical(other.totpFactorId, totpFactorId) || other.totpFactorId == totpFactorId)&&(identical(other.enrolledAt, enrolledAt) || other.enrolledAt == enrolledAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,totpFactorId,enrolledAt);
}

@override
String toString() {
    return 'SecurityStatus(totpFactorId: $totpFactorId, enrolledAt: $enrolledAt)';
}


}

/// @nodoc
abstract mixin class _$SecurityStatusCopyWith<$Res> implements $SecurityStatusCopyWith<$Res> {
  factory _$SecurityStatusCopyWith(_SecurityStatus value, $Res Function(_SecurityStatus) _then) = __$SecurityStatusCopyWithImpl;
@override @useResult
$Res call({
 String? totpFactorId, DateTime? enrolledAt
});




}
/// @nodoc
class __$SecurityStatusCopyWithImpl<$Res>
    implements _$SecurityStatusCopyWith<$Res> {
  __$SecurityStatusCopyWithImpl(this._self, this._then);

  final _SecurityStatus _self;
  final $Res Function(_SecurityStatus) _then;

/// Create a copy of SecurityStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totpFactorId = freezed,Object? enrolledAt = freezed,}) {
  return _then(_SecurityStatus(
totpFactorId: freezed == totpFactorId ? _self.totpFactorId : totpFactorId // ignore: cast_nullable_to_non_nullable
as String?,enrolledAt: freezed == enrolledAt ? _self.enrolledAt : enrolledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$SessionInfo {

 String get device; DateTime? get lastSignIn;
/// Create a copy of SessionInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionInfoCopyWith<SessionInfo> get copyWith => _$SessionInfoCopyWithImpl<SessionInfo>(this as SessionInfo, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionInfo&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.lastSignIn, _this.lastSignIn) || other.lastSignIn == _this.lastSignIn));
}


@override
int get hashCode {
  final _this = this as SessionInfo;
  return Object.hash(runtimeType,_this.device,_this.lastSignIn);
}

@override
String toString() {
  final _this = this as SessionInfo;
  return 'SessionInfo(device: ${_this.device}, lastSignIn: ${_this.lastSignIn})';
}


}

/// @nodoc
abstract mixin class $SessionInfoCopyWith<$Res>  {
  factory $SessionInfoCopyWith(SessionInfo value, $Res Function(SessionInfo) _then) = _$SessionInfoCopyWithImpl;
@useResult
$Res call({
 String device, DateTime? lastSignIn
});




}
/// @nodoc
class _$SessionInfoCopyWithImpl<$Res>
    implements $SessionInfoCopyWith<$Res> {
  _$SessionInfoCopyWithImpl(this._self, this._then);

  final SessionInfo _self;
  final $Res Function(SessionInfo) _then;

/// Create a copy of SessionInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device = null,Object? lastSignIn = freezed,}) {
  return _then(SessionInfo(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String,lastSignIn: freezed == lastSignIn ? _self.lastSignIn : lastSignIn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionInfo].
extension SessionInfoPatterns on SessionInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionInfo value)  $default,){
final _that = this;
switch (_that) {
case _SessionInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SessionInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String device,  DateTime? lastSignIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionInfo() when $default != null:
return $default(_that.device,_that.lastSignIn);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String device,  DateTime? lastSignIn)  $default,) {final _that = this;
switch (_that) {
case _SessionInfo():
return $default(_that.device,_that.lastSignIn);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String device,  DateTime? lastSignIn)?  $default,) {final _that = this;
switch (_that) {
case _SessionInfo() when $default != null:
return $default(_that.device,_that.lastSignIn);case _:
  return null;

}
}

}

/// @nodoc


class _SessionInfo implements SessionInfo {
  const _SessionInfo({required this.device, this.lastSignIn});
  

@override final  String device;
@override final  DateTime? lastSignIn;

/// Create a copy of SessionInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionInfoCopyWith<_SessionInfo> get copyWith => __$SessionInfoCopyWithImpl<_SessionInfo>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionInfo&&(identical(other.device, device) || other.device == device)&&(identical(other.lastSignIn, lastSignIn) || other.lastSignIn == lastSignIn));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device,lastSignIn);
}

@override
String toString() {
    return 'SessionInfo(device: $device, lastSignIn: $lastSignIn)';
}


}

/// @nodoc
abstract mixin class _$SessionInfoCopyWith<$Res> implements $SessionInfoCopyWith<$Res> {
  factory _$SessionInfoCopyWith(_SessionInfo value, $Res Function(_SessionInfo) _then) = __$SessionInfoCopyWithImpl;
@override @useResult
$Res call({
 String device, DateTime? lastSignIn
});




}
/// @nodoc
class __$SessionInfoCopyWithImpl<$Res>
    implements _$SessionInfoCopyWith<$Res> {
  __$SessionInfoCopyWithImpl(this._self, this._then);

  final _SessionInfo _self;
  final $Res Function(_SessionInfo) _then;

/// Create a copy of SessionInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,Object? lastSignIn = freezed,}) {
  return _then(_SessionInfo(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as String,lastSignIn: freezed == lastSignIn ? _self.lastSignIn : lastSignIn // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$SecurityPrefs {

/// Ask for fingerprint / Face ID (or the device PIN) when the app opens.
 bool get appLock;/// How long the app can be away before it locks again.
 int get autoLockMinutes;
/// Create a copy of SecurityPrefs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecurityPrefsCopyWith<SecurityPrefs> get copyWith => _$SecurityPrefsCopyWithImpl<SecurityPrefs>(this as SecurityPrefs, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SecurityPrefs;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecurityPrefs&&(identical(other.appLock, _this.appLock) || other.appLock == _this.appLock)&&(identical(other.autoLockMinutes, _this.autoLockMinutes) || other.autoLockMinutes == _this.autoLockMinutes));
}


@override
int get hashCode {
  final _this = this as SecurityPrefs;
  return Object.hash(runtimeType,_this.appLock,_this.autoLockMinutes);
}

@override
String toString() {
  final _this = this as SecurityPrefs;
  return 'SecurityPrefs(appLock: ${_this.appLock}, autoLockMinutes: ${_this.autoLockMinutes})';
}


}

/// @nodoc
abstract mixin class $SecurityPrefsCopyWith<$Res>  {
  factory $SecurityPrefsCopyWith(SecurityPrefs value, $Res Function(SecurityPrefs) _then) = _$SecurityPrefsCopyWithImpl;
@useResult
$Res call({
 bool appLock, int autoLockMinutes
});




}
/// @nodoc
class _$SecurityPrefsCopyWithImpl<$Res>
    implements $SecurityPrefsCopyWith<$Res> {
  _$SecurityPrefsCopyWithImpl(this._self, this._then);

  final SecurityPrefs _self;
  final $Res Function(SecurityPrefs) _then;

/// Create a copy of SecurityPrefs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appLock = null,Object? autoLockMinutes = null,}) {
  return _then(SecurityPrefs(
appLock: null == appLock ? _self.appLock : appLock // ignore: cast_nullable_to_non_nullable
as bool,autoLockMinutes: null == autoLockMinutes ? _self.autoLockMinutes : autoLockMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SecurityPrefs].
extension SecurityPrefsPatterns on SecurityPrefs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SecurityPrefs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SecurityPrefs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SecurityPrefs value)  $default,){
final _that = this;
switch (_that) {
case _SecurityPrefs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SecurityPrefs value)?  $default,){
final _that = this;
switch (_that) {
case _SecurityPrefs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool appLock,  int autoLockMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SecurityPrefs() when $default != null:
return $default(_that.appLock,_that.autoLockMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool appLock,  int autoLockMinutes)  $default,) {final _that = this;
switch (_that) {
case _SecurityPrefs():
return $default(_that.appLock,_that.autoLockMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool appLock,  int autoLockMinutes)?  $default,) {final _that = this;
switch (_that) {
case _SecurityPrefs() when $default != null:
return $default(_that.appLock,_that.autoLockMinutes);case _:
  return null;

}
}

}

/// @nodoc


class _SecurityPrefs implements SecurityPrefs {
  const _SecurityPrefs({this.appLock = false, this.autoLockMinutes = 1});
  

/// Ask for fingerprint / Face ID (or the device PIN) when the app opens.
@override@JsonKey() final  bool appLock;
/// How long the app can be away before it locks again.
@override@JsonKey() final  int autoLockMinutes;

/// Create a copy of SecurityPrefs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecurityPrefsCopyWith<_SecurityPrefs> get copyWith => __$SecurityPrefsCopyWithImpl<_SecurityPrefs>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecurityPrefs&&(identical(other.appLock, appLock) || other.appLock == appLock)&&(identical(other.autoLockMinutes, autoLockMinutes) || other.autoLockMinutes == autoLockMinutes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,appLock,autoLockMinutes);
}

@override
String toString() {
    return 'SecurityPrefs(appLock: $appLock, autoLockMinutes: $autoLockMinutes)';
}


}

/// @nodoc
abstract mixin class _$SecurityPrefsCopyWith<$Res> implements $SecurityPrefsCopyWith<$Res> {
  factory _$SecurityPrefsCopyWith(_SecurityPrefs value, $Res Function(_SecurityPrefs) _then) = __$SecurityPrefsCopyWithImpl;
@override @useResult
$Res call({
 bool appLock, int autoLockMinutes
});




}
/// @nodoc
class __$SecurityPrefsCopyWithImpl<$Res>
    implements _$SecurityPrefsCopyWith<$Res> {
  __$SecurityPrefsCopyWithImpl(this._self, this._then);

  final _SecurityPrefs _self;
  final $Res Function(_SecurityPrefs) _then;

/// Create a copy of SecurityPrefs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appLock = null,Object? autoLockMinutes = null,}) {
  return _then(_SecurityPrefs(
appLock: null == appLock ? _self.appLock : appLock // ignore: cast_nullable_to_non_nullable
as bool,autoLockMinutes: null == autoLockMinutes ? _self.autoLockMinutes : autoLockMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
