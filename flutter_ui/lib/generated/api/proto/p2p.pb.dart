//
//  Generated code. Do not modify.
//  source: api/proto/p2p.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $1;

class ChunkRequest extends $pb.GeneratedMessage {
  factory ChunkRequest() => create();
  ChunkRequest._() : super();
  factory ChunkRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChunkRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChunkRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'chunkHash')
    ..aOS(2, _omitFieldNames ? '' : 'fileId')
    ..aOS(3, _omitFieldNames ? '' : 'requesterDeviceId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChunkRequest clone() => ChunkRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChunkRequest copyWith(void Function(ChunkRequest) updates) => super.copyWith((message) => updates(message as ChunkRequest)) as ChunkRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChunkRequest create() => ChunkRequest._();
  ChunkRequest createEmptyInstance() => create();
  static $pb.PbList<ChunkRequest> createRepeated() => $pb.PbList<ChunkRequest>();
  @$core.pragma('dart2js:noInline')
  static ChunkRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChunkRequest>(create);
  static ChunkRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get chunkHash => $_getSZ(0);
  @$pb.TagNumber(1)
  set chunkHash($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChunkHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearChunkHash() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get fileId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fileId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get requesterDeviceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set requesterDeviceId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRequesterDeviceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequesterDeviceId() => clearField(3);
}

class ChunkResponse extends $pb.GeneratedMessage {
  factory ChunkResponse() => create();
  ChunkResponse._() : super();
  factory ChunkResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChunkResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChunkResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status', subBuilder: $1.Status.create)
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'chunkData', $pb.PbFieldType.OY)
    ..aOS(3, _omitFieldNames ? '' : 'chunkHash')
    ..aInt64(4, _omitFieldNames ? '' : 'chunkSize')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChunkResponse clone() => ChunkResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChunkResponse copyWith(void Function(ChunkResponse) updates) => super.copyWith((message) => updates(message as ChunkResponse)) as ChunkResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChunkResponse create() => ChunkResponse._();
  ChunkResponse createEmptyInstance() => create();
  static $pb.PbList<ChunkResponse> createRepeated() => $pb.PbList<ChunkResponse>();
  @$core.pragma('dart2js:noInline')
  static ChunkResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChunkResponse>(create);
  static ChunkResponse? _defaultInstance;

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
  $core.List<$core.int> get chunkData => $_getN(1);
  @$pb.TagNumber(2)
  set chunkData($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasChunkData() => $_has(1);
  @$pb.TagNumber(2)
  void clearChunkData() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get chunkHash => $_getSZ(2);
  @$pb.TagNumber(3)
  set chunkHash($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasChunkHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearChunkHash() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get chunkSize => $_getI64(3);
  @$pb.TagNumber(4)
  set chunkSize($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasChunkSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearChunkSize() => clearField(4);
}

class ChunkData extends $pb.GeneratedMessage {
  factory ChunkData() => create();
  ChunkData._() : super();
  factory ChunkData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChunkData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChunkData', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'chunkHash')
    ..a<$core.List<$core.int>>(2, _omitFieldNames ? '' : 'data', $pb.PbFieldType.OY)
    ..aInt64(3, _omitFieldNames ? '' : 'offset')
    ..aInt64(4, _omitFieldNames ? '' : 'totalSize')
    ..aOB(5, _omitFieldNames ? '' : 'isFinal')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChunkData clone() => ChunkData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChunkData copyWith(void Function(ChunkData) updates) => super.copyWith((message) => updates(message as ChunkData)) as ChunkData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChunkData create() => ChunkData._();
  ChunkData createEmptyInstance() => create();
  static $pb.PbList<ChunkData> createRepeated() => $pb.PbList<ChunkData>();
  @$core.pragma('dart2js:noInline')
  static ChunkData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChunkData>(create);
  static ChunkData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get chunkHash => $_getSZ(0);
  @$pb.TagNumber(1)
  set chunkHash($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasChunkHash() => $_has(0);
  @$pb.TagNumber(1)
  void clearChunkHash() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get data => $_getN(1);
  @$pb.TagNumber(2)
  set data($core.List<$core.int> v) { $_setBytes(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get offset => $_getI64(2);
  @$pb.TagNumber(3)
  set offset($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOffset() => $_has(2);
  @$pb.TagNumber(3)
  void clearOffset() => clearField(3);

  @$pb.TagNumber(4)
  $fixnum.Int64 get totalSize => $_getI64(3);
  @$pb.TagNumber(4)
  set totalSize($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasTotalSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearTotalSize() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isFinal => $_getBF(4);
  @$pb.TagNumber(5)
  set isFinal($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasIsFinal() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsFinal() => clearField(5);
}

class TransferStatus extends $pb.GeneratedMessage {
  factory TransferStatus() => create();
  TransferStatus._() : super();
  factory TransferStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransferStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TransferStatus', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status', subBuilder: $1.Status.create)
    ..aInt64(2, _omitFieldNames ? '' : 'bytesReceived')
    ..aOS(3, _omitFieldNames ? '' : 'receivedHash')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransferStatus clone() => TransferStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransferStatus copyWith(void Function(TransferStatus) updates) => super.copyWith((message) => updates(message as TransferStatus)) as TransferStatus;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TransferStatus create() => TransferStatus._();
  TransferStatus createEmptyInstance() => create();
  static $pb.PbList<TransferStatus> createRepeated() => $pb.PbList<TransferStatus>();
  @$core.pragma('dart2js:noInline')
  static TransferStatus getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransferStatus>(create);
  static TransferStatus? _defaultInstance;

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
  $fixnum.Int64 get bytesReceived => $_getI64(1);
  @$pb.TagNumber(2)
  set bytesReceived($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasBytesReceived() => $_has(1);
  @$pb.TagNumber(2)
  void clearBytesReceived() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get receivedHash => $_getSZ(2);
  @$pb.TagNumber(3)
  set receivedHash($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasReceivedHash() => $_has(2);
  @$pb.TagNumber(3)
  void clearReceivedHash() => clearField(3);
}

class FileMetadataRequest extends $pb.GeneratedMessage {
  factory FileMetadataRequest() => create();
  FileMetadataRequest._() : super();
  factory FileMetadataRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileMetadataRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FileMetadataRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'fileId')
    ..aOS(2, _omitFieldNames ? '' : 'senderDeviceId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileMetadataRequest clone() => FileMetadataRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileMetadataRequest copyWith(void Function(FileMetadataRequest) updates) => super.copyWith((message) => updates(message as FileMetadataRequest)) as FileMetadataRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileMetadataRequest create() => FileMetadataRequest._();
  FileMetadataRequest createEmptyInstance() => create();
  static $pb.PbList<FileMetadataRequest> createRepeated() => $pb.PbList<FileMetadataRequest>();
  @$core.pragma('dart2js:noInline')
  static FileMetadataRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileMetadataRequest>(create);
  static FileMetadataRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get fileId => $_getSZ(0);
  @$pb.TagNumber(1)
  set fileId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFileId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get senderDeviceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set senderDeviceId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSenderDeviceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSenderDeviceId() => clearField(2);
}

class FileMetadataResponse extends $pb.GeneratedMessage {
  factory FileMetadataResponse() => create();
  FileMetadataResponse._() : super();
  factory FileMetadataResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileMetadataResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FileMetadataResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status', subBuilder: $1.Status.create)
    ..aOS(2, _omitFieldNames ? '' : 'fileId')
    ..aOS(3, _omitFieldNames ? '' : 'relativePath')
    ..aInt64(4, _omitFieldNames ? '' : 'size')
    ..aOS(5, _omitFieldNames ? '' : 'globalHash')
    ..pPS(6, _omitFieldNames ? '' : 'chunkHashes')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileMetadataResponse clone() => FileMetadataResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileMetadataResponse copyWith(void Function(FileMetadataResponse) updates) => super.copyWith((message) => updates(message as FileMetadataResponse)) as FileMetadataResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileMetadataResponse create() => FileMetadataResponse._();
  FileMetadataResponse createEmptyInstance() => create();
  static $pb.PbList<FileMetadataResponse> createRepeated() => $pb.PbList<FileMetadataResponse>();
  @$core.pragma('dart2js:noInline')
  static FileMetadataResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileMetadataResponse>(create);
  static FileMetadataResponse? _defaultInstance;

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
  $core.String get fileId => $_getSZ(1);
  @$pb.TagNumber(2)
  set fileId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFileId() => $_has(1);
  @$pb.TagNumber(2)
  void clearFileId() => clearField(2);

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
  $core.String get globalHash => $_getSZ(4);
  @$pb.TagNumber(5)
  set globalHash($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasGlobalHash() => $_has(4);
  @$pb.TagNumber(5)
  void clearGlobalHash() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.String> get chunkHashes => $_getList(5);
}

class PingRequest extends $pb.GeneratedMessage {
  factory PingRequest() => create();
  PingRequest._() : super();
  factory PingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PingRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aInt64(2, _omitFieldNames ? '' : 'timestamp')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PingRequest clone() => PingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PingRequest copyWith(void Function(PingRequest) updates) => super.copyWith((message) => updates(message as PingRequest)) as PingRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PingRequest create() => PingRequest._();
  PingRequest createEmptyInstance() => create();
  static $pb.PbList<PingRequest> createRepeated() => $pb.PbList<PingRequest>();
  @$core.pragma('dart2js:noInline')
  static PingRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PingRequest>(create);
  static PingRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get timestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set timestamp($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => clearField(2);
}

class PingResponse extends $pb.GeneratedMessage {
  factory PingResponse() => create();
  PingResponse._() : super();
  factory PingResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PingResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PingResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status', subBuilder: $1.Status.create)
    ..aInt64(2, _omitFieldNames ? '' : 'timestamp')
    ..aInt64(3, _omitFieldNames ? '' : 'latencyMs')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PingResponse clone() => PingResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PingResponse copyWith(void Function(PingResponse) updates) => super.copyWith((message) => updates(message as PingResponse)) as PingResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PingResponse create() => PingResponse._();
  PingResponse createEmptyInstance() => create();
  static $pb.PbList<PingResponse> createRepeated() => $pb.PbList<PingResponse>();
  @$core.pragma('dart2js:noInline')
  static PingResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PingResponse>(create);
  static PingResponse? _defaultInstance;

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
  $fixnum.Int64 get timestamp => $_getI64(1);
  @$pb.TagNumber(2)
  set timestamp($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get latencyMs => $_getI64(2);
  @$pb.TagNumber(3)
  set latencyMs($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLatencyMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearLatencyMs() => clearField(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
