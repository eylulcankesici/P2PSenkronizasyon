///
//  Generated code. Do not modify.
//  source: api/proto/sync.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $1;
import '../../google/protobuf/timestamp.pb.dart' as $7;

import 'sync.pbenum.dart';

export 'sync.pbenum.dart';

class ScanFolderRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ScanFolderRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'folderId')
    ..hasRequiredFields = false
  ;

  ScanFolderRequest._() : super();
  factory ScanFolderRequest({
    $core.String? folderId,
  }) {
    final _result = create();
    if (folderId != null) {
      _result.folderId = folderId;
    }
    return _result;
  }
  factory ScanFolderRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScanFolderRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScanFolderRequest clone() => ScanFolderRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScanFolderRequest copyWith(void Function(ScanFolderRequest) updates) => super.copyWith((message) => updates(message as ScanFolderRequest)) as ScanFolderRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScanFolderRequest create() => ScanFolderRequest._();
  ScanFolderRequest createEmptyInstance() => create();
  static $pb.PbList<ScanFolderRequest> createRepeated() => $pb.PbList<ScanFolderRequest>();
  @$core.pragma('dart2js:noInline')
  static ScanFolderRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScanFolderRequest>(create);
  static ScanFolderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get folderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFolderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderId() => clearField(1);
}

class ScanFolderResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ScanFolderResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', subBuilder: $1.Status.create)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'filesFound', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'changesDetected', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  ScanFolderResponse._() : super();
  factory ScanFolderResponse({
    $1.Status? status,
    $core.int? filesFound,
    $core.int? changesDetected,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    if (filesFound != null) {
      _result.filesFound = filesFound;
    }
    if (changesDetected != null) {
      _result.changesDetected = changesDetected;
    }
    return _result;
  }
  factory ScanFolderResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScanFolderResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScanFolderResponse clone() => ScanFolderResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScanFolderResponse copyWith(void Function(ScanFolderResponse) updates) => super.copyWith((message) => updates(message as ScanFolderResponse)) as ScanFolderResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScanFolderResponse create() => ScanFolderResponse._();
  ScanFolderResponse createEmptyInstance() => create();
  static $pb.PbList<ScanFolderResponse> createRepeated() => $pb.PbList<ScanFolderResponse>();
  @$core.pragma('dart2js:noInline')
  static ScanFolderResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScanFolderResponse>(create);
  static ScanFolderResponse? _defaultInstance;

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
  $core.int get filesFound => $_getIZ(1);
  @$pb.TagNumber(2)
  set filesFound($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFilesFound() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilesFound() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get changesDetected => $_getIZ(2);
  @$pb.TagNumber(3)
  set changesDetected($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasChangesDetected() => $_has(2);
  @$pb.TagNumber(3)
  void clearChangesDetected() => clearField(3);
}

class SyncFileRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SyncFileRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileId')
    ..pPS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'targetPeerIds')
    ..hasRequiredFields = false
  ;

  SyncFileRequest._() : super();
  factory SyncFileRequest({
    $core.String? fileId,
    $core.Iterable<$core.String>? targetPeerIds,
  }) {
    final _result = create();
    if (fileId != null) {
      _result.fileId = fileId;
    }
    if (targetPeerIds != null) {
      _result.targetPeerIds.addAll(targetPeerIds);
    }
    return _result;
  }
  factory SyncFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncFileRequest clone() => SyncFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncFileRequest copyWith(void Function(SyncFileRequest) updates) => super.copyWith((message) => updates(message as SyncFileRequest)) as SyncFileRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SyncFileRequest create() => SyncFileRequest._();
  SyncFileRequest createEmptyInstance() => create();
  static $pb.PbList<SyncFileRequest> createRepeated() => $pb.PbList<SyncFileRequest>();
  @$core.pragma('dart2js:noInline')
  static SyncFileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncFileRequest>(create);
  static SyncFileRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.String> get targetPeerIds => $_getList(1);
}

class SyncFileResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SyncFileResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', subBuilder: $1.Status.create)
    ..aOM<SyncProgress>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'progress', subBuilder: SyncProgress.create)
    ..hasRequiredFields = false
  ;

  SyncFileResponse._() : super();
  factory SyncFileResponse({
    $1.Status? status,
    SyncProgress? progress,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    if (progress != null) {
      _result.progress = progress;
    }
    return _result;
  }
  factory SyncFileResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncFileResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncFileResponse clone() => SyncFileResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncFileResponse copyWith(void Function(SyncFileResponse) updates) => super.copyWith((message) => updates(message as SyncFileResponse)) as SyncFileResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SyncFileResponse create() => SyncFileResponse._();
  SyncFileResponse createEmptyInstance() => create();
  static $pb.PbList<SyncFileResponse> createRepeated() => $pb.PbList<SyncFileResponse>();
  @$core.pragma('dart2js:noInline')
  static SyncFileResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncFileResponse>(create);
  static SyncFileResponse? _defaultInstance;

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
  SyncProgress get progress => $_getN(1);
  @$pb.TagNumber(2)
  set progress(SyncProgress v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasProgress() => $_has(1);
  @$pb.TagNumber(2)
  void clearProgress() => clearField(2);
  @$pb.TagNumber(2)
  SyncProgress ensureProgress() => $_ensure(1);
}

class GetSyncStatusRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetSyncStatusRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'folderId')
    ..hasRequiredFields = false
  ;

  GetSyncStatusRequest._() : super();
  factory GetSyncStatusRequest({
    $core.String? folderId,
  }) {
    final _result = create();
    if (folderId != null) {
      _result.folderId = folderId;
    }
    return _result;
  }
  factory GetSyncStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSyncStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSyncStatusRequest clone() => GetSyncStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSyncStatusRequest copyWith(void Function(GetSyncStatusRequest) updates) => super.copyWith((message) => updates(message as GetSyncStatusRequest)) as GetSyncStatusRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetSyncStatusRequest create() => GetSyncStatusRequest._();
  GetSyncStatusRequest createEmptyInstance() => create();
  static $pb.PbList<GetSyncStatusRequest> createRepeated() => $pb.PbList<GetSyncStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static GetSyncStatusRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetSyncStatusRequest>(create);
  static GetSyncStatusRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get folderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFolderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderId() => clearField(1);
}

class SyncStatusResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SyncStatusResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', subBuilder: $1.Status.create)
    ..aOM<SyncStatus>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'syncStatus', subBuilder: SyncStatus.create)
    ..hasRequiredFields = false
  ;

  SyncStatusResponse._() : super();
  factory SyncStatusResponse({
    $1.Status? status,
    SyncStatus? syncStatus,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    if (syncStatus != null) {
      _result.syncStatus = syncStatus;
    }
    return _result;
  }
  factory SyncStatusResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncStatusResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncStatusResponse clone() => SyncStatusResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncStatusResponse copyWith(void Function(SyncStatusResponse) updates) => super.copyWith((message) => updates(message as SyncStatusResponse)) as SyncStatusResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SyncStatusResponse create() => SyncStatusResponse._();
  SyncStatusResponse createEmptyInstance() => create();
  static $pb.PbList<SyncStatusResponse> createRepeated() => $pb.PbList<SyncStatusResponse>();
  @$core.pragma('dart2js:noInline')
  static SyncStatusResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncStatusResponse>(create);
  static SyncStatusResponse? _defaultInstance;

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
  SyncStatus get syncStatus => $_getN(1);
  @$pb.TagNumber(2)
  set syncStatus(SyncStatus v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSyncStatus() => $_has(1);
  @$pb.TagNumber(2)
  void clearSyncStatus() => clearField(2);
  @$pb.TagNumber(2)
  SyncStatus ensureSyncStatus() => $_ensure(1);
}

class SyncStatus extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SyncStatus', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'folderId')
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'totalFiles', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'syncedFiles', $pb.PbFieldType.O3)
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pendingFiles', $pb.PbFieldType.O3)
    ..aInt64(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'totalSize')
    ..aInt64(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'syncedSize')
    ..aOM<$7.Timestamp>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastSyncTime', subBuilder: $7.Timestamp.create)
    ..aOB(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isSyncing')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentOperation')
    ..hasRequiredFields = false
  ;

  SyncStatus._() : super();
  factory SyncStatus({
    $core.String? folderId,
    $core.int? totalFiles,
    $core.int? syncedFiles,
    $core.int? pendingFiles,
    $fixnum.Int64? totalSize,
    $fixnum.Int64? syncedSize,
    $7.Timestamp? lastSyncTime,
    $core.bool? isSyncing,
    $core.String? currentOperation,
  }) {
    final _result = create();
    if (folderId != null) {
      _result.folderId = folderId;
    }
    if (totalFiles != null) {
      _result.totalFiles = totalFiles;
    }
    if (syncedFiles != null) {
      _result.syncedFiles = syncedFiles;
    }
    if (pendingFiles != null) {
      _result.pendingFiles = pendingFiles;
    }
    if (totalSize != null) {
      _result.totalSize = totalSize;
    }
    if (syncedSize != null) {
      _result.syncedSize = syncedSize;
    }
    if (lastSyncTime != null) {
      _result.lastSyncTime = lastSyncTime;
    }
    if (isSyncing != null) {
      _result.isSyncing = isSyncing;
    }
    if (currentOperation != null) {
      _result.currentOperation = currentOperation;
    }
    return _result;
  }
  factory SyncStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncStatus clone() => SyncStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncStatus copyWith(void Function(SyncStatus) updates) => super.copyWith((message) => updates(message as SyncStatus)) as SyncStatus; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SyncStatus create() => SyncStatus._();
  SyncStatus createEmptyInstance() => create();
  static $pb.PbList<SyncStatus> createRepeated() => $pb.PbList<SyncStatus>();
  @$core.pragma('dart2js:noInline')
  static SyncStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncStatus>(create);
  static SyncStatus? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get folderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFolderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get totalFiles => $_getIZ(1);
  @$pb.TagNumber(2)
  set totalFiles($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalFiles() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalFiles() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get syncedFiles => $_getIZ(2);
  @$pb.TagNumber(3)
  set syncedFiles($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSyncedFiles() => $_has(2);
  @$pb.TagNumber(3)
  void clearSyncedFiles() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get pendingFiles => $_getIZ(3);
  @$pb.TagNumber(4)
  set pendingFiles($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasPendingFiles() => $_has(3);
  @$pb.TagNumber(4)
  void clearPendingFiles() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get totalSize => $_getI64(4);
  @$pb.TagNumber(5)
  set totalSize($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTotalSize() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalSize() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get syncedSize => $_getI64(5);
  @$pb.TagNumber(6)
  set syncedSize($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSyncedSize() => $_has(5);
  @$pb.TagNumber(6)
  void clearSyncedSize() => clearField(6);

  @$pb.TagNumber(7)
  $7.Timestamp get lastSyncTime => $_getN(6);
  @$pb.TagNumber(7)
  set lastSyncTime($7.Timestamp v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasLastSyncTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearLastSyncTime() => clearField(7);
  @$pb.TagNumber(7)
  $7.Timestamp ensureLastSyncTime() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.bool get isSyncing => $_getBF(7);
  @$pb.TagNumber(8)
  set isSyncing($core.bool v) { $_setBool(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasIsSyncing() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsSyncing() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get currentOperation => $_getSZ(8);
  @$pb.TagNumber(9)
  set currentOperation($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCurrentOperation() => $_has(8);
  @$pb.TagNumber(9)
  void clearCurrentOperation() => clearField(9);
}

class SyncProgress extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SyncProgress', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bytesTransferred')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'totalBytes')
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'percentage', $pb.PbFieldType.OF)
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'speedBps')
    ..aInt64(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'etaSeconds')
    ..hasRequiredFields = false
  ;

  SyncProgress._() : super();
  factory SyncProgress({
    $fixnum.Int64? bytesTransferred,
    $fixnum.Int64? totalBytes,
    $core.double? percentage,
    $fixnum.Int64? speedBps,
    $fixnum.Int64? etaSeconds,
  }) {
    final _result = create();
    if (bytesTransferred != null) {
      _result.bytesTransferred = bytesTransferred;
    }
    if (totalBytes != null) {
      _result.totalBytes = totalBytes;
    }
    if (percentage != null) {
      _result.percentage = percentage;
    }
    if (speedBps != null) {
      _result.speedBps = speedBps;
    }
    if (etaSeconds != null) {
      _result.etaSeconds = etaSeconds;
    }
    return _result;
  }
  factory SyncProgress.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncProgress.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncProgress clone() => SyncProgress()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncProgress copyWith(void Function(SyncProgress) updates) => super.copyWith((message) => updates(message as SyncProgress)) as SyncProgress; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SyncProgress create() => SyncProgress._();
  SyncProgress createEmptyInstance() => create();
  static $pb.PbList<SyncProgress> createRepeated() => $pb.PbList<SyncProgress>();
  @$core.pragma('dart2js:noInline')
  static SyncProgress getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncProgress>(create);
  static SyncProgress? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get bytesTransferred => $_getI64(0);
  @$pb.TagNumber(1)
  set bytesTransferred($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBytesTransferred() => $_has(0);
  @$pb.TagNumber(1)
  void clearBytesTransferred() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get totalBytes => $_getI64(1);
  @$pb.TagNumber(2)
  set totalBytes($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTotalBytes() => $_has(1);
  @$pb.TagNumber(2)
  void clearTotalBytes() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get percentage => $_getN(2);
  @$pb.TagNumber(3)
  set percentage($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPercentage() => $_has(2);
  @$pb.TagNumber(3)
  void clearPercentage() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get speedBps => $_getI64(3);
  @$pb.TagNumber(4)
  set speedBps($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSpeedBps() => $_has(3);
  @$pb.TagNumber(4)
  void clearSpeedBps() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get etaSeconds => $_getI64(4);
  @$pb.TagNumber(5)
  set etaSeconds($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasEtaSeconds() => $_has(4);
  @$pb.TagNumber(5)
  void clearEtaSeconds() => clearField(5);
}

class PauseSyncRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PauseSyncRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'folderId')
    ..hasRequiredFields = false
  ;

  PauseSyncRequest._() : super();
  factory PauseSyncRequest({
    $core.String? folderId,
  }) {
    final _result = create();
    if (folderId != null) {
      _result.folderId = folderId;
    }
    return _result;
  }
  factory PauseSyncRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PauseSyncRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PauseSyncRequest clone() => PauseSyncRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PauseSyncRequest copyWith(void Function(PauseSyncRequest) updates) => super.copyWith((message) => updates(message as PauseSyncRequest)) as PauseSyncRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PauseSyncRequest create() => PauseSyncRequest._();
  PauseSyncRequest createEmptyInstance() => create();
  static $pb.PbList<PauseSyncRequest> createRepeated() => $pb.PbList<PauseSyncRequest>();
  @$core.pragma('dart2js:noInline')
  static PauseSyncRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PauseSyncRequest>(create);
  static PauseSyncRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get folderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFolderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderId() => clearField(1);
}

class ResumeSyncRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ResumeSyncRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'folderId')
    ..hasRequiredFields = false
  ;

  ResumeSyncRequest._() : super();
  factory ResumeSyncRequest({
    $core.String? folderId,
  }) {
    final _result = create();
    if (folderId != null) {
      _result.folderId = folderId;
    }
    return _result;
  }
  factory ResumeSyncRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResumeSyncRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ResumeSyncRequest clone() => ResumeSyncRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ResumeSyncRequest copyWith(void Function(ResumeSyncRequest) updates) => super.copyWith((message) => updates(message as ResumeSyncRequest)) as ResumeSyncRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ResumeSyncRequest create() => ResumeSyncRequest._();
  ResumeSyncRequest createEmptyInstance() => create();
  static $pb.PbList<ResumeSyncRequest> createRepeated() => $pb.PbList<ResumeSyncRequest>();
  @$core.pragma('dart2js:noInline')
  static ResumeSyncRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ResumeSyncRequest>(create);
  static ResumeSyncRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get folderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFolderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderId() => clearField(1);
}

class WatchSyncEventsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'WatchSyncEventsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'folderId')
    ..hasRequiredFields = false
  ;

  WatchSyncEventsRequest._() : super();
  factory WatchSyncEventsRequest({
    $core.String? folderId,
  }) {
    final _result = create();
    if (folderId != null) {
      _result.folderId = folderId;
    }
    return _result;
  }
  factory WatchSyncEventsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WatchSyncEventsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WatchSyncEventsRequest clone() => WatchSyncEventsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WatchSyncEventsRequest copyWith(void Function(WatchSyncEventsRequest) updates) => super.copyWith((message) => updates(message as WatchSyncEventsRequest)) as WatchSyncEventsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static WatchSyncEventsRequest create() => WatchSyncEventsRequest._();
  WatchSyncEventsRequest createEmptyInstance() => create();
  static $pb.PbList<WatchSyncEventsRequest> createRepeated() => $pb.PbList<WatchSyncEventsRequest>();
  @$core.pragma('dart2js:noInline')
  static WatchSyncEventsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<WatchSyncEventsRequest>(create);
  static WatchSyncEventsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get folderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFolderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderId() => clearField(1);
}

class SyncEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SyncEvent', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..e<SyncEvent_EventType>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'eventType', $pb.PbFieldType.OE, defaultOrMaker: SyncEvent_EventType.EVENT_TYPE_UNSPECIFIED, valueOf: SyncEvent_EventType.valueOf, enumValues: SyncEvent_EventType.values)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'filePath')
    ..aOM<$7.Timestamp>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestamp', subBuilder: $7.Timestamp.create)
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'message')
    ..hasRequiredFields = false
  ;

  SyncEvent._() : super();
  factory SyncEvent({
    SyncEvent_EventType? eventType,
    $core.String? fileId,
    $core.String? filePath,
    $7.Timestamp? timestamp,
    $core.String? message,
  }) {
    final _result = create();
    if (eventType != null) {
      _result.eventType = eventType;
    }
    if (fileId != null) {
      _result.fileId = fileId;
    }
    if (filePath != null) {
      _result.filePath = filePath;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    if (message != null) {
      _result.message = message;
    }
    return _result;
  }
  factory SyncEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncEvent clone() => SyncEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncEvent copyWith(void Function(SyncEvent) updates) => super.copyWith((message) => updates(message as SyncEvent)) as SyncEvent; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SyncEvent create() => SyncEvent._();
  SyncEvent createEmptyInstance() => create();
  static $pb.PbList<SyncEvent> createRepeated() => $pb.PbList<SyncEvent>();
  @$core.pragma('dart2js:noInline')
  static SyncEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SyncEvent>(create);
  static SyncEvent? _defaultInstance;

  @$pb.TagNumber(1)
  SyncEvent_EventType get eventType => $_getN(0);
  @$pb.TagNumber(1)
  set eventType(SyncEvent_EventType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasEventType() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventType() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get fileId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fileId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get filePath => $_getSZ(2);
  @$pb.TagNumber(3)
  set filePath($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFilePath() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilePath() => clearField(3);

  @$pb.TagNumber(4)
  $7.Timestamp get timestamp => $_getN(3);
  @$pb.TagNumber(4)
  set timestamp($7.Timestamp v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => clearField(4);
  @$pb.TagNumber(4)
  $7.Timestamp ensureTimestamp() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get message => $_getSZ(4);
  @$pb.TagNumber(5)
  set message($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMessage() => $_has(4);
  @$pb.TagNumber(5)
  void clearMessage() => clearField(5);
}

