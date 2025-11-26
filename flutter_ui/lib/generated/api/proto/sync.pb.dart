// This is a generated file - do not edit.
//
// Generated from api/proto/sync.proto.

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
import 'sync.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'sync.pbenum.dart';

class SyncFileRequest extends $pb.GeneratedMessage {
  factory SyncFileRequest({
    $core.String? fileId,
    $core.Iterable<$core.String>? targetPeerIds,
    $core.Iterable<PeerSyncMode>? peerSyncModes,
  }) {
    final result = create();
    if (fileId != null) result.fileId = fileId;
    if (targetPeerIds != null) result.targetPeerIds.addAll(targetPeerIds);
    if (peerSyncModes != null) result.peerSyncModes.addAll(peerSyncModes);
    return result;
  }

  SyncFileRequest._();

  factory SyncFileRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SyncFileRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncFileRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileId')
    ..pPS(2, _omitFieldNames ? '' : 'targetPeerIds')
    ..pPM<PeerSyncMode>(3, _omitFieldNames ? '' : 'peerSyncModes',
        subBuilder: PeerSyncMode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncFileRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncFileRequest copyWith(void Function(SyncFileRequest) updates) =>
      super.copyWith((message) => updates(message as SyncFileRequest))
          as SyncFileRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncFileRequest create() => SyncFileRequest._();
  @$core.override
  SyncFileRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SyncFileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SyncFileRequest>(create);
  static SyncFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get targetPeerIds => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<PeerSyncMode> get peerSyncModes => $_getList(2);
}

class PeerSyncMode extends $pb.GeneratedMessage {
  factory PeerSyncMode({
    $core.String? peerId,
    $1.SyncMode? senderMode,
    $1.SyncMode? receiverMode,
  }) {
    final result = create();
    if (peerId != null) result.peerId = peerId;
    if (senderMode != null) result.senderMode = senderMode;
    if (receiverMode != null) result.receiverMode = receiverMode;
    return result;
  }

  PeerSyncMode._();

  factory PeerSyncMode.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PeerSyncMode.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PeerSyncMode',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'peerId')
    ..aE<$1.SyncMode>(2, _omitFieldNames ? '' : 'senderMode',
        enumValues: $1.SyncMode.values)
    ..aE<$1.SyncMode>(3, _omitFieldNames ? '' : 'receiverMode',
        enumValues: $1.SyncMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PeerSyncMode clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PeerSyncMode copyWith(void Function(PeerSyncMode) updates) =>
      super.copyWith((message) => updates(message as PeerSyncMode))
          as PeerSyncMode;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PeerSyncMode create() => PeerSyncMode._();
  @$core.override
  PeerSyncMode createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PeerSyncMode getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PeerSyncMode>(create);
  static PeerSyncMode? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get peerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set peerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPeerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.SyncMode get senderMode => $_getN(1);
  @$pb.TagNumber(2)
  set senderMode($1.SyncMode value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSenderMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearSenderMode() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.SyncMode get receiverMode => $_getN(2);
  @$pb.TagNumber(3)
  set receiverMode($1.SyncMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReceiverMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearReceiverMode() => $_clearField(3);
}

class SyncFileResponse extends $pb.GeneratedMessage {
  factory SyncFileResponse({
    $1.Status? status,
    SyncProgress? progress,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (progress != null) result.progress = progress;
    return result;
  }

  SyncFileResponse._();

  factory SyncFileResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SyncFileResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncFileResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..aOM<SyncProgress>(2, _omitFieldNames ? '' : 'progress',
        subBuilder: SyncProgress.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncFileResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncFileResponse copyWith(void Function(SyncFileResponse) updates) =>
      super.copyWith((message) => updates(message as SyncFileResponse))
          as SyncFileResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncFileResponse create() => SyncFileResponse._();
  @$core.override
  SyncFileResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SyncFileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SyncFileResponse>(create);
  static SyncFileResponse? _defaultInstance;

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
  SyncProgress get progress => $_getN(1);
  @$pb.TagNumber(2)
  set progress(SyncProgress value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearProgress() => $_clearField(2);
  @$pb.TagNumber(2)
  SyncProgress ensureProgress() => $_ensure(1);
}

class SyncFolderRequest extends $pb.GeneratedMessage {
  factory SyncFolderRequest({
    $core.String? folderId,
    $core.Iterable<$core.String>? targetPeerIds,
    $core.Iterable<PeerSyncMode>? peerSyncModes,
  }) {
    final result = create();
    if (folderId != null) result.folderId = folderId;
    if (targetPeerIds != null) result.targetPeerIds.addAll(targetPeerIds);
    if (peerSyncModes != null) result.peerSyncModes.addAll(peerSyncModes);
    return result;
  }

  SyncFolderRequest._();

  factory SyncFolderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SyncFolderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncFolderRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'folderId')
    ..pPS(2, _omitFieldNames ? '' : 'targetPeerIds')
    ..pPM<PeerSyncMode>(3, _omitFieldNames ? '' : 'peerSyncModes',
        subBuilder: PeerSyncMode.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncFolderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncFolderRequest copyWith(void Function(SyncFolderRequest) updates) =>
      super.copyWith((message) => updates(message as SyncFolderRequest))
          as SyncFolderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncFolderRequest create() => SyncFolderRequest._();
  @$core.override
  SyncFolderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SyncFolderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SyncFolderRequest>(create);
  static SyncFolderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get folderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFolderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get targetPeerIds => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<PeerSyncMode> get peerSyncModes => $_getList(2);
}

class SyncFolderResponse extends $pb.GeneratedMessage {
  factory SyncFolderResponse({
    $1.Status? status,
    SyncProgress? progress,
    $core.int? totalFiles,
    $core.int? syncedFiles,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (progress != null) result.progress = progress;
    if (totalFiles != null) result.totalFiles = totalFiles;
    if (syncedFiles != null) result.syncedFiles = syncedFiles;
    return result;
  }

  SyncFolderResponse._();

  factory SyncFolderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SyncFolderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncFolderResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..aOM<SyncProgress>(2, _omitFieldNames ? '' : 'progress',
        subBuilder: SyncProgress.create)
    ..aI(3, _omitFieldNames ? '' : 'totalFiles')
    ..aI(4, _omitFieldNames ? '' : 'syncedFiles')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncFolderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncFolderResponse copyWith(void Function(SyncFolderResponse) updates) =>
      super.copyWith((message) => updates(message as SyncFolderResponse))
          as SyncFolderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncFolderResponse create() => SyncFolderResponse._();
  @$core.override
  SyncFolderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SyncFolderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SyncFolderResponse>(create);
  static SyncFolderResponse? _defaultInstance;

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
  SyncProgress get progress => $_getN(1);
  @$pb.TagNumber(2)
  set progress(SyncProgress value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearProgress() => $_clearField(2);
  @$pb.TagNumber(2)
  SyncProgress ensureProgress() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.int get totalFiles => $_getIZ(2);
  @$pb.TagNumber(3)
  set totalFiles($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTotalFiles() => $_has(2);
  @$pb.TagNumber(3)
  void clearTotalFiles() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get syncedFiles => $_getIZ(3);
  @$pb.TagNumber(4)
  set syncedFiles($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSyncedFiles() => $_has(3);
  @$pb.TagNumber(4)
  void clearSyncedFiles() => $_clearField(4);
}

class GetSyncStatusRequest extends $pb.GeneratedMessage {
  factory GetSyncStatusRequest({
    $core.String? folderId,
  }) {
    final result = create();
    if (folderId != null) result.folderId = folderId;
    return result;
  }

  GetSyncStatusRequest._();

  factory GetSyncStatusRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSyncStatusRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSyncStatusRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'folderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSyncStatusRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSyncStatusRequest copyWith(void Function(GetSyncStatusRequest) updates) =>
      super.copyWith((message) => updates(message as GetSyncStatusRequest))
          as GetSyncStatusRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSyncStatusRequest create() => GetSyncStatusRequest._();
  @$core.override
  GetSyncStatusRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSyncStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSyncStatusRequest>(create);
  static GetSyncStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get folderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFolderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderId() => $_clearField(1);
}

class SyncStatusResponse extends $pb.GeneratedMessage {
  factory SyncStatusResponse({
    $1.Status? status,
    SyncStatus? syncStatus,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (syncStatus != null) result.syncStatus = syncStatus;
    return result;
  }

  SyncStatusResponse._();

  factory SyncStatusResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SyncStatusResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncStatusResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..aOM<SyncStatus>(2, _omitFieldNames ? '' : 'syncStatus',
        subBuilder: SyncStatus.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncStatusResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncStatusResponse copyWith(void Function(SyncStatusResponse) updates) =>
      super.copyWith((message) => updates(message as SyncStatusResponse))
          as SyncStatusResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncStatusResponse create() => SyncStatusResponse._();
  @$core.override
  SyncStatusResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SyncStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SyncStatusResponse>(create);
  static SyncStatusResponse? _defaultInstance;

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
  SyncStatus get syncStatus => $_getN(1);
  @$pb.TagNumber(2)
  set syncStatus(SyncStatus value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSyncStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearSyncStatus() => $_clearField(2);
  @$pb.TagNumber(2)
  SyncStatus ensureSyncStatus() => $_ensure(1);
}

class SyncStatus extends $pb.GeneratedMessage {
  factory SyncStatus({
    $core.String? folderId,
    $core.int? totalFiles,
    $core.int? syncedFiles,
    $core.int? pendingFiles,
    $fixnum.Int64? totalSize,
    $fixnum.Int64? syncedSize,
    $2.Timestamp? lastSyncTime,
    $core.bool? isSyncing,
    $core.String? currentOperation,
  }) {
    final result = create();
    if (folderId != null) result.folderId = folderId;
    if (totalFiles != null) result.totalFiles = totalFiles;
    if (syncedFiles != null) result.syncedFiles = syncedFiles;
    if (pendingFiles != null) result.pendingFiles = pendingFiles;
    if (totalSize != null) result.totalSize = totalSize;
    if (syncedSize != null) result.syncedSize = syncedSize;
    if (lastSyncTime != null) result.lastSyncTime = lastSyncTime;
    if (isSyncing != null) result.isSyncing = isSyncing;
    if (currentOperation != null) result.currentOperation = currentOperation;
    return result;
  }

  SyncStatus._();

  factory SyncStatus.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SyncStatus.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncStatus',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'folderId')
    ..aI(2, _omitFieldNames ? '' : 'totalFiles')
    ..aI(3, _omitFieldNames ? '' : 'syncedFiles')
    ..aI(4, _omitFieldNames ? '' : 'pendingFiles')
    ..aInt64(5, _omitFieldNames ? '' : 'totalSize')
    ..aInt64(6, _omitFieldNames ? '' : 'syncedSize')
    ..aOM<$2.Timestamp>(7, _omitFieldNames ? '' : 'lastSyncTime',
        subBuilder: $2.Timestamp.create)
    ..aOB(8, _omitFieldNames ? '' : 'isSyncing')
    ..aOS(9, _omitFieldNames ? '' : 'currentOperation')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncStatus clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncStatus copyWith(void Function(SyncStatus) updates) =>
      super.copyWith((message) => updates(message as SyncStatus)) as SyncStatus;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncStatus create() => SyncStatus._();
  @$core.override
  SyncStatus createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SyncStatus getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SyncStatus>(create);
  static SyncStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get folderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFolderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get totalFiles => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalFiles($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalFiles() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalFiles() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get syncedFiles => $_getIZ(2);
  @$pb.TagNumber(3)
  set syncedFiles($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasSyncedFiles() => $_has(2);
  @$pb.TagNumber(3)
  void clearSyncedFiles() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get pendingFiles => $_getIZ(3);
  @$pb.TagNumber(4)
  set pendingFiles($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasPendingFiles() => $_has(3);
  @$pb.TagNumber(4)
  void clearPendingFiles() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get totalSize => $_getI64(4);
  @$pb.TagNumber(5)
  set totalSize($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTotalSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalSize() => $_clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get syncedSize => $_getI64(5);
  @$pb.TagNumber(6)
  set syncedSize($fixnum.Int64 value) => $_setInt64(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSyncedSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearSyncedSize() => $_clearField(6);

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
  $core.bool get isSyncing => $_getBF(7);
  @$pb.TagNumber(8)
  set isSyncing($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsSyncing() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsSyncing() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get currentOperation => $_getSZ(8);
  @$pb.TagNumber(9)
  set currentOperation($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasCurrentOperation() => $_has(8);
  @$pb.TagNumber(9)
  void clearCurrentOperation() => $_clearField(9);
}

class SyncProgress extends $pb.GeneratedMessage {
  factory SyncProgress({
    $fixnum.Int64? bytesTransferred,
    $fixnum.Int64? totalBytes,
    $core.double? percentage,
    $fixnum.Int64? speedBps,
    $fixnum.Int64? etaSeconds,
  }) {
    final result = create();
    if (bytesTransferred != null) result.bytesTransferred = bytesTransferred;
    if (totalBytes != null) result.totalBytes = totalBytes;
    if (percentage != null) result.percentage = percentage;
    if (speedBps != null) result.speedBps = speedBps;
    if (etaSeconds != null) result.etaSeconds = etaSeconds;
    return result;
  }

  SyncProgress._();

  factory SyncProgress.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SyncProgress.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncProgress',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'bytesTransferred')
    ..aInt64(2, _omitFieldNames ? '' : 'totalBytes')
    ..aD(3, _omitFieldNames ? '' : 'percentage', fieldType: $pb.PbFieldType.OF)
    ..aInt64(4, _omitFieldNames ? '' : 'speedBps')
    ..aInt64(5, _omitFieldNames ? '' : 'etaSeconds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncProgress clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncProgress copyWith(void Function(SyncProgress) updates) =>
      super.copyWith((message) => updates(message as SyncProgress))
          as SyncProgress;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncProgress create() => SyncProgress._();
  @$core.override
  SyncProgress createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SyncProgress getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SyncProgress>(create);
  static SyncProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get bytesTransferred => $_getI64(0);
  @$pb.TagNumber(1)
  set bytesTransferred($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasBytesTransferred() => $_has(0);
  @$pb.TagNumber(1)
  void clearBytesTransferred() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalBytes => $_getI64(1);
  @$pb.TagNumber(2)
  set totalBytes($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTotalBytes() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalBytes() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get percentage => $_getN(2);
  @$pb.TagNumber(3)
  set percentage($core.double value) => $_setFloat(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPercentage() => $_has(2);
  @$pb.TagNumber(3)
  void clearPercentage() => $_clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get speedBps => $_getI64(3);
  @$pb.TagNumber(4)
  set speedBps($fixnum.Int64 value) => $_setInt64(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSpeedBps() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpeedBps() => $_clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get etaSeconds => $_getI64(4);
  @$pb.TagNumber(5)
  set etaSeconds($fixnum.Int64 value) => $_setInt64(4, value);
  @$pb.TagNumber(5)
  $core.bool hasEtaSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearEtaSeconds() => $_clearField(5);
}

class PauseSyncRequest extends $pb.GeneratedMessage {
  factory PauseSyncRequest({
    $core.String? folderId,
  }) {
    final result = create();
    if (folderId != null) result.folderId = folderId;
    return result;
  }

  PauseSyncRequest._();

  factory PauseSyncRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PauseSyncRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PauseSyncRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'folderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseSyncRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PauseSyncRequest copyWith(void Function(PauseSyncRequest) updates) =>
      super.copyWith((message) => updates(message as PauseSyncRequest))
          as PauseSyncRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PauseSyncRequest create() => PauseSyncRequest._();
  @$core.override
  PauseSyncRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PauseSyncRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PauseSyncRequest>(create);
  static PauseSyncRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get folderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFolderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderId() => $_clearField(1);
}

class ResumeSyncRequest extends $pb.GeneratedMessage {
  factory ResumeSyncRequest({
    $core.String? folderId,
  }) {
    final result = create();
    if (folderId != null) result.folderId = folderId;
    return result;
  }

  ResumeSyncRequest._();

  factory ResumeSyncRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ResumeSyncRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ResumeSyncRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'folderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeSyncRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ResumeSyncRequest copyWith(void Function(ResumeSyncRequest) updates) =>
      super.copyWith((message) => updates(message as ResumeSyncRequest))
          as ResumeSyncRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ResumeSyncRequest create() => ResumeSyncRequest._();
  @$core.override
  ResumeSyncRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ResumeSyncRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ResumeSyncRequest>(create);
  static ResumeSyncRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get folderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFolderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderId() => $_clearField(1);
}

class WatchSyncEventsRequest extends $pb.GeneratedMessage {
  factory WatchSyncEventsRequest({
    $core.String? folderId,
  }) {
    final result = create();
    if (folderId != null) result.folderId = folderId;
    return result;
  }

  WatchSyncEventsRequest._();

  factory WatchSyncEventsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WatchSyncEventsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WatchSyncEventsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'folderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchSyncEventsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WatchSyncEventsRequest copyWith(
          void Function(WatchSyncEventsRequest) updates) =>
      super.copyWith((message) => updates(message as WatchSyncEventsRequest))
          as WatchSyncEventsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WatchSyncEventsRequest create() => WatchSyncEventsRequest._();
  @$core.override
  WatchSyncEventsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WatchSyncEventsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WatchSyncEventsRequest>(create);
  static WatchSyncEventsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get folderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFolderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderId() => $_clearField(1);
}

class SyncEvent extends $pb.GeneratedMessage {
  factory SyncEvent({
    SyncEvent_EventType? eventType,
    $core.String? fileId,
    $core.String? filePath,
    $2.Timestamp? timestamp,
    $core.String? message,
  }) {
    final result = create();
    if (eventType != null) result.eventType = eventType;
    if (fileId != null) result.fileId = fileId;
    if (filePath != null) result.filePath = filePath;
    if (timestamp != null) result.timestamp = timestamp;
    if (message != null) result.message = message;
    return result;
  }

  SyncEvent._();

  factory SyncEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SyncEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SyncEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aE<SyncEvent_EventType>(1, _omitFieldNames ? '' : 'eventType',
        enumValues: SyncEvent_EventType.values)
    ..aOS(2, _omitFieldNames ? '' : 'fileId')
    ..aOS(3, _omitFieldNames ? '' : 'filePath')
    ..aOM<$2.Timestamp>(4, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $2.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SyncEvent copyWith(void Function(SyncEvent) updates) =>
      super.copyWith((message) => updates(message as SyncEvent)) as SyncEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SyncEvent create() => SyncEvent._();
  @$core.override
  SyncEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SyncEvent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncEvent>(create);
  static SyncEvent? _defaultInstance;

  @$pb.TagNumber(1)
  SyncEvent_EventType get eventType => $_getN(0);
  @$pb.TagNumber(1)
  set eventType(SyncEvent_EventType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasEventType() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get fileId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fileId($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get filePath => $_getSZ(2);
  @$pb.TagNumber(3)
  set filePath($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFilePath() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilePath() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.Timestamp get timestamp => $_getN(3);
  @$pb.TagNumber(4)
  set timestamp($2.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Timestamp ensureTimestamp() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get message => $_getSZ(4);
  @$pb.TagNumber(5)
  set message($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearMessage() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
