// This is a generated file - do not edit.
//
// Generated from api/proto/file.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $2;

import 'common.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class File extends $pb.GeneratedMessage {
  factory File({
    $core.String? id,
    $core.String? folderId,
    $core.String? relativePath,
    $fixnum.Int64? size,
    $2.Timestamp? modTime,
    $core.String? globalHash,
    $core.int? chunkCount,
    $core.bool? isDeleted,
    $2.Timestamp? createdAt,
    $2.Timestamp? updatedAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (folderId != null) result.folderId = folderId;
    if (relativePath != null) result.relativePath = relativePath;
    if (size != null) result.size = size;
    if (modTime != null) result.modTime = modTime;
    if (globalHash != null) result.globalHash = globalHash;
    if (chunkCount != null) result.chunkCount = chunkCount;
    if (isDeleted != null) result.isDeleted = isDeleted;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  File._();

  factory File.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory File.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'File',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'folderId')
    ..aOS(3, _omitFieldNames ? '' : 'relativePath')
    ..aInt64(4, _omitFieldNames ? '' : 'size')
    ..aOM<$2.Timestamp>(5, _omitFieldNames ? '' : 'modTime',
        subBuilder: $2.Timestamp.create)
    ..aOS(6, _omitFieldNames ? '' : 'globalHash')
    ..aI(7, _omitFieldNames ? '' : 'chunkCount')
    ..aOB(8, _omitFieldNames ? '' : 'isDeleted')
    ..aOM<$2.Timestamp>(9, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(10, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  File clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  File copyWith(void Function(File) updates) =>
      super.copyWith((message) => updates(message as File)) as File;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static File create() => File._();
  @$core.override
  File createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static File getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<File>(create);
  static File? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get folderId => $_getSZ(1);
  @$pb.TagNumber(2)
  set folderId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFolderId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolderId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get relativePath => $_getSZ(2);
  @$pb.TagNumber(3)
  set relativePath($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRelativePath() => $_has(2);
  @$pb.TagNumber(3)
  void clearRelativePath() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get size => $_getI64(3);
  @$pb.TagNumber(4)
  set size($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $2.Timestamp get modTime => $_getN(4);
  @$pb.TagNumber(5)
  set modTime($2.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasModTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearModTime() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Timestamp ensureModTime() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get globalHash => $_getSZ(5);
  @$pb.TagNumber(6)
  set globalHash($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasGlobalHash() => $_has(5);
  @$pb.TagNumber(6)
  void clearGlobalHash() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get chunkCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set chunkCount($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasChunkCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearChunkCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get isDeleted => $_getBF(7);
  @$pb.TagNumber(8)
  set isDeleted($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsDeleted() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsDeleted() => $_clearField(8);

  @$pb.TagNumber(9)
  $2.Timestamp get createdAt => $_getN(8);
  @$pb.TagNumber(9)
  set createdAt($2.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $2.Timestamp ensureCreatedAt() => $_ensure(8);

  @$pb.TagNumber(10)
  $2.Timestamp get updatedAt => $_getN(9);
  @$pb.TagNumber(10)
  set updatedAt($2.Timestamp value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasUpdatedAt() => $_has(9);
  @$pb.TagNumber(10)
  void clearUpdatedAt() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.Timestamp ensureUpdatedAt() => $_ensure(9);
}

class Chunk extends $pb.GeneratedMessage {
  factory Chunk({
    $core.String? id,
    $core.String? fileId,
    $fixnum.Int64? offset,
    $fixnum.Int64? length,
    $core.Iterable<$core.String>? deviceAvailability,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (fileId != null) result.fileId = fileId;
    if (offset != null) result.offset = offset;
    if (length != null) result.length = length;
    if (deviceAvailability != null)
      result.deviceAvailability.addAll(deviceAvailability);
    return result;
  }

  Chunk._();

  factory Chunk.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Chunk.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Chunk',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'fileId')
    ..aInt64(3, _omitFieldNames ? '' : 'offset')
    ..aInt64(4, _omitFieldNames ? '' : 'length')
    ..pPS(5, _omitFieldNames ? '' : 'deviceAvailability')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chunk clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Chunk copyWith(void Function(Chunk) updates) =>
      super.copyWith((message) => updates(message as Chunk)) as Chunk;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Chunk create() => Chunk._();
  @$core.override
  Chunk createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Chunk getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Chunk>(create);
  static Chunk? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get fileId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fileId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get offset => $_getI64(2);
  @$pb.TagNumber(3)
  set offset($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get length => $_getI64(3);
  @$pb.TagNumber(4)
  set length($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasLength() => $_has(3);
  @$pb.TagNumber(4)
  void clearLength() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get deviceAvailability => $_getList(4);
}

class FileVersion extends $pb.GeneratedMessage {
  factory FileVersion({
    $core.String? id,
    $core.String? fileId,
    $core.int? versionNumber,
    $core.String? backupPath,
    $core.String? originalPath,
    $fixnum.Int64? size,
    $core.String? hash,
    $2.Timestamp? createdAt,
    $core.String? createdByPeerId,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (fileId != null) result.fileId = fileId;
    if (versionNumber != null) result.versionNumber = versionNumber;
    if (backupPath != null) result.backupPath = backupPath;
    if (originalPath != null) result.originalPath = originalPath;
    if (size != null) result.size = size;
    if (hash != null) result.hash = hash;
    if (createdAt != null) result.createdAt = createdAt;
    if (createdByPeerId != null) result.createdByPeerId = createdByPeerId;
    return result;
  }

  FileVersion._();

  factory FileVersion.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FileVersion.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FileVersion',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'fileId')
    ..aI(3, _omitFieldNames ? '' : 'versionNumber')
    ..aOS(4, _omitFieldNames ? '' : 'backupPath')
    ..aOS(5, _omitFieldNames ? '' : 'originalPath')
    ..aInt64(6, _omitFieldNames ? '' : 'size')
    ..aOS(7, _omitFieldNames ? '' : 'hash')
    ..aOM<$2.Timestamp>(8, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.create)
    ..aOS(9, _omitFieldNames ? '' : 'createdByPeerId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileVersion clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileVersion copyWith(void Function(FileVersion) updates) =>
      super.copyWith((message) => updates(message as FileVersion))
          as FileVersion;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileVersion create() => FileVersion._();
  @$core.override
  FileVersion createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FileVersion getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FileVersion>(create);
  static FileVersion? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get fileId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fileId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get versionNumber => $_getIZ(2);
  @$pb.TagNumber(3)
  set versionNumber($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVersionNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearVersionNumber() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get backupPath => $_getSZ(3);
  @$pb.TagNumber(4)
  set backupPath($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBackupPath() => $_has(3);
  @$pb.TagNumber(4)
  void clearBackupPath() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get originalPath => $_getSZ(4);
  @$pb.TagNumber(5)
  set originalPath($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOriginalPath() => $_has(4);
  @$pb.TagNumber(5)
  void clearOriginalPath() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get size => $_getI64(5);
  @$pb.TagNumber(6)
  set size($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearSize() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get hash => $_getSZ(6);
  @$pb.TagNumber(7)
  set hash($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasHash() => $_has(6);
  @$pb.TagNumber(7)
  void clearHash() => $_clearField(7);

  @$pb.TagNumber(8)
  $2.Timestamp get createdAt => $_getN(7);
  @$pb.TagNumber(8)
  set createdAt($2.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => $_clearField(8);
  @$pb.TagNumber(8)
  $2.Timestamp ensureCreatedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $core.String get createdByPeerId => $_getSZ(8);
  @$pb.TagNumber(9)
  set createdByPeerId($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCreatedByPeerId() => $_has(8);
  @$pb.TagNumber(9)
  void clearCreatedByPeerId() => $_clearField(9);
}

class GetFileRequest extends $pb.GeneratedMessage {
  factory GetFileRequest({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  GetFileRequest._();

  factory GetFileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFileRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFileRequest copyWith(void Function(GetFileRequest) updates) =>
      super.copyWith((message) => updates(message as GetFileRequest))
          as GetFileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFileRequest create() => GetFileRequest._();
  @$core.override
  GetFileRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFileRequest>(create);
  static GetFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class ListFilesRequest extends $pb.GeneratedMessage {
  factory ListFilesRequest({
    $core.String? folderId,
    $1.PaginationRequest? pagination,
  }) {
    final result = create();
    if (folderId != null) result.folderId = folderId;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListFilesRequest._();

  factory ListFilesRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFilesRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFilesRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'folderId')
    ..aOM<$1.PaginationRequest>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFilesRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFilesRequest copyWith(void Function(ListFilesRequest) updates) =>
      super.copyWith((message) => updates(message as ListFilesRequest))
          as ListFilesRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFilesRequest create() => ListFilesRequest._();
  @$core.override
  ListFilesRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFilesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFilesRequest>(create);
  static ListFilesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get folderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFolderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.PaginationRequest get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationRequest ensurePagination() => $_ensure(1);
}

class ListFilesResponse extends $pb.GeneratedMessage {
  factory ListFilesResponse({
    $core.Iterable<File>? files,
    $1.PaginationResponse? pagination,
  }) {
    final result = create();
    if (files != null) result.files.addAll(files);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListFilesResponse._();

  factory ListFilesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFilesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFilesResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..pPM<File>(1, _omitFieldNames ? '' : 'files', subBuilder: File.create)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFilesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFilesResponse copyWith(void Function(ListFilesResponse) updates) =>
      super.copyWith((message) => updates(message as ListFilesResponse))
          as ListFilesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFilesResponse create() => ListFilesResponse._();
  @$core.override
  ListFilesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFilesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFilesResponse>(create);
  static ListFilesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<File> get files => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginationResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationResponse ensurePagination() => $_ensure(1);
}

class GetFileInfoRequest extends $pb.GeneratedMessage {
  factory GetFileInfoRequest({
    $core.String? fileId,
  }) {
    final result = create();
    if (fileId != null) result.fileId = fileId;
    return result;
  }

  GetFileInfoRequest._();

  factory GetFileInfoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFileInfoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFileInfoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFileInfoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFileInfoRequest copyWith(void Function(GetFileInfoRequest) updates) =>
      super.copyWith((message) => updates(message as GetFileInfoRequest))
          as GetFileInfoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFileInfoRequest create() => GetFileInfoRequest._();
  @$core.override
  GetFileInfoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFileInfoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFileInfoRequest>(create);
  static GetFileInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => $_clearField(1);
}

class FilePeerSyncInfo extends $pb.GeneratedMessage {
  factory FilePeerSyncInfo({
    $core.String? peerId,
    $core.String? peerName,
    $core.String? senderDeviceId,
    $core.String? senderDeviceName,
    $2.Timestamp? syncedAt,
  }) {
    final result = create();
    if (peerId != null) result.peerId = peerId;
    if (peerName != null) result.peerName = peerName;
    if (senderDeviceId != null) result.senderDeviceId = senderDeviceId;
    if (senderDeviceName != null) result.senderDeviceName = senderDeviceName;
    if (syncedAt != null) result.syncedAt = syncedAt;
    return result;
  }

  FilePeerSyncInfo._();

  factory FilePeerSyncInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FilePeerSyncInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FilePeerSyncInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'peerId')
    ..aOS(2, _omitFieldNames ? '' : 'peerName')
    ..aOS(3, _omitFieldNames ? '' : 'senderDeviceId')
    ..aOS(4, _omitFieldNames ? '' : 'senderDeviceName')
    ..aOM<$2.Timestamp>(5, _omitFieldNames ? '' : 'syncedAt',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FilePeerSyncInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FilePeerSyncInfo copyWith(void Function(FilePeerSyncInfo) updates) =>
      super.copyWith((message) => updates(message as FilePeerSyncInfo))
          as FilePeerSyncInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FilePeerSyncInfo create() => FilePeerSyncInfo._();
  @$core.override
  FilePeerSyncInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FilePeerSyncInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FilePeerSyncInfo>(create);
  static FilePeerSyncInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get peerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set peerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPeerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get peerName => $_getSZ(1);
  @$pb.TagNumber(2)
  set peerName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasPeerName() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeerName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get senderDeviceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set senderDeviceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSenderDeviceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearSenderDeviceId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get senderDeviceName => $_getSZ(3);
  @$pb.TagNumber(4)
  set senderDeviceName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSenderDeviceName() => $_has(3);
  @$pb.TagNumber(4)
  void clearSenderDeviceName() => $_clearField(4);

  @$pb.TagNumber(5)
  $2.Timestamp get syncedAt => $_getN(4);
  @$pb.TagNumber(5)
  set syncedAt($2.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSyncedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearSyncedAt() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Timestamp ensureSyncedAt() => $_ensure(4);
}

class FileInfoResponse extends $pb.GeneratedMessage {
  factory FileInfoResponse({
    $1.Status? status,
    File? file,
    $core.Iterable<Chunk>? chunks,
    $core.Iterable<$core.String>? availablePeers,
    $core.int? versionCount,
    $core.double? syncPercentage,
    $2.Timestamp? lastSyncTime,
    $core.Iterable<FilePeerSyncInfo>? syncInfo,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (file != null) result.file = file;
    if (chunks != null) result.chunks.addAll(chunks);
    if (availablePeers != null) result.availablePeers.addAll(availablePeers);
    if (versionCount != null) result.versionCount = versionCount;
    if (syncPercentage != null) result.syncPercentage = syncPercentage;
    if (lastSyncTime != null) result.lastSyncTime = lastSyncTime;
    if (syncInfo != null) result.syncInfo.addAll(syncInfo);
    return result;
  }

  FileInfoResponse._();

  factory FileInfoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FileInfoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FileInfoResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..aOM<File>(2, _omitFieldNames ? '' : 'file', subBuilder: File.create)
    ..pPM<Chunk>(3, _omitFieldNames ? '' : 'chunks', subBuilder: Chunk.create)
    ..pPS(4, _omitFieldNames ? '' : 'availablePeers')
    ..aI(5, _omitFieldNames ? '' : 'versionCount')
    ..aD(6, _omitFieldNames ? '' : 'syncPercentage',
        fieldType: $pb.PbFieldType.OF)
    ..aOM<$2.Timestamp>(7, _omitFieldNames ? '' : 'lastSyncTime',
        subBuilder: $2.Timestamp.create)
    ..pPM<FilePeerSyncInfo>(8, _omitFieldNames ? '' : 'syncInfo',
        subBuilder: FilePeerSyncInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileInfoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileInfoResponse copyWith(void Function(FileInfoResponse) updates) =>
      super.copyWith((message) => updates(message as FileInfoResponse))
          as FileInfoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileInfoResponse create() => FileInfoResponse._();
  @$core.override
  FileInfoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FileInfoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FileInfoResponse>(create);
  static FileInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($1.Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  File get file => $_getN(1);
  @$pb.TagNumber(2)
  set file(File value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFile() => $_has(1);
  @$pb.TagNumber(2)
  void clearFile() => $_clearField(2);
  @$pb.TagNumber(2)
  File ensureFile() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<Chunk> get chunks => $_getList(2);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get availablePeers => $_getList(3);

  @$pb.TagNumber(5)
  $core.int get versionCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set versionCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasVersionCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersionCount() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get syncPercentage => $_getN(5);
  @$pb.TagNumber(6)
  set syncPercentage($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSyncPercentage() => $_has(5);
  @$pb.TagNumber(6)
  void clearSyncPercentage() => $_clearField(6);

  @$pb.TagNumber(7)
  $2.Timestamp get lastSyncTime => $_getN(6);
  @$pb.TagNumber(7)
  set lastSyncTime($2.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasLastSyncTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearLastSyncTime() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Timestamp ensureLastSyncTime() => $_ensure(6);

  @$pb.TagNumber(8)
  $pb.PbList<FilePeerSyncInfo> get syncInfo => $_getList(7);
}

class DeleteFileRequest extends $pb.GeneratedMessage {
  factory DeleteFileRequest({
    $core.String? fileId,
    $core.bool? deletePhysically,
  }) {
    final result = create();
    if (fileId != null) result.fileId = fileId;
    if (deletePhysically != null) result.deletePhysically = deletePhysically;
    return result;
  }

  DeleteFileRequest._();

  factory DeleteFileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteFileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteFileRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileId')
    ..aOB(2, _omitFieldNames ? '' : 'deletePhysically')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteFileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteFileRequest copyWith(void Function(DeleteFileRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteFileRequest))
          as DeleteFileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteFileRequest create() => DeleteFileRequest._();
  @$core.override
  DeleteFileRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteFileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteFileRequest>(create);
  static DeleteFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get deletePhysically => $_getBF(1);
  @$pb.TagNumber(2)
  set deletePhysically($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeletePhysically() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeletePhysically() => $_clearField(2);
}

class GetFileVersionsRequest extends $pb.GeneratedMessage {
  factory GetFileVersionsRequest({
    $core.String? fileId,
  }) {
    final result = create();
    if (fileId != null) result.fileId = fileId;
    return result;
  }

  GetFileVersionsRequest._();

  factory GetFileVersionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFileVersionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFileVersionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFileVersionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFileVersionsRequest copyWith(
          void Function(GetFileVersionsRequest) updates) =>
      super.copyWith((message) => updates(message as GetFileVersionsRequest))
          as GetFileVersionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFileVersionsRequest create() => GetFileVersionsRequest._();
  @$core.override
  GetFileVersionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFileVersionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFileVersionsRequest>(create);
  static GetFileVersionsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => $_clearField(1);
}

class FileVersionsResponse extends $pb.GeneratedMessage {
  factory FileVersionsResponse({
    $1.Status? status,
    $core.Iterable<FileVersion>? versions,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (versions != null) result.versions.addAll(versions);
    return result;
  }

  FileVersionsResponse._();

  factory FileVersionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FileVersionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FileVersionsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..pPM<FileVersion>(2, _omitFieldNames ? '' : 'versions',
        subBuilder: FileVersion.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileVersionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileVersionsResponse copyWith(void Function(FileVersionsResponse) updates) =>
      super.copyWith((message) => updates(message as FileVersionsResponse))
          as FileVersionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileVersionsResponse create() => FileVersionsResponse._();
  @$core.override
  FileVersionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FileVersionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FileVersionsResponse>(create);
  static FileVersionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($1.Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<FileVersion> get versions => $_getList(1);
}

class RestoreFileRequest extends $pb.GeneratedMessage {
  factory RestoreFileRequest({
    $core.String? fileId,
    $core.String? versionId,
  }) {
    final result = create();
    if (fileId != null) result.fileId = fileId;
    if (versionId != null) result.versionId = versionId;
    return result;
  }

  RestoreFileRequest._();

  factory RestoreFileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RestoreFileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RestoreFileRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileId')
    ..aOS(2, _omitFieldNames ? '' : 'versionId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreFileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RestoreFileRequest copyWith(void Function(RestoreFileRequest) updates) =>
      super.copyWith((message) => updates(message as RestoreFileRequest))
          as RestoreFileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RestoreFileRequest create() => RestoreFileRequest._();
  @$core.override
  RestoreFileRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RestoreFileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RestoreFileRequest>(create);
  static RestoreFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get versionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set versionId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasVersionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersionId() => $_clearField(2);
}

class FileResponse extends $pb.GeneratedMessage {
  factory FileResponse({
    $1.Status? status,
    File? file,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (file != null) result.file = file;
    return result;
  }

  FileResponse._();

  factory FileResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FileResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FileResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..aOM<File>(2, _omitFieldNames ? '' : 'file', subBuilder: File.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileResponse copyWith(void Function(FileResponse) updates) =>
      super.copyWith((message) => updates(message as FileResponse))
          as FileResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileResponse create() => FileResponse._();
  @$core.override
  FileResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FileResponse>(create);
  static FileResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($1.Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  File get file => $_getN(1);
  @$pb.TagNumber(2)
  set file(File value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFile() => $_has(1);
  @$pb.TagNumber(2)
  void clearFile() => $_clearField(2);
  @$pb.TagNumber(2)
  File ensureFile() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
