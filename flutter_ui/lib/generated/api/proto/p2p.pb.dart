// This is a generated file - do not edit.
//
// Generated from api/proto/p2p.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;
import '../../google/protobuf/timestamp.pb.dart' as $2;

import 'common.pb.dart' as $1;
import 'p2p.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'p2p.pbenum.dart';

class ChunkRequest extends $pb.GeneratedMessage {
  factory ChunkRequest({
    $core.String? chunkHash,
    $core.String? fileId,
    $core.String? requesterDeviceId,
  }) {
    final result = create();
    if (chunkHash != null) result.chunkHash = chunkHash;
    if (fileId != null) result.fileId = fileId;
    if (requesterDeviceId != null) result.requesterDeviceId = requesterDeviceId;
    return result;
  }

  ChunkRequest._();

  factory ChunkRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChunkRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChunkRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'chunkHash')
    ..aOS(2, _omitFieldNames ? '' : 'fileId')
    ..aOS(3, _omitFieldNames ? '' : 'requesterDeviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChunkRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChunkRequest copyWith(void Function(ChunkRequest) updates) =>
      super.copyWith((message) => updates(message as ChunkRequest))
          as ChunkRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChunkRequest create() => ChunkRequest._();
  @$core.override
  ChunkRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChunkRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChunkRequest>(create);
  static ChunkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get chunkHash => $_getSZ(0);
  @$pb.TagNumber(1)
  set chunkHash($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChunkHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearChunkHash() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get fileId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fileId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get requesterDeviceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set requesterDeviceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequesterDeviceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequesterDeviceId() => $_clearField(3);
}

class ChunkResponse extends $pb.GeneratedMessage {
  factory ChunkResponse({
    $1.Status? status,
    $core.List<$core.int>? chunkData,
    $core.String? chunkHash,
    $fixnum.Int64? chunkSize,
    $core.String? fileId,
    $core.int? chunkIndex,
    $core.int? totalChunks,
    $core.String? fileName,
    $core.String? folderName,
    $1.SyncMode? senderSyncMode,
    $1.SyncMode? receiverSyncMode,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (chunkData != null) result.chunkData = chunkData;
    if (chunkHash != null) result.chunkHash = chunkHash;
    if (chunkSize != null) result.chunkSize = chunkSize;
    if (fileId != null) result.fileId = fileId;
    if (chunkIndex != null) result.chunkIndex = chunkIndex;
    if (totalChunks != null) result.totalChunks = totalChunks;
    if (fileName != null) result.fileName = fileName;
    if (folderName != null) result.folderName = folderName;
    if (senderSyncMode != null) result.senderSyncMode = senderSyncMode;
    if (receiverSyncMode != null) result.receiverSyncMode = receiverSyncMode;
    return result;
  }

  ChunkResponse._();

  factory ChunkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChunkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChunkResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'chunkData', $pb.PbFieldType.OY)
    ..aOS(3, _omitFieldNames ? '' : 'chunkHash')
    ..aInt64(4, _omitFieldNames ? '' : 'chunkSize')
    ..aOS(5, _omitFieldNames ? '' : 'fileId')
    ..aI(6, _omitFieldNames ? '' : 'chunkIndex')
    ..aI(7, _omitFieldNames ? '' : 'totalChunks')
    ..aOS(8, _omitFieldNames ? '' : 'fileName')
    ..aOS(9, _omitFieldNames ? '' : 'folderName')
    ..aE<$1.SyncMode>(10, _omitFieldNames ? '' : 'senderSyncMode',
        enumValues: $1.SyncMode.values)
    ..aE<$1.SyncMode>(11, _omitFieldNames ? '' : 'receiverSyncMode',
        enumValues: $1.SyncMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChunkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChunkResponse copyWith(void Function(ChunkResponse) updates) =>
      super.copyWith((message) => updates(message as ChunkResponse))
          as ChunkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChunkResponse create() => ChunkResponse._();
  @$core.override
  ChunkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChunkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChunkResponse>(create);
  static ChunkResponse? _defaultInstance;

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
  $core.List<$core.int> get chunkData => $_getN(1);
  @$pb.TagNumber(2)
  set chunkData($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChunkData() => $_has(1);
  @$pb.TagNumber(2)
  void clearChunkData() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get chunkHash => $_getSZ(2);
  @$pb.TagNumber(3)
  set chunkHash($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasChunkHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearChunkHash() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get chunkSize => $_getI64(3);
  @$pb.TagNumber(4)
  set chunkSize($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChunkSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearChunkSize() => $_clearField(4);

  /// Push-based sync için (opsiyonel)
  @$pb.TagNumber(5)
  $core.String get fileId => $_getSZ(4);
  @$pb.TagNumber(5)
  set fileId($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFileId() => $_has(4);
  @$pb.TagNumber(5)
  void clearFileId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get chunkIndex => $_getIZ(5);
  @$pb.TagNumber(6)
  set chunkIndex($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasChunkIndex() => $_has(5);
  @$pb.TagNumber(6)
  void clearChunkIndex() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get totalChunks => $_getIZ(6);
  @$pb.TagNumber(7)
  set totalChunks($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTotalChunks() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalChunks() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get fileName => $_getSZ(7);
  @$pb.TagNumber(8)
  set fileName($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasFileName() => $_has(7);
  @$pb.TagNumber(8)
  void clearFileName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get folderName => $_getSZ(8);
  @$pb.TagNumber(9)
  set folderName($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFolderName() => $_has(8);
  @$pb.TagNumber(9)
  void clearFolderName() => $_clearField(9);

  @$pb.TagNumber(10)
  $1.SyncMode get senderSyncMode => $_getN(9);
  @$pb.TagNumber(10)
  set senderSyncMode($1.SyncMode value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasSenderSyncMode() => $_has(9);
  @$pb.TagNumber(10)
  void clearSenderSyncMode() => $_clearField(10);

  @$pb.TagNumber(11)
  $1.SyncMode get receiverSyncMode => $_getN(10);
  @$pb.TagNumber(11)
  set receiverSyncMode($1.SyncMode value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasReceiverSyncMode() => $_has(10);
  @$pb.TagNumber(11)
  void clearReceiverSyncMode() => $_clearField(11);
}

class ChunkData extends $pb.GeneratedMessage {
  factory ChunkData({
    $core.String? chunkHash,
    $core.List<$core.int>? data,
    $fixnum.Int64? offset,
    $fixnum.Int64? totalSize,
    $core.bool? isFinal,
  }) {
    final result = create();
    if (chunkHash != null) result.chunkHash = chunkHash;
    if (data != null) result.data = data;
    if (offset != null) result.offset = offset;
    if (totalSize != null) result.totalSize = totalSize;
    if (isFinal != null) result.isFinal = isFinal;
    return result;
  }

  ChunkData._();

  factory ChunkData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChunkData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChunkData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'chunkHash')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aInt64(3, _omitFieldNames ? '' : 'offset')
    ..aInt64(4, _omitFieldNames ? '' : 'totalSize')
    ..aOB(5, _omitFieldNames ? '' : 'isFinal')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChunkData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChunkData copyWith(void Function(ChunkData) updates) =>
      super.copyWith((message) => updates(message as ChunkData)) as ChunkData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChunkData create() => ChunkData._();
  @$core.override
  ChunkData createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChunkData getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChunkData>(create);
  static ChunkData? _defaultInstance;

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
  $fixnum.Int64 get offset => $_getI64(2);
  @$pb.TagNumber(3)
  set offset($fixnum.Int64 value) => $_setInt64(2, value);
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

  @$pb.TagNumber(5)
  $core.bool get isFinal => $_getBF(4);
  @$pb.TagNumber(5)
  set isFinal($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsFinal() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsFinal() => $_clearField(5);
}

class TransferStatus extends $pb.GeneratedMessage {
  factory TransferStatus({
    $1.Status? status,
    $fixnum.Int64? bytesReceived,
    $core.String? receivedHash,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (bytesReceived != null) result.bytesReceived = bytesReceived;
    if (receivedHash != null) result.receivedHash = receivedHash;
    return result;
  }

  TransferStatus._();

  factory TransferStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransferStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransferStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..aInt64(2, _omitFieldNames ? '' : 'bytesReceived')
    ..aOS(3, _omitFieldNames ? '' : 'receivedHash')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferStatus copyWith(void Function(TransferStatus) updates) =>
      super.copyWith((message) => updates(message as TransferStatus))
          as TransferStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransferStatus create() => TransferStatus._();
  @$core.override
  TransferStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TransferStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransferStatus>(create);
  static TransferStatus? _defaultInstance;

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
  $fixnum.Int64 get bytesReceived => $_getI64(1);
  @$pb.TagNumber(2)
  set bytesReceived($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasBytesReceived() => $_has(1);
  @$pb.TagNumber(2)
  void clearBytesReceived() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get receivedHash => $_getSZ(2);
  @$pb.TagNumber(3)
  set receivedHash($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasReceivedHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearReceivedHash() => $_clearField(3);
}

class FileMetadataRequest extends $pb.GeneratedMessage {
  factory FileMetadataRequest({
    $core.String? fileId,
    $core.String? senderDeviceId,
  }) {
    final result = create();
    if (fileId != null) result.fileId = fileId;
    if (senderDeviceId != null) result.senderDeviceId = senderDeviceId;
    return result;
  }

  FileMetadataRequest._();

  factory FileMetadataRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FileMetadataRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FileMetadataRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileId')
    ..aOS(2, _omitFieldNames ? '' : 'senderDeviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileMetadataRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileMetadataRequest copyWith(void Function(FileMetadataRequest) updates) =>
      super.copyWith((message) => updates(message as FileMetadataRequest))
          as FileMetadataRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileMetadataRequest create() => FileMetadataRequest._();
  @$core.override
  FileMetadataRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FileMetadataRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FileMetadataRequest>(create);
  static FileMetadataRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get senderDeviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set senderDeviceId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSenderDeviceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSenderDeviceId() => $_clearField(2);
}

class FileMetadataResponse extends $pb.GeneratedMessage {
  factory FileMetadataResponse({
    $1.Status? status,
    $core.String? fileId,
    $core.String? relativePath,
    $fixnum.Int64? size,
    $core.String? globalHash,
    $core.Iterable<$core.String>? chunkHashes,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (fileId != null) result.fileId = fileId;
    if (relativePath != null) result.relativePath = relativePath;
    if (size != null) result.size = size;
    if (globalHash != null) result.globalHash = globalHash;
    if (chunkHashes != null) result.chunkHashes.addAll(chunkHashes);
    return result;
  }

  FileMetadataResponse._();

  factory FileMetadataResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FileMetadataResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FileMetadataResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..aOS(2, _omitFieldNames ? '' : 'fileId')
    ..aOS(3, _omitFieldNames ? '' : 'relativePath')
    ..aInt64(4, _omitFieldNames ? '' : 'size')
    ..aOS(5, _omitFieldNames ? '' : 'globalHash')
    ..pPS(6, _omitFieldNames ? '' : 'chunkHashes')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileMetadataResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileMetadataResponse copyWith(void Function(FileMetadataResponse) updates) =>
      super.copyWith((message) => updates(message as FileMetadataResponse))
          as FileMetadataResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileMetadataResponse create() => FileMetadataResponse._();
  @$core.override
  FileMetadataResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FileMetadataResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FileMetadataResponse>(create);
  static FileMetadataResponse? _defaultInstance;

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
  $core.String get fileId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fileId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileId() => $_clearField(2);

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
  $core.String get globalHash => $_getSZ(4);
  @$pb.TagNumber(5)
  set globalHash($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasGlobalHash() => $_has(4);
  @$pb.TagNumber(5)
  void clearGlobalHash() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get chunkHashes => $_getList(5);
}

class PingRequest extends $pb.GeneratedMessage {
  factory PingRequest({
    $core.String? deviceId,
    $fixnum.Int64? timestamp,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (timestamp != null) result.timestamp = timestamp;
    return result;
  }

  PingRequest._();

  factory PingRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PingRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PingRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aInt64(2, _omitFieldNames ? '' : 'timestamp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PingRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PingRequest copyWith(void Function(PingRequest) updates) =>
      super.copyWith((message) => updates(message as PingRequest))
          as PingRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PingRequest create() => PingRequest._();
  @$core.override
  PingRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PingRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PingRequest>(create);
  static PingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get timestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set timestamp($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);
}

class PingResponse extends $pb.GeneratedMessage {
  factory PingResponse({
    $1.Status? status,
    $fixnum.Int64? timestamp,
    $fixnum.Int64? latencyMs,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (timestamp != null) result.timestamp = timestamp;
    if (latencyMs != null) result.latencyMs = latencyMs;
    return result;
  }

  PingResponse._();

  factory PingResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PingResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PingResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..aInt64(2, _omitFieldNames ? '' : 'timestamp')
    ..aInt64(3, _omitFieldNames ? '' : 'latencyMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PingResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PingResponse copyWith(void Function(PingResponse) updates) =>
      super.copyWith((message) => updates(message as PingResponse))
          as PingResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PingResponse create() => PingResponse._();
  @$core.override
  PingResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PingResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PingResponse>(create);
  static PingResponse? _defaultInstance;

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
  $fixnum.Int64 get timestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set timestamp($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get latencyMs => $_getI64(2);
  @$pb.TagNumber(3)
  set latencyMs($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLatencyMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearLatencyMs() => $_clearField(3);
}

class ListTransfersRequest extends $pb.GeneratedMessage {
  factory ListTransfersRequest({
    $core.bool? activeOnly,
    $core.bool? completedOnly,
    $core.bool? failedOnly,
  }) {
    final result = create();
    if (activeOnly != null) result.activeOnly = activeOnly;
    if (completedOnly != null) result.completedOnly = completedOnly;
    if (failedOnly != null) result.failedOnly = failedOnly;
    return result;
  }

  ListTransfersRequest._();

  factory ListTransfersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTransfersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTransfersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'activeOnly')
    ..aOB(2, _omitFieldNames ? '' : 'completedOnly')
    ..aOB(3, _omitFieldNames ? '' : 'failedOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTransfersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTransfersRequest copyWith(void Function(ListTransfersRequest) updates) =>
      super.copyWith((message) => updates(message as ListTransfersRequest))
          as ListTransfersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTransfersRequest create() => ListTransfersRequest._();
  @$core.override
  ListTransfersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTransfersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTransfersRequest>(create);
  static ListTransfersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get activeOnly => $_getBF(0);
  @$pb.TagNumber(1)
  set activeOnly($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActiveOnly() => $_has(0);
  @$pb.TagNumber(1)
  void clearActiveOnly() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get completedOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set completedOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCompletedOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompletedOnly() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get failedOnly => $_getBF(2);
  @$pb.TagNumber(3)
  set failedOnly($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFailedOnly() => $_has(2);
  @$pb.TagNumber(3)
  void clearFailedOnly() => $_clearField(3);
}

class ListTransfersResponse extends $pb.GeneratedMessage {
  factory ListTransfersResponse({
    $1.Status? status,
    $core.Iterable<TransferInfo>? transfers,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (transfers != null) result.transfers.addAll(transfers);
    return result;
  }

  ListTransfersResponse._();

  factory ListTransfersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListTransfersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListTransfersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..pPM<TransferInfo>(2, _omitFieldNames ? '' : 'transfers',
        subBuilder: TransferInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTransfersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListTransfersResponse copyWith(
          void Function(ListTransfersResponse) updates) =>
      super.copyWith((message) => updates(message as ListTransfersResponse))
          as ListTransfersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListTransfersResponse create() => ListTransfersResponse._();
  @$core.override
  ListTransfersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListTransfersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListTransfersResponse>(create);
  static ListTransfersResponse? _defaultInstance;

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
  $pb.PbList<TransferInfo> get transfers => $_getList(1);
}

class GetTransferStatusRequest extends $pb.GeneratedMessage {
  factory GetTransferStatusRequest({
    $core.String? fileId,
  }) {
    final result = create();
    if (fileId != null) result.fileId = fileId;
    return result;
  }

  GetTransferStatusRequest._();

  factory GetTransferStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTransferStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTransferStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTransferStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTransferStatusRequest copyWith(
          void Function(GetTransferStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetTransferStatusRequest))
          as GetTransferStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTransferStatusRequest create() => GetTransferStatusRequest._();
  @$core.override
  GetTransferStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTransferStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTransferStatusRequest>(create);
  static GetTransferStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => $_clearField(1);
}

class GetTransferStatusResponse extends $pb.GeneratedMessage {
  factory GetTransferStatusResponse({
    $1.Status? status,
    TransferInfo? transfer,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (transfer != null) result.transfer = transfer;
    return result;
  }

  GetTransferStatusResponse._();

  factory GetTransferStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetTransferStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetTransferStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..aOM<TransferInfo>(2, _omitFieldNames ? '' : 'transfer',
        subBuilder: TransferInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTransferStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetTransferStatusResponse copyWith(
          void Function(GetTransferStatusResponse) updates) =>
      super.copyWith((message) => updates(message as GetTransferStatusResponse))
          as GetTransferStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetTransferStatusResponse create() => GetTransferStatusResponse._();
  @$core.override
  GetTransferStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetTransferStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetTransferStatusResponse>(create);
  static GetTransferStatusResponse? _defaultInstance;

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
  TransferInfo get transfer => $_getN(1);
  @$pb.TagNumber(2)
  set transfer(TransferInfo value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTransfer() => $_has(1);
  @$pb.TagNumber(2)
  void clearTransfer() => $_clearField(2);
  @$pb.TagNumber(2)
  TransferInfo ensureTransfer() => $_ensure(1);
}

class CancelTransferRequest extends $pb.GeneratedMessage {
  factory CancelTransferRequest({
    $core.String? fileId,
  }) {
    final result = create();
    if (fileId != null) result.fileId = fileId;
    return result;
  }

  CancelTransferRequest._();

  factory CancelTransferRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CancelTransferRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CancelTransferRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelTransferRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CancelTransferRequest copyWith(
          void Function(CancelTransferRequest) updates) =>
      super.copyWith((message) => updates(message as CancelTransferRequest))
          as CancelTransferRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CancelTransferRequest create() => CancelTransferRequest._();
  @$core.override
  CancelTransferRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CancelTransferRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CancelTransferRequest>(create);
  static CancelTransferRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => $_clearField(1);
}

/// Transfer iptal bildirimi (peer'dan peer'a)
class TransferCancelNotification extends $pb.GeneratedMessage {
  factory TransferCancelNotification({
    $core.String? fileId,
    $core.String? reason,
  }) {
    final result = create();
    if (fileId != null) result.fileId = fileId;
    if (reason != null) result.reason = reason;
    return result;
  }

  TransferCancelNotification._();

  factory TransferCancelNotification.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransferCancelNotification.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransferCancelNotification',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferCancelNotification clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferCancelNotification copyWith(
          void Function(TransferCancelNotification) updates) =>
      super.copyWith(
              (message) => updates(message as TransferCancelNotification))
          as TransferCancelNotification;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransferCancelNotification create() => TransferCancelNotification._();
  @$core.override
  TransferCancelNotification createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TransferCancelNotification getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransferCancelNotification>(create);
  static TransferCancelNotification? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

/// Transfer bilgisi
class TransferInfo extends $pb.GeneratedMessage {
  factory TransferInfo({
    $core.String? fileId,
    $core.String? fileName,
    $core.String? peerId,
    $core.String? peerName,
    TransferDirection? direction,
    TransferState? state,
    $core.int? totalChunks,
    $core.int? completedChunks,
    $fixnum.Int64? totalBytes,
    $fixnum.Int64? transferredBytes,
    $core.double? progressPercentage,
    $fixnum.Int64? speedBps,
    $2.Timestamp? startTime,
    $2.Timestamp? endTime,
    $core.String? errorMessage,
  }) {
    final result = create();
    if (fileId != null) result.fileId = fileId;
    if (fileName != null) result.fileName = fileName;
    if (peerId != null) result.peerId = peerId;
    if (peerName != null) result.peerName = peerName;
    if (direction != null) result.direction = direction;
    if (state != null) result.state = state;
    if (totalChunks != null) result.totalChunks = totalChunks;
    if (completedChunks != null) result.completedChunks = completedChunks;
    if (totalBytes != null) result.totalBytes = totalBytes;
    if (transferredBytes != null) result.transferredBytes = transferredBytes;
    if (progressPercentage != null)
      result.progressPercentage = progressPercentage;
    if (speedBps != null) result.speedBps = speedBps;
    if (startTime != null) result.startTime = startTime;
    if (endTime != null) result.endTime = endTime;
    if (errorMessage != null) result.errorMessage = errorMessage;
    return result;
  }

  TransferInfo._();

  factory TransferInfo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TransferInfo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TransferInfo',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileId')
    ..aOS(2, _omitFieldNames ? '' : 'fileName')
    ..aOS(3, _omitFieldNames ? '' : 'peerId')
    ..aOS(4, _omitFieldNames ? '' : 'peerName')
    ..aE<TransferDirection>(5, _omitFieldNames ? '' : 'direction',
        enumValues: TransferDirection.values)
    ..aE<TransferState>(6, _omitFieldNames ? '' : 'state',
        enumValues: TransferState.values)
    ..aI(7, _omitFieldNames ? '' : 'totalChunks')
    ..aI(8, _omitFieldNames ? '' : 'completedChunks')
    ..aInt64(9, _omitFieldNames ? '' : 'totalBytes')
    ..aInt64(10, _omitFieldNames ? '' : 'transferredBytes')
    ..aD(11, _omitFieldNames ? '' : 'progressPercentage',
        fieldType: $pb.PbFieldType.OF)
    ..aInt64(12, _omitFieldNames ? '' : 'speedBps')
    ..aOM<$2.Timestamp>(13, _omitFieldNames ? '' : 'startTime',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(14, _omitFieldNames ? '' : 'endTime',
        subBuilder: $2.Timestamp.create)
    ..aOS(15, _omitFieldNames ? '' : 'errorMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferInfo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TransferInfo copyWith(void Function(TransferInfo) updates) =>
      super.copyWith((message) => updates(message as TransferInfo))
          as TransferInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransferInfo create() => TransferInfo._();
  @$core.override
  TransferInfo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TransferInfo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransferInfo>(create);
  static TransferInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get fileName => $_getSZ(1);
  @$pb.TagNumber(2)
  set fileName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFileName() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get peerId => $_getSZ(2);
  @$pb.TagNumber(3)
  set peerId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPeerId() => $_has(2);
  @$pb.TagNumber(3)
  void clearPeerId() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get peerName => $_getSZ(3);
  @$pb.TagNumber(4)
  set peerName($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPeerName() => $_has(3);
  @$pb.TagNumber(4)
  void clearPeerName() => $_clearField(4);

  @$pb.TagNumber(5)
  TransferDirection get direction => $_getN(4);
  @$pb.TagNumber(5)
  set direction(TransferDirection value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasDirection() => $_has(4);
  @$pb.TagNumber(5)
  void clearDirection() => $_clearField(5);

  @$pb.TagNumber(6)
  TransferState get state => $_getN(5);
  @$pb.TagNumber(6)
  set state(TransferState value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasState() => $_has(5);
  @$pb.TagNumber(6)
  void clearState() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get totalChunks => $_getIZ(6);
  @$pb.TagNumber(7)
  set totalChunks($core.int value) => $_setSignedInt32(6, value);
  @$pb.TagNumber(7)
  $core.bool hasTotalChunks() => $_has(6);
  @$pb.TagNumber(7)
  void clearTotalChunks() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.int get completedChunks => $_getIZ(7);
  @$pb.TagNumber(8)
  set completedChunks($core.int value) => $_setSignedInt32(7, value);
  @$pb.TagNumber(8)
  $core.bool hasCompletedChunks() => $_has(7);
  @$pb.TagNumber(8)
  void clearCompletedChunks() => $_clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get totalBytes => $_getI64(8);
  @$pb.TagNumber(9)
  set totalBytes($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(9)
  $core.bool hasTotalBytes() => $_has(8);
  @$pb.TagNumber(9)
  void clearTotalBytes() => $_clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get transferredBytes => $_getI64(9);
  @$pb.TagNumber(10)
  set transferredBytes($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(10)
  $core.bool hasTransferredBytes() => $_has(9);
  @$pb.TagNumber(10)
  void clearTransferredBytes() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get progressPercentage => $_getN(10);
  @$pb.TagNumber(11)
  set progressPercentage($core.double value) => $_setFloat(10, value);
  @$pb.TagNumber(11)
  $core.bool hasProgressPercentage() => $_has(10);
  @$pb.TagNumber(11)
  void clearProgressPercentage() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get speedBps => $_getI64(11);
  @$pb.TagNumber(12)
  set speedBps($fixnum.Int64 value) => $_setInt64(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSpeedBps() => $_has(11);
  @$pb.TagNumber(12)
  void clearSpeedBps() => $_clearField(12);

  @$pb.TagNumber(13)
  $2.Timestamp get startTime => $_getN(12);
  @$pb.TagNumber(13)
  set startTime($2.Timestamp value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasStartTime() => $_has(12);
  @$pb.TagNumber(13)
  void clearStartTime() => $_clearField(13);
  @$pb.TagNumber(13)
  $2.Timestamp ensureStartTime() => $_ensure(12);

  @$pb.TagNumber(14)
  $2.Timestamp get endTime => $_getN(13);
  @$pb.TagNumber(14)
  set endTime($2.Timestamp value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasEndTime() => $_has(13);
  @$pb.TagNumber(14)
  void clearEndTime() => $_clearField(14);
  @$pb.TagNumber(14)
  $2.Timestamp ensureEndTime() => $_ensure(13);

  @$pb.TagNumber(15)
  $core.String get errorMessage => $_getSZ(14);
  @$pb.TagNumber(15)
  set errorMessage($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasErrorMessage() => $_has(14);
  @$pb.TagNumber(15)
  void clearErrorMessage() => $_clearField(15);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
