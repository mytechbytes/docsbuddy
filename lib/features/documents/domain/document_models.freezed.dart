// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentMeta {

 String get id; String get assetId;/// When set, the document belongs to a specific service on the asset
/// (`documents.asset_date_id`) — e.g. the insurance policy PDF on the
/// Insurance service — rather than the asset as a whole.
 String? get assetDateId; String get title; DocKind get kind; String get mimeType; int get sizeBytes; String get storagePath; DateTime get createdAt;
/// Create a copy of DocumentMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentMetaCopyWith<DocumentMeta> get copyWith => _$DocumentMetaCopyWithImpl<DocumentMeta>(this as DocumentMeta, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DocumentMeta;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentMeta&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.assetId, _this.assetId) || other.assetId == _this.assetId)&&(identical(other.assetDateId, _this.assetDateId) || other.assetDateId == _this.assetDateId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.mimeType, _this.mimeType) || other.mimeType == _this.mimeType)&&(identical(other.sizeBytes, _this.sizeBytes) || other.sizeBytes == _this.sizeBytes)&&(identical(other.storagePath, _this.storagePath) || other.storagePath == _this.storagePath)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as DocumentMeta;
  return Object.hash(runtimeType,_this.id,_this.assetId,_this.assetDateId,_this.title,_this.kind,_this.mimeType,_this.sizeBytes,_this.storagePath,_this.createdAt);
}

@override
String toString() {
  final _this = this as DocumentMeta;
  return 'DocumentMeta(id: ${_this.id}, assetId: ${_this.assetId}, assetDateId: ${_this.assetDateId}, title: ${_this.title}, kind: ${_this.kind}, mimeType: ${_this.mimeType}, sizeBytes: ${_this.sizeBytes}, storagePath: ${_this.storagePath}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $DocumentMetaCopyWith<$Res>  {
  factory $DocumentMetaCopyWith(DocumentMeta value, $Res Function(DocumentMeta) _then) = _$DocumentMetaCopyWithImpl;
@useResult
$Res call({
 String id, String assetId, String? assetDateId, String title, DocKind kind, String mimeType, int sizeBytes, String storagePath, DateTime createdAt
});




}
/// @nodoc
class _$DocumentMetaCopyWithImpl<$Res>
    implements $DocumentMetaCopyWith<$Res> {
  _$DocumentMetaCopyWithImpl(this._self, this._then);

  final DocumentMeta _self;
  final $Res Function(DocumentMeta) _then;

/// Create a copy of DocumentMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? assetId = null,Object? assetDateId = freezed,Object? title = null,Object? kind = null,Object? mimeType = null,Object? sizeBytes = null,Object? storagePath = null,Object? createdAt = null,}) {
  return _then(DocumentMeta(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,assetDateId: freezed == assetDateId ? _self.assetDateId : assetDateId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DocKind,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentMeta].
extension DocumentMetaPatterns on DocumentMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentMeta value)  $default,){
final _that = this;
switch (_that) {
case _DocumentMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentMeta value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String assetId,  String? assetDateId,  String title,  DocKind kind,  String mimeType,  int sizeBytes,  String storagePath,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentMeta() when $default != null:
return $default(_that.id,_that.assetId,_that.assetDateId,_that.title,_that.kind,_that.mimeType,_that.sizeBytes,_that.storagePath,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String assetId,  String? assetDateId,  String title,  DocKind kind,  String mimeType,  int sizeBytes,  String storagePath,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DocumentMeta():
return $default(_that.id,_that.assetId,_that.assetDateId,_that.title,_that.kind,_that.mimeType,_that.sizeBytes,_that.storagePath,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String assetId,  String? assetDateId,  String title,  DocKind kind,  String mimeType,  int sizeBytes,  String storagePath,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DocumentMeta() when $default != null:
return $default(_that.id,_that.assetId,_that.assetDateId,_that.title,_that.kind,_that.mimeType,_that.sizeBytes,_that.storagePath,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _DocumentMeta extends DocumentMeta {
  const _DocumentMeta({required this.id, required this.assetId, this.assetDateId, required this.title, required this.kind, required this.mimeType, required this.sizeBytes, required this.storagePath, required this.createdAt}): super._();
  

@override final  String id;
@override final  String assetId;
/// When set, the document belongs to a specific service on the asset
/// (`documents.asset_date_id`) — e.g. the insurance policy PDF on the
/// Insurance service — rather than the asset as a whole.
@override final  String? assetDateId;
@override final  String title;
@override final  DocKind kind;
@override final  String mimeType;
@override final  int sizeBytes;
@override final  String storagePath;
@override final  DateTime createdAt;

/// Create a copy of DocumentMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentMetaCopyWith<_DocumentMeta> get copyWith => __$DocumentMetaCopyWithImpl<_DocumentMeta>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentMeta&&(identical(other.id, id) || other.id == id)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.assetDateId, assetDateId) || other.assetDateId == assetDateId)&&(identical(other.title, title) || other.title == title)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,assetId,assetDateId,title,kind,mimeType,sizeBytes,storagePath,createdAt);
}

@override
String toString() {
    return 'DocumentMeta(id: $id, assetId: $assetId, assetDateId: $assetDateId, title: $title, kind: $kind, mimeType: $mimeType, sizeBytes: $sizeBytes, storagePath: $storagePath, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DocumentMetaCopyWith<$Res> implements $DocumentMetaCopyWith<$Res> {
  factory _$DocumentMetaCopyWith(_DocumentMeta value, $Res Function(_DocumentMeta) _then) = __$DocumentMetaCopyWithImpl;
@override @useResult
$Res call({
 String id, String assetId, String? assetDateId, String title, DocKind kind, String mimeType, int sizeBytes, String storagePath, DateTime createdAt
});




}
/// @nodoc
class __$DocumentMetaCopyWithImpl<$Res>
    implements _$DocumentMetaCopyWith<$Res> {
  __$DocumentMetaCopyWithImpl(this._self, this._then);

  final _DocumentMeta _self;
  final $Res Function(_DocumentMeta) _then;

/// Create a copy of DocumentMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? assetId = null,Object? assetDateId = freezed,Object? title = null,Object? kind = null,Object? mimeType = null,Object? sizeBytes = null,Object? storagePath = null,Object? createdAt = null,}) {
  return _then(_DocumentMeta(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,assetDateId: freezed == assetDateId ? _self.assetDateId : assetDateId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as DocKind,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
