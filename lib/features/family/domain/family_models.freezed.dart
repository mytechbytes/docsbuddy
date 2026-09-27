// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Family {

 String get id; String get name; String get ownerId;
/// Create a copy of Family
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyCopyWith<Family> get copyWith => _$FamilyCopyWithImpl<Family>(this as Family, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Family;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Family&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.ownerId, _this.ownerId) || other.ownerId == _this.ownerId));
}


@override
int get hashCode {
  final _this = this as Family;
  return Object.hash(runtimeType,_this.id,_this.name,_this.ownerId);
}

@override
String toString() {
  final _this = this as Family;
  return 'Family(id: ${_this.id}, name: ${_this.name}, ownerId: ${_this.ownerId})';
}


}

/// @nodoc
abstract mixin class $FamilyCopyWith<$Res>  {
  factory $FamilyCopyWith(Family value, $Res Function(Family) _then) = _$FamilyCopyWithImpl;
@useResult
$Res call({
 String id, String name, String ownerId
});




}
/// @nodoc
class _$FamilyCopyWithImpl<$Res>
    implements $FamilyCopyWith<$Res> {
  _$FamilyCopyWithImpl(this._self, this._then);

  final Family _self;
  final $Res Function(Family) _then;

/// Create a copy of Family
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? ownerId = null,}) {
  return _then(Family(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Family].
extension FamilyPatterns on Family {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Family value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Family() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Family value)  $default,){
final _that = this;
switch (_that) {
case _Family():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Family value)?  $default,){
final _that = this;
switch (_that) {
case _Family() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String ownerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Family() when $default != null:
return $default(_that.id,_that.name,_that.ownerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String ownerId)  $default,) {final _that = this;
switch (_that) {
case _Family():
return $default(_that.id,_that.name,_that.ownerId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String ownerId)?  $default,) {final _that = this;
switch (_that) {
case _Family() when $default != null:
return $default(_that.id,_that.name,_that.ownerId);case _:
  return null;

}
}

}

/// @nodoc


class _Family implements Family {
  const _Family({required this.id, required this.name, required this.ownerId});
  

@override final  String id;
@override final  String name;
@override final  String ownerId;

/// Create a copy of Family
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyCopyWith<_Family> get copyWith => __$FamilyCopyWithImpl<_Family>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Family&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,ownerId);
}

@override
String toString() {
    return 'Family(id: $id, name: $name, ownerId: $ownerId)';
}


}

/// @nodoc
abstract mixin class _$FamilyCopyWith<$Res> implements $FamilyCopyWith<$Res> {
  factory _$FamilyCopyWith(_Family value, $Res Function(_Family) _then) = __$FamilyCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String ownerId
});




}
/// @nodoc
class __$FamilyCopyWithImpl<$Res>
    implements _$FamilyCopyWith<$Res> {
  __$FamilyCopyWithImpl(this._self, this._then);

  final _Family _self;
  final $Res Function(_Family) _then;

/// Create a copy of Family
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? ownerId = null,}) {
  return _then(_Family(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$FamilyMember {

 String get userId; String get displayName; FamilyRole get role;/// Contact number (E.164) — shown on the member tile.
 String? get phone;/// Profile photo reference (bucket path or URL).
 String? get avatarUrl;
/// Create a copy of FamilyMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyMemberCopyWith<FamilyMember> get copyWith => _$FamilyMemberCopyWithImpl<FamilyMember>(this as FamilyMember, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FamilyMember;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyMember&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl));
}


@override
int get hashCode {
  final _this = this as FamilyMember;
  return Object.hash(runtimeType,_this.userId,_this.displayName,_this.role,_this.phone,_this.avatarUrl);
}

@override
String toString() {
  final _this = this as FamilyMember;
  return 'FamilyMember(userId: ${_this.userId}, displayName: ${_this.displayName}, role: ${_this.role}, phone: ${_this.phone}, avatarUrl: ${_this.avatarUrl})';
}


}

/// @nodoc
abstract mixin class $FamilyMemberCopyWith<$Res>  {
  factory $FamilyMemberCopyWith(FamilyMember value, $Res Function(FamilyMember) _then) = _$FamilyMemberCopyWithImpl;
@useResult
$Res call({
 String userId, String displayName, FamilyRole role, String? phone, String? avatarUrl
});




}
/// @nodoc
class _$FamilyMemberCopyWithImpl<$Res>
    implements $FamilyMemberCopyWith<$Res> {
  _$FamilyMemberCopyWithImpl(this._self, this._then);

  final FamilyMember _self;
  final $Res Function(FamilyMember) _then;

/// Create a copy of FamilyMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? displayName = null,Object? role = null,Object? phone = freezed,Object? avatarUrl = freezed,}) {
  return _then(FamilyMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FamilyRole,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyMember].
extension FamilyMemberPatterns on FamilyMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyMember value)  $default,){
final _that = this;
switch (_that) {
case _FamilyMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyMember value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String displayName,  FamilyRole role,  String? phone,  String? avatarUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilyMember() when $default != null:
return $default(_that.userId,_that.displayName,_that.role,_that.phone,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String displayName,  FamilyRole role,  String? phone,  String? avatarUrl)  $default,) {final _that = this;
switch (_that) {
case _FamilyMember():
return $default(_that.userId,_that.displayName,_that.role,_that.phone,_that.avatarUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String displayName,  FamilyRole role,  String? phone,  String? avatarUrl)?  $default,) {final _that = this;
switch (_that) {
case _FamilyMember() when $default != null:
return $default(_that.userId,_that.displayName,_that.role,_that.phone,_that.avatarUrl);case _:
  return null;

}
}

}

/// @nodoc


class _FamilyMember extends FamilyMember {
  const _FamilyMember({required this.userId, required this.displayName, required this.role, this.phone, this.avatarUrl}): super._();
  

@override final  String userId;
@override final  String displayName;
@override final  FamilyRole role;
/// Contact number (E.164) — shown on the member tile.
@override final  String? phone;
/// Profile photo reference (bucket path or URL).
@override final  String? avatarUrl;

/// Create a copy of FamilyMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyMemberCopyWith<_FamilyMember> get copyWith => __$FamilyMemberCopyWithImpl<_FamilyMember>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyMember&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.role, role) || other.role == role)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl));
}


@override
int get hashCode {
    return Object.hash(runtimeType,userId,displayName,role,phone,avatarUrl);
}

@override
String toString() {
    return 'FamilyMember(userId: $userId, displayName: $displayName, role: $role, phone: $phone, avatarUrl: $avatarUrl)';
}


}

/// @nodoc
abstract mixin class _$FamilyMemberCopyWith<$Res> implements $FamilyMemberCopyWith<$Res> {
  factory _$FamilyMemberCopyWith(_FamilyMember value, $Res Function(_FamilyMember) _then) = __$FamilyMemberCopyWithImpl;
@override @useResult
$Res call({
 String userId, String displayName, FamilyRole role, String? phone, String? avatarUrl
});




}
/// @nodoc
class __$FamilyMemberCopyWithImpl<$Res>
    implements _$FamilyMemberCopyWith<$Res> {
  __$FamilyMemberCopyWithImpl(this._self, this._then);

  final _FamilyMember _self;
  final $Res Function(_FamilyMember) _then;

/// Create a copy of FamilyMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? displayName = null,Object? role = null,Object? phone = freezed,Object? avatarUrl = freezed,}) {
  return _then(_FamilyMember(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FamilyRole,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$FamilyInvite {

 String get code; FamilyRole get role; DateTime get expiresAt;
/// Create a copy of FamilyInvite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyInviteCopyWith<FamilyInvite> get copyWith => _$FamilyInviteCopyWithImpl<FamilyInvite>(this as FamilyInvite, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FamilyInvite;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyInvite&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}


@override
int get hashCode {
  final _this = this as FamilyInvite;
  return Object.hash(runtimeType,_this.code,_this.role,_this.expiresAt);
}

@override
String toString() {
  final _this = this as FamilyInvite;
  return 'FamilyInvite(code: ${_this.code}, role: ${_this.role}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $FamilyInviteCopyWith<$Res>  {
  factory $FamilyInviteCopyWith(FamilyInvite value, $Res Function(FamilyInvite) _then) = _$FamilyInviteCopyWithImpl;
@useResult
$Res call({
 String code, FamilyRole role, DateTime expiresAt
});




}
/// @nodoc
class _$FamilyInviteCopyWithImpl<$Res>
    implements $FamilyInviteCopyWith<$Res> {
  _$FamilyInviteCopyWithImpl(this._self, this._then);

  final FamilyInvite _self;
  final $Res Function(FamilyInvite) _then;

/// Create a copy of FamilyInvite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? role = null,Object? expiresAt = null,}) {
  return _then(FamilyInvite(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FamilyRole,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyInvite].
extension FamilyInvitePatterns on FamilyInvite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyInvite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyInvite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyInvite value)  $default,){
final _that = this;
switch (_that) {
case _FamilyInvite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyInvite value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyInvite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  FamilyRole role,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilyInvite() when $default != null:
return $default(_that.code,_that.role,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  FamilyRole role,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _FamilyInvite():
return $default(_that.code,_that.role,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  FamilyRole role,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _FamilyInvite() when $default != null:
return $default(_that.code,_that.role,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc


class _FamilyInvite implements FamilyInvite {
  const _FamilyInvite({required this.code, required this.role, required this.expiresAt});
  

@override final  String code;
@override final  FamilyRole role;
@override final  DateTime expiresAt;

/// Create a copy of FamilyInvite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyInviteCopyWith<_FamilyInvite> get copyWith => __$FamilyInviteCopyWithImpl<_FamilyInvite>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyInvite&&(identical(other.code, code) || other.code == code)&&(identical(other.role, role) || other.role == role)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,role,expiresAt);
}

@override
String toString() {
    return 'FamilyInvite(code: $code, role: $role, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$FamilyInviteCopyWith<$Res> implements $FamilyInviteCopyWith<$Res> {
  factory _$FamilyInviteCopyWith(_FamilyInvite value, $Res Function(_FamilyInvite) _then) = __$FamilyInviteCopyWithImpl;
@override @useResult
$Res call({
 String code, FamilyRole role, DateTime expiresAt
});




}
/// @nodoc
class __$FamilyInviteCopyWithImpl<$Res>
    implements _$FamilyInviteCopyWith<$Res> {
  __$FamilyInviteCopyWithImpl(this._self, this._then);

  final _FamilyInvite _self;
  final $Res Function(_FamilyInvite) _then;

/// Create a copy of FamilyInvite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? role = null,Object? expiresAt = null,}) {
  return _then(_FamilyInvite(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as FamilyRole,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$FamilyView {

 Family? get family; List<FamilyMember> get members; String? get myUserId;
/// Create a copy of FamilyView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyViewCopyWith<FamilyView> get copyWith => _$FamilyViewCopyWithImpl<FamilyView>(this as FamilyView, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FamilyView;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyView&&(identical(other.family, _this.family) || other.family == _this.family)&&const DeepCollectionEquality().equals(other.members, _this.members)&&(identical(other.myUserId, _this.myUserId) || other.myUserId == _this.myUserId));
}


@override
int get hashCode {
  final _this = this as FamilyView;
  return Object.hash(runtimeType,_this.family,const DeepCollectionEquality().hash(_this.members),_this.myUserId);
}

@override
String toString() {
  final _this = this as FamilyView;
  return 'FamilyView(family: ${_this.family}, members: ${_this.members}, myUserId: ${_this.myUserId})';
}


}

/// @nodoc
abstract mixin class $FamilyViewCopyWith<$Res>  {
  factory $FamilyViewCopyWith(FamilyView value, $Res Function(FamilyView) _then) = _$FamilyViewCopyWithImpl;
@useResult
$Res call({
 Family? family, List<FamilyMember> members, String? myUserId
});


$FamilyCopyWith<$Res>? get family;

}
/// @nodoc
class _$FamilyViewCopyWithImpl<$Res>
    implements $FamilyViewCopyWith<$Res> {
  _$FamilyViewCopyWithImpl(this._self, this._then);

  final FamilyView _self;
  final $Res Function(FamilyView) _then;

/// Create a copy of FamilyView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? family = freezed,Object? members = null,Object? myUserId = freezed,}) {
  return _then(FamilyView(
family: freezed == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as Family?,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<FamilyMember>,myUserId: freezed == myUserId ? _self.myUserId : myUserId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of FamilyView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FamilyCopyWith<$Res>? get family {
    if (_self.family == null) {
    return null;
  }

  return $FamilyCopyWith<$Res>(_self.family!, (value) {
    return _then(_self.copyWith(family: value));
  });
}
}


/// Adds pattern-matching-related methods to [FamilyView].
extension FamilyViewPatterns on FamilyView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyView value)  $default,){
final _that = this;
switch (_that) {
case _FamilyView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyView value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Family? family,  List<FamilyMember> members,  String? myUserId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilyView() when $default != null:
return $default(_that.family,_that.members,_that.myUserId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Family? family,  List<FamilyMember> members,  String? myUserId)  $default,) {final _that = this;
switch (_that) {
case _FamilyView():
return $default(_that.family,_that.members,_that.myUserId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Family? family,  List<FamilyMember> members,  String? myUserId)?  $default,) {final _that = this;
switch (_that) {
case _FamilyView() when $default != null:
return $default(_that.family,_that.members,_that.myUserId);case _:
  return null;

}
}

}

/// @nodoc


class _FamilyView extends FamilyView {
  const _FamilyView({this.family,  List<FamilyMember> members = const <FamilyMember>[], this.myUserId}): _members = members,super._();
  

@override final  Family? family;
 final  List<FamilyMember> _members;
@override@JsonKey() List<FamilyMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

@override final  String? myUserId;

/// Create a copy of FamilyView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyViewCopyWith<_FamilyView> get copyWith => __$FamilyViewCopyWithImpl<_FamilyView>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyView&&(identical(other.family, family) || other.family == family)&&const DeepCollectionEquality().equals(other.members, _members)&&(identical(other.myUserId, myUserId) || other.myUserId == myUserId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,family,const DeepCollectionEquality().hash(_members),myUserId);
}

@override
String toString() {
    return 'FamilyView(family: $family, members: $members, myUserId: $myUserId)';
}


}

/// @nodoc
abstract mixin class _$FamilyViewCopyWith<$Res> implements $FamilyViewCopyWith<$Res> {
  factory _$FamilyViewCopyWith(_FamilyView value, $Res Function(_FamilyView) _then) = __$FamilyViewCopyWithImpl;
@override @useResult
$Res call({
 Family? family, List<FamilyMember> members, String? myUserId
});


@override $FamilyCopyWith<$Res>? get family;

}
/// @nodoc
class __$FamilyViewCopyWithImpl<$Res>
    implements _$FamilyViewCopyWith<$Res> {
  __$FamilyViewCopyWithImpl(this._self, this._then);

  final _FamilyView _self;
  final $Res Function(_FamilyView) _then;

/// Create a copy of FamilyView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? family = freezed,Object? members = null,Object? myUserId = freezed,}) {
  return _then(_FamilyView(
family: freezed == family ? _self.family : family // ignore: cast_nullable_to_non_nullable
as Family?,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<FamilyMember>,myUserId: freezed == myUserId ? _self.myUserId : myUserId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of FamilyView
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FamilyCopyWith<$Res>? get family {
    if (_self.family == null) {
    return null;
  }

  return $FamilyCopyWith<$Res>(_self.family!, (value) {
    return _then(_self.copyWith(family: value));
  });
}
}

// dart format on
