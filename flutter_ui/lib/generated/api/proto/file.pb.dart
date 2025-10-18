///
//  Generated code. Do not modify.
//  source: api/proto/file.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $3;
import 'common.pb.dart' as $1;

class File extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'File', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'folderId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'relativePath')
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'size')
    ..aOM<$3.Timestamp>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'modTime', subBuilder: $3.Timestamp.create)
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'globalHash')
    ..a<$core.int>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chunkCount', $pb.PbFieldType.O3)
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isDeleted')
    ..aOM<$3.Timestamp>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt', subBuilder: $3.Timestamp.create)
    ..aOM<$3.Timestamp>(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedAt', subBuilder: $3.Timestamp.create)
    ..hasRequiredFields = false
  ;

  File._() : super();
  factory File({
    $core.String? id,
    $core.String? folderId,
    $core.String? relativePath,
    $fixnum.Int64? size,
    $3.Timestamp? modTime,
    $core.String? globalHash,
    $core.int? chunkCount,
    $core.bool? isDeleted,
    $3.Timestamp? createdAt,
    $3.Timestamp? updatedAt,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (folderId != null) {
      _result.folderId = folderId;
    }
    if (relativePath != null) {
      _result.relativePath = relativePath;
    }
    if (size != null) {
      _result.size = size;
    }
    if (modTime != null) {
      _result.modTime = modTime;
    }
    if (globalHash != null) {
      _result.globalHash = globalHash;
    }
    if (chunkCount != null) {
      _result.chunkCount = chunkCount;
    }
    if (isDeleted != null) {
      _result.isDeleted = isDeleted;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      _result.updatedAt = updatedAt;
    }
    return _result;
  }
  factory File.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory File.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  File clone() => File()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  File copyWith(void Function(File) updates) => super.copyWith((message) => updates(message as File)) as File; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static File create() => File._();
  File createEmptyInstance() => create();
  static $pb.PbList<File> createRepeated() => $pb.PbList<File>();
  @$core.pragma('dart2js:noInline')
  static File getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File>(create);
  static File? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get folderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set folderId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFolderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolderId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get relativePath => $_getSZ(2);
  @$pb.TagNumber(3)
  set relativePath($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRelativePath() => $_has(2);
  @$pb.TagNumber(3)
  void clearRelativePath() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get size => $_getI64(3);
  @$pb.TagNumber(4)
  set size($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearSize() => clearField(4);

  @$pb.TagNumber(5)
  $3.Timestamp get modTime => $_getN(4);
  @$pb.TagNumber(5)
  set modTime($3.Timestamp v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasModTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearModTime() => clearField(5);
  @$pb.TagNumber(5)
  $3.Timestamp ensureModTime() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get globalHash => $_getSZ(5);
  @$pb.TagNumber(6)
  set globalHash($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasGlobalHash() => $_has(5);
  @$pb.TagNumber(6)
  void clearGlobalHash() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get chunkCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set chunkCount($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasChunkCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearChunkCount() => clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isDeleted => $_getBF(7);
  @$pb.TagNumber(8)
  set isDeleted($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasIsDeleted() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsDeleted() => clearField(8);

  @$pb.TagNumber(9)
  $3.Timestamp get createdAt => $_getN(8);
  @$pb.TagNumber(9)
  set createdAt($3.Timestamp v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => clearField(9);
  @$pb.TagNumber(9)
  $3.Timestamp ensureCreatedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $3.Timestamp get updatedAt => $_getN(9);
  @$pb.TagNumber(10)
  set updatedAt($3.Timestamp v) { setField(10, v); }
  @$pb.TagNumber(10)
  $core.bool hasUpdatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpdatedAt() => clearField(10);
  @$pb.TagNumber(10)
  $3.Timestamp ensureUpdatedAt() => $_ensure(9);
}

class Chunk extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Chunk', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileId')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'offset')
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'length')
    ..pPS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deviceAvailability')
    ..hasRequiredFields = false
  ;

  Chunk._() : super();
  factory Chunk({
    $core.String? id,
    $core.String? fileId,
    $fixnum.Int64? offset,
    $fixnum.Int64? length,
    $core.Iterable<$core.String>? deviceAvailability,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (fileId != null) {
      _result.fileId = fileId;
    }
    if (offset != null) {
      _result.offset = offset;
    }
    if (length != null) {
      _result.length = length;
    }
    if (deviceAvailability != null) {
      _result.deviceAvailability.addAll(deviceAvailability);
    }
    return _result;
  }
  factory Chunk.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Chunk.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Chunk clone() => Chunk()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Chunk copyWith(void Function(Chunk) updates) => super.copyWith((message) => updates(message as Chunk)) as Chunk; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Chunk create() => Chunk._();
  Chunk createEmptyInstance() => create();
  static $pb.PbList<Chunk> createRepeated() => $pb.PbList<Chunk>();
  @$core.pragma('dart2js:noInline')
  static Chunk getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chunk>(create);
  static Chunk? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get fileId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fileId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileId() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get offset => $_getI64(2);
  @$pb.TagNumber(3)
  set offset($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get length => $_getI64(3);
  @$pb.TagNumber(4)
  set length($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLength() => $_has(3);
  @$pb.TagNumber(4)
  void clearLength() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.String> get deviceAvailability => $_getList(4);
}

class FileVersion extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FileVersion', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileId')
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'versionNumber', $pb.PbFieldType.O3)
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'backupPath')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'originalPath')
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'size')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hash')
    ..aOM<$3.Timestamp>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt', subBuilder: $3.Timestamp.create)
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdByPeerId')
    ..hasRequiredFields = false
  ;

  FileVersion._() : super();
  factory FileVersion({
    $core.String? id,
    $core.String? fileId,
    $core.int? versionNumber,
    $core.String? backupPath,
    $core.String? originalPath,
    $fixnum.Int64? size,
    $core.String? hash,
    $3.Timestamp? createdAt,
    $core.String? createdByPeerId,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (fileId != null) {
      _result.fileId = fileId;
    }
    if (versionNumber != null) {
      _result.versionNumber = versionNumber;
    }
    if (backupPath != null) {
      _result.backupPath = backupPath;
    }
    if (originalPath != null) {
      _result.originalPath = originalPath;
    }
    if (size != null) {
      _result.size = size;
    }
    if (hash != null) {
      _result.hash = hash;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (createdByPeerId != null) {
      _result.createdByPeerId = createdByPeerId;
    }
    return _result;
  }
  factory FileVersion.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileVersion.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileVersion clone() => FileVersion()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileVersion copyWith(void Function(FileVersion) updates) => super.copyWith((message) => updates(message as FileVersion)) as FileVersion; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FileVersion create() => FileVersion._();
  FileVersion createEmptyInstance() => create();
  static $pb.PbList<FileVersion> createRepeated() => $pb.PbList<FileVersion>();
  @$core.pragma('dart2js:noInline')
  static FileVersion getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileVersion>(create);
  static FileVersion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get fileId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fileId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileId() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get versionNumber => $_getIZ(2);
  @$pb.TagNumber(3)
  set versionNumber($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasVersionNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersionNumber() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get backupPath => $_getSZ(3);
  @$pb.TagNumber(4)
  set backupPath($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasBackupPath() => $_has(3);
  @$pb.TagNumber(4)
  void clearBackupPath() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get originalPath => $_getSZ(4);
  @$pb.TagNumber(5)
  set originalPath($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasOriginalPath() => $_has(4);
  @$pb.TagNumber(5)
  void clearOriginalPath() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get size => $_getI64(5);
  @$pb.TagNumber(6)
  set size($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearSize() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get hash => $_getSZ(6);
  @$pb.TagNumber(7)
  set hash($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasHash() => $_has(6);
  @$pb.TagNumber(7)
  void clearHash() => clearField(7);

  @$pb.TagNumber(8)
  $3.Timestamp get createdAt => $_getN(7);
  @$pb.TagNumber(8)
  set createdAt($3.Timestamp v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => clearField(8);
  @$pb.TagNumber(8)
  $3.Timestamp ensureCreatedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get createdByPeerId => $_getSZ(8);
  @$pb.TagNumber(9)
  set createdByPeerId($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCreatedByPeerId() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedByPeerId() => clearField(9);
}

class GetFileRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetFileRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  GetFileRequest._() : super();
  factory GetFileRequest({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory GetFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetFileRequest clone() => GetFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetFileRequest copyWith(void Function(GetFileRequest) updates) => super.copyWith((message) => updates(message as GetFileRequest)) as GetFileRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetFileRequest create() => GetFileRequest._();
  GetFileRequest createEmptyInstance() => create();
  static $pb.PbList<GetFileRequest> createRepeated() => $pb.PbList<GetFileRequest>();
  @$core.pragma('dart2js:noInline')
  static GetFileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFileRequest>(create);
  static GetFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class ListFilesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListFilesRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'folderId')
    ..aOM<$1.PaginationRequest>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $1.PaginationRequest.create)
    ..hasRequiredFields = false
  ;

  ListFilesRequest._() : super();
  factory ListFilesRequest({
    $core.String? folderId,
    $1.PaginationRequest? pagination,
  }) {
    final _result = create();
    if (folderId != null) {
      _result.folderId = folderId;
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory ListFilesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListFilesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListFilesRequest clone() => ListFilesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListFilesRequest copyWith(void Function(ListFilesRequest) updates) => super.copyWith((message) => updates(message as ListFilesRequest)) as ListFilesRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListFilesRequest create() => ListFilesRequest._();
  ListFilesRequest createEmptyInstance() => create();
  static $pb.PbList<ListFilesRequest> createRepeated() => $pb.PbList<ListFilesRequest>();
  @$core.pragma('dart2js:noInline')
  static ListFilesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListFilesRequest>(create);
  static ListFilesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get folderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFolderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderId() => clearField(1);

  @$pb.TagNumber(2)
  $1.PaginationRequest get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationRequest v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationRequest ensurePagination() => $_ensure(1);
}

class ListFilesResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListFilesResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..pc<File>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'files', $pb.PbFieldType.PM, subBuilder: File.create)
    ..aOM<$1.PaginationResponse>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $1.PaginationResponse.create)
    ..hasRequiredFields = false
  ;

  ListFilesResponse._() : super();
  factory ListFilesResponse({
    $core.Iterable<File>? files,
    $1.PaginationResponse? pagination,
  }) {
    final _result = create();
    if (files != null) {
      _result.files.addAll(files);
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory ListFilesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListFilesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListFilesResponse clone() => ListFilesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListFilesResponse copyWith(void Function(ListFilesResponse) updates) => super.copyWith((message) => updates(message as ListFilesResponse)) as ListFilesResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListFilesResponse create() => ListFilesResponse._();
  ListFilesResponse createEmptyInstance() => create();
  static $pb.PbList<ListFilesResponse> createRepeated() => $pb.PbList<ListFilesResponse>();
  @$core.pragma('dart2js:noInline')
  static ListFilesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListFilesResponse>(create);
  static ListFilesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<File> get files => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginationResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationResponse v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationResponse ensurePagination() => $_ensure(1);
}

class GetFileInfoRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetFileInfoRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileId')
    ..hasRequiredFields = false
  ;

  GetFileInfoRequest._() : super();
  factory GetFileInfoRequest({
    $core.String? fileId,
  }) {
    final _result = create();
    if (fileId != null) {
      _result.fileId = fileId;
    }
    return _result;
  }
  factory GetFileInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetFileInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetFileInfoRequest clone() => GetFileInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetFileInfoRequest copyWith(void Function(GetFileInfoRequest) updates) => super.copyWith((message) => updates(message as GetFileInfoRequest)) as GetFileInfoRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetFileInfoRequest create() => GetFileInfoRequest._();
  GetFileInfoRequest createEmptyInstance() => create();
  static $pb.PbList<GetFileInfoRequest> createRepeated() => $pb.PbList<GetFileInfoRequest>();
  @$core.pragma('dart2js:noInline')
  static GetFileInfoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFileInfoRequest>(create);
  static GetFileInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => clearField(1);
}

class FileInfoResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FileInfoResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', subBuilder: $1.Status.create)
    ..aOM<File>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'file', subBuilder: File.create)
    ..pc<Chunk>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chunks', $pb.PbFieldType.PM, subBuilder: Chunk.create)
    ..pPS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'availablePeers')
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'versionCount', $pb.PbFieldType.O3)
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'syncPercentage', $pb.PbFieldType.OF)
    ..aOM<$3.Timestamp>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastSyncTime', subBuilder: $3.Timestamp.create)
    ..hasRequiredFields = false
  ;

  FileInfoResponse._() : super();
  factory FileInfoResponse({
    $1.Status? status,
    File? file,
    $core.Iterable<Chunk>? chunks,
    $core.Iterable<$core.String>? availablePeers,
    $core.int? versionCount,
    $core.double? syncPercentage,
    $3.Timestamp? lastSyncTime,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    if (file != null) {
      _result.file = file;
    }
    if (chunks != null) {
      _result.chunks.addAll(chunks);
    }
    if (availablePeers != null) {
      _result.availablePeers.addAll(availablePeers);
    }
    if (versionCount != null) {
      _result.versionCount = versionCount;
    }
    if (syncPercentage != null) {
      _result.syncPercentage = syncPercentage;
    }
    if (lastSyncTime != null) {
      _result.lastSyncTime = lastSyncTime;
    }
    return _result;
  }
  factory FileInfoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileInfoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileInfoResponse clone() => FileInfoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileInfoResponse copyWith(void Function(FileInfoResponse) updates) => super.copyWith((message) => updates(message as FileInfoResponse)) as FileInfoResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FileInfoResponse create() => FileInfoResponse._();
  FileInfoResponse createEmptyInstance() => create();
  static $pb.PbList<FileInfoResponse> createRepeated() => $pb.PbList<FileInfoResponse>();
  @$core.pragma('dart2js:noInline')
  static FileInfoResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileInfoResponse>(create);
  static FileInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($1.Status v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
  @$pb.TagNumber(1)
  $1.Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  File get file => $_getN(1);
  @$pb.TagNumber(2)
  set file(File v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFile() => $_has(1);
  @$pb.TagNumber(2)
  void clearFile() => clearField(2);
  @$pb.TagNumber(2)
  File ensureFile() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.List<Chunk> get chunks => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$core.String> get availablePeers => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get versionCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set versionCount($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasVersionCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersionCount() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get syncPercentage => $_getN(5);
  @$pb.TagNumber(6)
  set syncPercentage($core.double v) { $_setFloat(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSyncPercentage() => $_has(5);
  @$pb.TagNumber(6)
  void clearSyncPercentage() => clearField(6);

  @$pb.TagNumber(7)
  $3.Timestamp get lastSyncTime => $_getN(6);
  @$pb.TagNumber(7)
  set lastSyncTime($3.Timestamp v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasLastSyncTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearLastSyncTime() => clearField(7);
  @$pb.TagNumber(7)
  $3.Timestamp ensureLastSyncTime() => $_ensure(6);
}

class DeleteFileRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeleteFileRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileId')
    ..hasRequiredFields = false
  ;

  DeleteFileRequest._() : super();
  factory DeleteFileRequest({
    $core.String? fileId,
  }) {
    final _result = create();
    if (fileId != null) {
      _result.fileId = fileId;
    }
    return _result;
  }
  factory DeleteFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteFileRequest clone() => DeleteFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteFileRequest copyWith(void Function(DeleteFileRequest) updates) => super.copyWith((message) => updates(message as DeleteFileRequest)) as DeleteFileRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteFileRequest create() => DeleteFileRequest._();
  DeleteFileRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteFileRequest> createRepeated() => $pb.PbList<DeleteFileRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteFileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteFileRequest>(create);
  static DeleteFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => clearField(1);
}

class GetFileVersionsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetFileVersionsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileId')
    ..hasRequiredFields = false
  ;

  GetFileVersionsRequest._() : super();
  factory GetFileVersionsRequest({
    $core.String? fileId,
  }) {
    final _result = create();
    if (fileId != null) {
      _result.fileId = fileId;
    }
    return _result;
  }
  factory GetFileVersionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetFileVersionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetFileVersionsRequest clone() => GetFileVersionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetFileVersionsRequest copyWith(void Function(GetFileVersionsRequest) updates) => super.copyWith((message) => updates(message as GetFileVersionsRequest)) as GetFileVersionsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetFileVersionsRequest create() => GetFileVersionsRequest._();
  GetFileVersionsRequest createEmptyInstance() => create();
  static $pb.PbList<GetFileVersionsRequest> createRepeated() => $pb.PbList<GetFileVersionsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetFileVersionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFileVersionsRequest>(create);
  static GetFileVersionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => clearField(1);
}

class FileVersionsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FileVersionsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', subBuilder: $1.Status.create)
    ..pc<FileVersion>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'versions', $pb.PbFieldType.PM, subBuilder: FileVersion.create)
    ..hasRequiredFields = false
  ;

  FileVersionsResponse._() : super();
  factory FileVersionsResponse({
    $1.Status? status,
    $core.Iterable<FileVersion>? versions,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    if (versions != null) {
      _result.versions.addAll(versions);
    }
    return _result;
  }
  factory FileVersionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileVersionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileVersionsResponse clone() => FileVersionsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileVersionsResponse copyWith(void Function(FileVersionsResponse) updates) => super.copyWith((message) => updates(message as FileVersionsResponse)) as FileVersionsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FileVersionsResponse create() => FileVersionsResponse._();
  FileVersionsResponse createEmptyInstance() => create();
  static $pb.PbList<FileVersionsResponse> createRepeated() => $pb.PbList<FileVersionsResponse>();
  @$core.pragma('dart2js:noInline')
  static FileVersionsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileVersionsResponse>(create);
  static FileVersionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($1.Status v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
  @$pb.TagNumber(1)
  $1.Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<FileVersion> get versions => $_getList(1);
}

class RestoreFileRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RestoreFileRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'versionId')
    ..hasRequiredFields = false
  ;

  RestoreFileRequest._() : super();
  factory RestoreFileRequest({
    $core.String? fileId,
    $core.String? versionId,
  }) {
    final _result = create();
    if (fileId != null) {
      _result.fileId = fileId;
    }
    if (versionId != null) {
      _result.versionId = versionId;
    }
    return _result;
  }
  factory RestoreFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RestoreFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RestoreFileRequest clone() => RestoreFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RestoreFileRequest copyWith(void Function(RestoreFileRequest) updates) => super.copyWith((message) => updates(message as RestoreFileRequest)) as RestoreFileRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RestoreFileRequest create() => RestoreFileRequest._();
  RestoreFileRequest createEmptyInstance() => create();
  static $pb.PbList<RestoreFileRequest> createRepeated() => $pb.PbList<RestoreFileRequest>();
  @$core.pragma('dart2js:noInline')
  static RestoreFileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RestoreFileRequest>(create);
  static RestoreFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get versionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set versionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasVersionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersionId() => clearField(2);
}

class FileResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FileResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', subBuilder: $1.Status.create)
    ..aOM<File>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'file', subBuilder: File.create)
    ..hasRequiredFields = false
  ;

  FileResponse._() : super();
  factory FileResponse({
    $1.Status? status,
    File? file,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    if (file != null) {
      _result.file = file;
    }
    return _result;
  }
  factory FileResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileResponse clone() => FileResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileResponse copyWith(void Function(FileResponse) updates) => super.copyWith((message) => updates(message as FileResponse)) as FileResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FileResponse create() => FileResponse._();
  FileResponse createEmptyInstance() => create();
  static $pb.PbList<FileResponse> createRepeated() => $pb.PbList<FileResponse>();
  @$core.pragma('dart2js:noInline')
  static FileResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileResponse>(create);
  static FileResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($1.Status v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
  @$pb.TagNumber(1)
  $1.Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  File get file => $_getN(1);
  @$pb.TagNumber(2)
  set file(File v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFile() => $_has(1);
  @$pb.TagNumber(2)
  void clearFile() => clearField(2);
  @$pb.TagNumber(2)
  File ensureFile() => $_ensure(1);
}

