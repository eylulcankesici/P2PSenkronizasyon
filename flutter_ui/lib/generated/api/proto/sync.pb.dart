//
//  Generated code. Do not modify.
//  source: api/proto/sync.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $7;
import 'common.pb.dart' as $1;
import 'sync.pbenum.dart';

export 'sync.pbenum.dart';

class SyncFileRequest extends $pb.GeneratedMessage {
  factory SyncFileRequest() => create();
  SyncFileRequest._() : super();
  factory SyncFileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncFileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncFileRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileId')
    ..pPS(2, _omitFieldNames ? '' : 'targetPeerIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncFileRequest clone() => SyncFileRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncFileRequest copyWith(void Function(SyncFileRequest) updates) => super.copyWith((message) => updates(message as SyncFileRequest)) as SyncFileRequest;

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
  factory SyncFileResponse() => create();
  SyncFileResponse._() : super();
  factory SyncFileResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncFileResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncFileResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status', subBuilder: $1.Status.create)
    ..aOM<SyncProgress>(2, _omitFieldNames ? '' : 'progress', subBuilder: SyncProgress.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncFileResponse clone() => SyncFileResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncFileResponse copyWith(void Function(SyncFileResponse) updates) => super.copyWith((message) => updates(message as SyncFileResponse)) as SyncFileResponse;

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
  factory GetSyncStatusRequest() => create();
  GetSyncStatusRequest._() : super();
  factory GetSyncStatusRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetSyncStatusRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetSyncStatusRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'folderId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetSyncStatusRequest clone() => GetSyncStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetSyncStatusRequest copyWith(void Function(GetSyncStatusRequest) updates) => super.copyWith((message) => updates(message as GetSyncStatusRequest)) as GetSyncStatusRequest;

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
  factory SyncStatusResponse() => create();
  SyncStatusResponse._() : super();
  factory SyncStatusResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncStatusResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncStatusResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status', subBuilder: $1.Status.create)
    ..aOM<SyncStatus>(2, _omitFieldNames ? '' : 'syncStatus', subBuilder: SyncStatus.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncStatusResponse clone() => SyncStatusResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncStatusResponse copyWith(void Function(SyncStatusResponse) updates) => super.copyWith((message) => updates(message as SyncStatusResponse)) as SyncStatusResponse;

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
  factory SyncStatus() => create();
  SyncStatus._() : super();
  factory SyncStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncStatus', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'folderId')
    ..a<$core.int>(2, _omitFieldNames ? '' : 'totalFiles', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'syncedFiles', $pb.PbFieldType.O3)
    ..a<$core.int>(4, _omitFieldNames ? '' : 'pendingFiles', $pb.PbFieldType.O3)
    ..aInt64(5, _omitFieldNames ? '' : 'totalSize')
    ..aInt64(6, _omitFieldNames ? '' : 'syncedSize')
    ..aOM<$7.Timestamp>(7, _omitFieldNames ? '' : 'lastSyncTime', subBuilder: $7.Timestamp.create)
    ..aOB(8, _omitFieldNames ? '' : 'isSyncing')
    ..aOS(9, _omitFieldNames ? '' : 'currentOperation')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncStatus clone() => SyncStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncStatus copyWith(void Function(SyncStatus) updates) => super.copyWith((message) => updates(message as SyncStatus)) as SyncStatus;

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
  factory SyncProgress() => create();
  SyncProgress._() : super();
  factory SyncProgress.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncProgress.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncProgress', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'bytesTransferred')
    ..aInt64(2, _omitFieldNames ? '' : 'totalBytes')
    ..a<$core.double>(3, _omitFieldNames ? '' : 'percentage', $pb.PbFieldType.OF)
    ..aInt64(4, _omitFieldNames ? '' : 'speedBps')
    ..aInt64(5, _omitFieldNames ? '' : 'etaSeconds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncProgress clone() => SyncProgress()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncProgress copyWith(void Function(SyncProgress) updates) => super.copyWith((message) => updates(message as SyncProgress)) as SyncProgress;

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
  factory PauseSyncRequest() => create();
  PauseSyncRequest._() : super();
  factory PauseSyncRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PauseSyncRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PauseSyncRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'folderId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PauseSyncRequest clone() => PauseSyncRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PauseSyncRequest copyWith(void Function(PauseSyncRequest) updates) => super.copyWith((message) => updates(message as PauseSyncRequest)) as PauseSyncRequest;

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
  factory ResumeSyncRequest() => create();
  ResumeSyncRequest._() : super();
  factory ResumeSyncRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ResumeSyncRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ResumeSyncRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'folderId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ResumeSyncRequest clone() => ResumeSyncRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ResumeSyncRequest copyWith(void Function(ResumeSyncRequest) updates) => super.copyWith((message) => updates(message as ResumeSyncRequest)) as ResumeSyncRequest;

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
  factory WatchSyncEventsRequest() => create();
  WatchSyncEventsRequest._() : super();
  factory WatchSyncEventsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory WatchSyncEventsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'WatchSyncEventsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'folderId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  WatchSyncEventsRequest clone() => WatchSyncEventsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  WatchSyncEventsRequest copyWith(void Function(WatchSyncEventsRequest) updates) => super.copyWith((message) => updates(message as WatchSyncEventsRequest)) as WatchSyncEventsRequest;

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
  factory SyncEvent() => create();
  SyncEvent._() : super();
  factory SyncEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SyncEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SyncEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..e<SyncEvent_EventType>(1, _omitFieldNames ? '' : 'eventType', $pb.PbFieldType.OE, defaultOrMaker: SyncEvent_EventType.EVENT_TYPE_UNSPECIFIED, valueOf: SyncEvent_EventType.valueOf, enumValues: SyncEvent_EventType.values)
    ..aOS(2, _omitFieldNames ? '' : 'fileId')
    ..aOS(3, _omitFieldNames ? '' : 'filePath')
    ..aOM<$7.Timestamp>(4, _omitFieldNames ? '' : 'timestamp', subBuilder: $7.Timestamp.create)
    ..aOS(5, _omitFieldNames ? '' : 'message')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SyncEvent clone() => SyncEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SyncEvent copyWith(void Function(SyncEvent) updates) => super.copyWith((message) => updates(message as SyncEvent)) as SyncEvent;

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


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
