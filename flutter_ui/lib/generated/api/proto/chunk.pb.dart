// This is a generated file - do not edit.
//
// Generated from api/proto/chunk.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import '../../google/protobuf/timestamp.pb.dart' as $1;

import 'common.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ChunkInfo extends $pb.GeneratedMessage {
  factory ChunkInfo({
    $core.String? hash,
    $fixnum.Int64? size,
    $1.Timestamp? creationTime,
    $core.bool? isLocal,
    $core.int? referenceCount,
  }) {
    final result = create();
    if (hash != null) result.hash = hash;
    if (size != null) result.size = size;
    if (creationTime != null) result.creationTime = creationTime;
    if (isLocal != null) result.isLocal = isLocal;
    if (referenceCount != null) result.referenceCount = referenceCount;
    return result;
  }

  ChunkInfo._();

  factory ChunkInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChunkInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChunkInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'hash')
    ..aInt64(2, _omitFieldNames ? '' : 'size')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'creationTime',
        subBuilder: $1.Timestamp.create)
    ..aOB(4, _omitFieldNames ? '' : 'isLocal')
    ..aI(5, _omitFieldNames ? '' : 'referenceCount')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChunkInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChunkInfo copyWith(void Function(ChunkInfo) updates) =>
      super.copyWith((message) => updates(message as ChunkInfo)) as ChunkInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChunkInfo create() => ChunkInfo._();
  @$core.override
  ChunkInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChunkInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChunkInfo>(create);
  static ChunkInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get hash => $_getSZ(0);
  @$pb.TagNumber(1)
  set hash($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearHash() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get size => $_getI64(1);
  @$pb.TagNumber(2)
  set size($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearSize() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get creationTime => $_getN(2);
  @$pb.TagNumber(3)
  set creationTime($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCreationTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreationTime() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureCreationTime() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get isLocal => $_getBF(3);
  @$pb.TagNumber(4)
  set isLocal($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsLocal() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsLocal() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get referenceCount => $_getIZ(4);
  @$pb.TagNumber(5)
  set referenceCount($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasReferenceCount() => $_has(4);
  @$pb.TagNumber(5)
  void clearReferenceCount() => $_clearField(5);
}

class FileChunkInfo extends $pb.GeneratedMessage {
  factory FileChunkInfo({
    $core.String? fileId,
    $core.String? chunkHash,
    $core.int? chunkIndex,
  }) {
    final result = create();
    if (fileId != null) result.fileId = fileId;
    if (chunkHash != null) result.chunkHash = chunkHash;
    if (chunkIndex != null) result.chunkIndex = chunkIndex;
    return result;
  }

  FileChunkInfo._();

  factory FileChunkInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FileChunkInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FileChunkInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileId')
    ..aOS(2, _omitFieldNames ? '' : 'chunkHash')
    ..aI(3, _omitFieldNames ? '' : 'chunkIndex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileChunkInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileChunkInfo copyWith(void Function(FileChunkInfo) updates) =>
      super.copyWith((message) => updates(message as FileChunkInfo))
          as FileChunkInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileChunkInfo create() => FileChunkInfo._();
  @$core.override
  FileChunkInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FileChunkInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FileChunkInfo>(create);
  static FileChunkInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get chunkHash => $_getSZ(1);
  @$pb.TagNumber(2)
  set chunkHash($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChunkHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearChunkHash() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get chunkIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set chunkIndex($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChunkIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearChunkIndex() => $_clearField(3);
}

/// ChunkFile
class ChunkFileRequest extends $pb.GeneratedMessage {
  factory ChunkFileRequest({
    $core.String? fileId,
    $core.String? filePath,
    $core.String? folderId,
  }) {
    final result = create();
    if (fileId != null) result.fileId = fileId;
    if (filePath != null) result.filePath = filePath;
    if (folderId != null) result.folderId = folderId;
    return result;
  }

  ChunkFileRequest._();

  factory ChunkFileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChunkFileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChunkFileRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileId')
    ..aOS(2, _omitFieldNames ? '' : 'filePath')
    ..aOS(3, _omitFieldNames ? '' : 'folderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChunkFileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChunkFileRequest copyWith(void Function(ChunkFileRequest) updates) =>
      super.copyWith((message) => updates(message as ChunkFileRequest))
          as ChunkFileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChunkFileRequest create() => ChunkFileRequest._();
  @$core.override
  ChunkFileRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChunkFileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChunkFileRequest>(create);
  static ChunkFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get filePath => $_getSZ(1);
  @$pb.TagNumber(2)
  set filePath($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFilePath() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilePath() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get folderId => $_getSZ(2);
  @$pb.TagNumber(3)
  set folderId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFolderId() => $_has(2);
  @$pb.TagNumber(3)
  void clearFolderId() => $_clearField(3);
}

class ChunkFileResponse extends $pb.GeneratedMessage {
  factory ChunkFileResponse({
    $2.Status? status,
    $core.String? globalHash,
    $core.int? chunkCount,
    $fixnum.Int64? totalSize,
    $core.Iterable<ChunkInfo>? chunks,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (globalHash != null) result.globalHash = globalHash;
    if (chunkCount != null) result.chunkCount = chunkCount;
    if (totalSize != null) result.totalSize = totalSize;
    if (chunks != null) result.chunks.addAll(chunks);
    return result;
  }

  ChunkFileResponse._();

  factory ChunkFileResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChunkFileResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChunkFileResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$2.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $2.Status.create)
    ..aOS(2, _omitFieldNames ? '' : 'globalHash')
    ..aI(3, _omitFieldNames ? '' : 'chunkCount')
    ..aInt64(4, _omitFieldNames ? '' : 'totalSize')
    ..pPM<ChunkInfo>(5, _omitFieldNames ? '' : 'chunks',
        subBuilder: ChunkInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChunkFileResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChunkFileResponse copyWith(void Function(ChunkFileResponse) updates) =>
      super.copyWith((message) => updates(message as ChunkFileResponse))
          as ChunkFileResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChunkFileResponse create() => ChunkFileResponse._();
  @$core.override
  ChunkFileResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChunkFileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChunkFileResponse>(create);
  static ChunkFileResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($2.Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get globalHash => $_getSZ(1);
  @$pb.TagNumber(2)
  set globalHash($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasGlobalHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearGlobalHash() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get chunkCount => $_getIZ(2);
  @$pb.TagNumber(3)
  set chunkCount($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChunkCount() => $_has(2);
  @$pb.TagNumber(3)
  void clearChunkCount() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalSize => $_getI64(3);
  @$pb.TagNumber(4)
  set totalSize($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $pb.PbList<ChunkInfo> get chunks => $_getList(4);
}

/// GetFileChunks
class GetFileChunksRequest extends $pb.GeneratedMessage {
  factory GetFileChunksRequest({
    $core.String? fileId,
  }) {
    final result = create();
    if (fileId != null) result.fileId = fileId;
    return result;
  }

  GetFileChunksRequest._();

  factory GetFileChunksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFileChunksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFileChunksRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFileChunksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFileChunksRequest copyWith(void Function(GetFileChunksRequest) updates) =>
      super.copyWith((message) => updates(message as GetFileChunksRequest))
          as GetFileChunksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFileChunksRequest create() => GetFileChunksRequest._();
  @$core.override
  GetFileChunksRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFileChunksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFileChunksRequest>(create);
  static GetFileChunksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => $_clearField(1);
}

class GetFileChunksResponse extends $pb.GeneratedMessage {
  factory GetFileChunksResponse({
    $2.Status? status,
    $core.Iterable<ChunkInfo>? chunks,
    $core.Iterable<FileChunkInfo>? fileChunks,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (chunks != null) result.chunks.addAll(chunks);
    if (fileChunks != null) result.fileChunks.addAll(fileChunks);
    return result;
  }

  GetFileChunksResponse._();

  factory GetFileChunksResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFileChunksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFileChunksResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$2.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $2.Status.create)
    ..pPM<ChunkInfo>(2, _omitFieldNames ? '' : 'chunks',
        subBuilder: ChunkInfo.create)
    ..pPM<FileChunkInfo>(3, _omitFieldNames ? '' : 'fileChunks',
        subBuilder: FileChunkInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFileChunksResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFileChunksResponse copyWith(
          void Function(GetFileChunksResponse) updates) =>
      super.copyWith((message) => updates(message as GetFileChunksResponse))
          as GetFileChunksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFileChunksResponse create() => GetFileChunksResponse._();
  @$core.override
  GetFileChunksResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFileChunksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFileChunksResponse>(create);
  static GetFileChunksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($2.Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<ChunkInfo> get chunks => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<FileChunkInfo> get fileChunks => $_getList(2);
}

/// DownloadChunk (streaming)
class DownloadChunkRequest extends $pb.GeneratedMessage {
  factory DownloadChunkRequest({
    $core.String? chunkHash,
  }) {
    final result = create();
    if (chunkHash != null) result.chunkHash = chunkHash;
    return result;
  }

  DownloadChunkRequest._();

  factory DownloadChunkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DownloadChunkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DownloadChunkRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'chunkHash')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadChunkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DownloadChunkRequest copyWith(void Function(DownloadChunkRequest) updates) =>
      super.copyWith((message) => updates(message as DownloadChunkRequest))
          as DownloadChunkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DownloadChunkRequest create() => DownloadChunkRequest._();
  @$core.override
  DownloadChunkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DownloadChunkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DownloadChunkRequest>(create);
  static DownloadChunkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get chunkHash => $_getSZ(0);
  @$pb.TagNumber(1)
  set chunkHash($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChunkHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearChunkHash() => $_clearField(1);
}

class ChunkDataResponse extends $pb.GeneratedMessage {
  factory ChunkDataResponse({
    $core.List<$core.int>? data,
    $core.int? offset,
    $core.int? totalSize,
  }) {
    final result = create();
    if (data != null) result.data = data;
    if (offset != null) result.offset = offset;
    if (totalSize != null) result.totalSize = totalSize;
    return result;
  }

  ChunkDataResponse._();

  factory ChunkDataResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChunkDataResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChunkDataResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aI(2, _omitFieldNames ? '' : 'offset')
    ..aI(3, _omitFieldNames ? '' : 'totalSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChunkDataResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChunkDataResponse copyWith(void Function(ChunkDataResponse) updates) =>
      super.copyWith((message) => updates(message as ChunkDataResponse))
          as ChunkDataResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChunkDataResponse create() => ChunkDataResponse._();
  @$core.override
  ChunkDataResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChunkDataResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChunkDataResponse>(create);
  static ChunkDataResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get data => $_getN(0);
  @$pb.TagNumber(1)
  set data($core.List<$core.int> value) => $_setBytes(0, value);
  @$pb.TagNumber(1)
  $core.bool hasData() => $_has(0);
  @$pb.TagNumber(1)
  void clearData() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get offset => $_getIZ(1);
  @$pb.TagNumber(2)
  set offset($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasOffset() => $_has(1);
  @$pb.TagNumber(2)
  void clearOffset() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get totalSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalSize() => $_clearField(3);
}

/// UploadChunk (streaming)
class UploadChunkRequest extends $pb.GeneratedMessage {
  factory UploadChunkRequest({
    $core.String? chunkHash,
    $core.List<$core.int>? data,
    $core.int? offset,
    $fixnum.Int64? totalSize,
  }) {
    final result = create();
    if (chunkHash != null) result.chunkHash = chunkHash;
    if (data != null) result.data = data;
    if (offset != null) result.offset = offset;
    if (totalSize != null) result.totalSize = totalSize;
    return result;
  }

  UploadChunkRequest._();

  factory UploadChunkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UploadChunkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UploadChunkRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'chunkHash')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aI(3, _omitFieldNames ? '' : 'offset')
    ..aInt64(4, _omitFieldNames ? '' : 'totalSize')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadChunkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadChunkRequest copyWith(void Function(UploadChunkRequest) updates) =>
      super.copyWith((message) => updates(message as UploadChunkRequest))
          as UploadChunkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadChunkRequest create() => UploadChunkRequest._();
  @$core.override
  UploadChunkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UploadChunkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UploadChunkRequest>(create);
  static UploadChunkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get chunkHash => $_getSZ(0);
  @$pb.TagNumber(1)
  set chunkHash($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChunkHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearChunkHash() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get offset => $_getIZ(2);
  @$pb.TagNumber(3)
  set offset($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalSize => $_getI64(3);
  @$pb.TagNumber(4)
  set totalSize($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasTotalSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalSize() => $_clearField(4);
}

class UploadChunkResponse extends $pb.GeneratedMessage {
  factory UploadChunkResponse({
    $2.Status? status,
    $core.String? chunkHash,
    $core.bool? wasDuplicate,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (chunkHash != null) result.chunkHash = chunkHash;
    if (wasDuplicate != null) result.wasDuplicate = wasDuplicate;
    return result;
  }

  UploadChunkResponse._();

  factory UploadChunkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UploadChunkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UploadChunkResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$2.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $2.Status.create)
    ..aOS(2, _omitFieldNames ? '' : 'chunkHash')
    ..aOB(3, _omitFieldNames ? '' : 'wasDuplicate')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadChunkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UploadChunkResponse copyWith(void Function(UploadChunkResponse) updates) =>
      super.copyWith((message) => updates(message as UploadChunkResponse))
          as UploadChunkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UploadChunkResponse create() => UploadChunkResponse._();
  @$core.override
  UploadChunkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UploadChunkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UploadChunkResponse>(create);
  static UploadChunkResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($2.Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get chunkHash => $_getSZ(1);
  @$pb.TagNumber(2)
  set chunkHash($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChunkHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearChunkHash() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get wasDuplicate => $_getBF(2);
  @$pb.TagNumber(3)
  set wasDuplicate($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasWasDuplicate() => $_has(2);
  @$pb.TagNumber(3)
  void clearWasDuplicate() => $_clearField(3);
}

/// VerifyFileIntegrity
class VerifyFileIntegrityRequest extends $pb.GeneratedMessage {
  factory VerifyFileIntegrityRequest({
    $core.String? fileId,
    $core.String? expectedGlobalHash,
  }) {
    final result = create();
    if (fileId != null) result.fileId = fileId;
    if (expectedGlobalHash != null)
      result.expectedGlobalHash = expectedGlobalHash;
    return result;
  }

  VerifyFileIntegrityRequest._();

  factory VerifyFileIntegrityRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyFileIntegrityRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyFileIntegrityRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileId')
    ..aOS(2, _omitFieldNames ? '' : 'expectedGlobalHash')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyFileIntegrityRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyFileIntegrityRequest copyWith(
          void Function(VerifyFileIntegrityRequest) updates) =>
      super.copyWith(
              (message) => updates(message as VerifyFileIntegrityRequest))
          as VerifyFileIntegrityRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyFileIntegrityRequest create() => VerifyFileIntegrityRequest._();
  @$core.override
  VerifyFileIntegrityRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyFileIntegrityRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyFileIntegrityRequest>(create);
  static VerifyFileIntegrityRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get expectedGlobalHash => $_getSZ(1);
  @$pb.TagNumber(2)
  set expectedGlobalHash($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasExpectedGlobalHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearExpectedGlobalHash() => $_clearField(2);
}

class VerifyFileIntegrityResponse extends $pb.GeneratedMessage {
  factory VerifyFileIntegrityResponse({
    $2.Status? status,
    $core.bool? isValid,
    $core.String? actualGlobalHash,
    $core.Iterable<$core.String>? corruptedChunks,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (isValid != null) result.isValid = isValid;
    if (actualGlobalHash != null) result.actualGlobalHash = actualGlobalHash;
    if (corruptedChunks != null) result.corruptedChunks.addAll(corruptedChunks);
    return result;
  }

  VerifyFileIntegrityResponse._();

  factory VerifyFileIntegrityResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory VerifyFileIntegrityResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'VerifyFileIntegrityResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$2.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $2.Status.create)
    ..aOB(2, _omitFieldNames ? '' : 'isValid')
    ..aOS(3, _omitFieldNames ? '' : 'actualGlobalHash')
    ..pPS(4, _omitFieldNames ? '' : 'corruptedChunks')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyFileIntegrityResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VerifyFileIntegrityResponse copyWith(
          void Function(VerifyFileIntegrityResponse) updates) =>
      super.copyWith(
              (message) => updates(message as VerifyFileIntegrityResponse))
          as VerifyFileIntegrityResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyFileIntegrityResponse create() =>
      VerifyFileIntegrityResponse._();
  @$core.override
  VerifyFileIntegrityResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static VerifyFileIntegrityResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<VerifyFileIntegrityResponse>(create);
  static VerifyFileIntegrityResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($2.Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get isValid => $_getBF(1);
  @$pb.TagNumber(2)
  set isValid($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsValid() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsValid() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get actualGlobalHash => $_getSZ(2);
  @$pb.TagNumber(3)
  set actualGlobalHash($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasActualGlobalHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearActualGlobalHash() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get corruptedChunks => $_getList(3);
}

/// GetDeduplicationStats
class GetDeduplicationStatsRequest extends $pb.GeneratedMessage {
  factory GetDeduplicationStatsRequest() => create();

  GetDeduplicationStatsRequest._();

  factory GetDeduplicationStatsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDeduplicationStatsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDeduplicationStatsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDeduplicationStatsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDeduplicationStatsRequest copyWith(
          void Function(GetDeduplicationStatsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetDeduplicationStatsRequest))
          as GetDeduplicationStatsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDeduplicationStatsRequest create() =>
      GetDeduplicationStatsRequest._();
  @$core.override
  GetDeduplicationStatsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDeduplicationStatsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDeduplicationStatsRequest>(create);
  static GetDeduplicationStatsRequest? _defaultInstance;
}

class GetDeduplicationStatsResponse extends $pb.GeneratedMessage {
  factory GetDeduplicationStatsResponse({
    $2.Status? status,
    $fixnum.Int64? totalChunkReferences,
    $fixnum.Int64? uniqueChunks,
    $fixnum.Int64? savingsBytes,
    $core.double? deduplicationRatio,
    $fixnum.Int64? diskUsageBytes,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (totalChunkReferences != null)
      result.totalChunkReferences = totalChunkReferences;
    if (uniqueChunks != null) result.uniqueChunks = uniqueChunks;
    if (savingsBytes != null) result.savingsBytes = savingsBytes;
    if (deduplicationRatio != null)
      result.deduplicationRatio = deduplicationRatio;
    if (diskUsageBytes != null) result.diskUsageBytes = diskUsageBytes;
    return result;
  }

  GetDeduplicationStatsResponse._();

  factory GetDeduplicationStatsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetDeduplicationStatsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetDeduplicationStatsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$2.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $2.Status.create)
    ..aInt64(2, _omitFieldNames ? '' : 'totalChunkReferences')
    ..aInt64(3, _omitFieldNames ? '' : 'uniqueChunks')
    ..aInt64(4, _omitFieldNames ? '' : 'savingsBytes')
    ..aD(5, _omitFieldNames ? '' : 'deduplicationRatio',
        fieldType: $pb.PbFieldType.OF)
    ..aInt64(6, _omitFieldNames ? '' : 'diskUsageBytes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDeduplicationStatsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetDeduplicationStatsResponse copyWith(
          void Function(GetDeduplicationStatsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetDeduplicationStatsResponse))
          as GetDeduplicationStatsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetDeduplicationStatsResponse create() =>
      GetDeduplicationStatsResponse._();
  @$core.override
  GetDeduplicationStatsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetDeduplicationStatsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetDeduplicationStatsResponse>(create);
  static GetDeduplicationStatsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($2.Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalChunkReferences => $_getI64(1);
  @$pb.TagNumber(2)
  set totalChunkReferences($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalChunkReferences() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalChunkReferences() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get uniqueChunks => $_getI64(2);
  @$pb.TagNumber(3)
  set uniqueChunks($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasUniqueChunks() => $_has(2);
  @$pb.TagNumber(3)
  void clearUniqueChunks() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get savingsBytes => $_getI64(3);
  @$pb.TagNumber(4)
  set savingsBytes($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSavingsBytes() => $_has(3);
  @$pb.TagNumber(4)
  void clearSavingsBytes() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get deduplicationRatio => $_getN(4);
  @$pb.TagNumber(5)
  set deduplicationRatio($core.double value) => $_setFloat(4, value);
  @$pb.TagNumber(5)
  $core.bool hasDeduplicationRatio() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeduplicationRatio() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get diskUsageBytes => $_getI64(5);
  @$pb.TagNumber(6)
  set diskUsageBytes($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDiskUsageBytes() => $_has(5);
  @$pb.TagNumber(6)
  void clearDiskUsageBytes() => $_clearField(6);
}

/// CleanOrphanChunks
class CleanOrphanChunksRequest extends $pb.GeneratedMessage {
  factory CleanOrphanChunksRequest() => create();

  CleanOrphanChunksRequest._();

  factory CleanOrphanChunksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CleanOrphanChunksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CleanOrphanChunksRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CleanOrphanChunksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CleanOrphanChunksRequest copyWith(
          void Function(CleanOrphanChunksRequest) updates) =>
      super.copyWith((message) => updates(message as CleanOrphanChunksRequest))
          as CleanOrphanChunksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CleanOrphanChunksRequest create() => CleanOrphanChunksRequest._();
  @$core.override
  CleanOrphanChunksRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CleanOrphanChunksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CleanOrphanChunksRequest>(create);
  static CleanOrphanChunksRequest? _defaultInstance;
}

class CleanOrphanChunksResponse extends $pb.GeneratedMessage {
  factory CleanOrphanChunksResponse({
    $2.Status? status,
    $core.int? deletedChunks,
    $fixnum.Int64? freedBytes,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (deletedChunks != null) result.deletedChunks = deletedChunks;
    if (freedBytes != null) result.freedBytes = freedBytes;
    return result;
  }

  CleanOrphanChunksResponse._();

  factory CleanOrphanChunksResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CleanOrphanChunksResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CleanOrphanChunksResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$2.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $2.Status.create)
    ..aI(2, _omitFieldNames ? '' : 'deletedChunks')
    ..aInt64(3, _omitFieldNames ? '' : 'freedBytes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CleanOrphanChunksResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CleanOrphanChunksResponse copyWith(
          void Function(CleanOrphanChunksResponse) updates) =>
      super.copyWith((message) => updates(message as CleanOrphanChunksResponse))
          as CleanOrphanChunksResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CleanOrphanChunksResponse create() => CleanOrphanChunksResponse._();
  @$core.override
  CleanOrphanChunksResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CleanOrphanChunksResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CleanOrphanChunksResponse>(create);
  static CleanOrphanChunksResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($2.Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get deletedChunks => $_getIZ(1);
  @$pb.TagNumber(2)
  set deletedChunks($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeletedChunks() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeletedChunks() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get freedBytes => $_getI64(2);
  @$pb.TagNumber(3)
  set freedBytes($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFreedBytes() => $_has(2);
  @$pb.TagNumber(3)
  void clearFreedBytes() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
