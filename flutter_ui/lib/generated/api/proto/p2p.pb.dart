///
//  Generated code. Do not modify.
//  source: api/proto/p2p.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $1;

class ChunkRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ChunkRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chunkHash')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'requesterDeviceId')
    ..hasRequiredFields = false
  ;

  ChunkRequest._() : super();
  factory ChunkRequest({
    $core.String? chunkHash,
    $core.String? fileId,
    $core.String? requesterDeviceId,
  }) {
    final _result = create();
    if (chunkHash != null) {
      _result.chunkHash = chunkHash;
    }
    if (fileId != null) {
      _result.fileId = fileId;
    }
    if (requesterDeviceId != null) {
      _result.requesterDeviceId = requesterDeviceId;
    }
    return _result;
  }
  factory ChunkRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChunkRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChunkRequest clone() => ChunkRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChunkRequest copyWith(void Function(ChunkRequest) updates) => super.copyWith((message) => updates(message as ChunkRequest)) as ChunkRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ChunkResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', subBuilder: $1.Status.create)
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chunkData', $pb.PbFieldType.OY)
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chunkHash')
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chunkSize')
    ..hasRequiredFields = false
  ;

  ChunkResponse._() : super();
  factory ChunkResponse({
    $1.Status? status,
    $core.List<$core.int>? chunkData,
    $core.String? chunkHash,
    $fixnum.Int64? chunkSize,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    if (chunkData != null) {
      _result.chunkData = chunkData;
    }
    if (chunkHash != null) {
      _result.chunkHash = chunkHash;
    }
    if (chunkSize != null) {
      _result.chunkSize = chunkSize;
    }
    return _result;
  }
  factory ChunkResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChunkResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChunkResponse clone() => ChunkResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChunkResponse copyWith(void Function(ChunkResponse) updates) => super.copyWith((message) => updates(message as ChunkResponse)) as ChunkResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ChunkData', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chunkHash')
    ..a<$core.List<$core.int>>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'data', $pb.PbFieldType.OY)
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'offset')
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'totalSize')
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isFinal')
    ..hasRequiredFields = false
  ;

  ChunkData._() : super();
  factory ChunkData({
    $core.String? chunkHash,
    $core.List<$core.int>? data,
    $fixnum.Int64? offset,
    $fixnum.Int64? totalSize,
    $core.bool? isFinal,
  }) {
    final _result = create();
    if (chunkHash != null) {
      _result.chunkHash = chunkHash;
    }
    if (data != null) {
      _result.data = data;
    }
    if (offset != null) {
      _result.offset = offset;
    }
    if (totalSize != null) {
      _result.totalSize = totalSize;
    }
    if (isFinal != null) {
      _result.isFinal = isFinal;
    }
    return _result;
  }
  factory ChunkData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChunkData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChunkData clone() => ChunkData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChunkData copyWith(void Function(ChunkData) updates) => super.copyWith((message) => updates(message as ChunkData)) as ChunkData; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TransferStatus', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', subBuilder: $1.Status.create)
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bytesReceived')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receivedHash')
    ..hasRequiredFields = false
  ;

  TransferStatus._() : super();
  factory TransferStatus({
    $1.Status? status,
    $fixnum.Int64? bytesReceived,
    $core.String? receivedHash,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    if (bytesReceived != null) {
      _result.bytesReceived = bytesReceived;
    }
    if (receivedHash != null) {
      _result.receivedHash = receivedHash;
    }
    return _result;
  }
  factory TransferStatus.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransferStatus.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TransferStatus clone() => TransferStatus()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TransferStatus copyWith(void Function(TransferStatus) updates) => super.copyWith((message) => updates(message as TransferStatus)) as TransferStatus; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FileMetadataRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderDeviceId')
    ..hasRequiredFields = false
  ;

  FileMetadataRequest._() : super();
  factory FileMetadataRequest({
    $core.String? fileId,
    $core.String? senderDeviceId,
  }) {
    final _result = create();
    if (fileId != null) {
      _result.fileId = fileId;
    }
    if (senderDeviceId != null) {
      _result.senderDeviceId = senderDeviceId;
    }
    return _result;
  }
  factory FileMetadataRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileMetadataRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileMetadataRequest clone() => FileMetadataRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileMetadataRequest copyWith(void Function(FileMetadataRequest) updates) => super.copyWith((message) => updates(message as FileMetadataRequest)) as FileMetadataRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FileMetadataResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', subBuilder: $1.Status.create)
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'fileId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'relativePath')
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'size')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'globalHash')
    ..pPS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'chunkHashes')
    ..hasRequiredFields = false
  ;

  FileMetadataResponse._() : super();
  factory FileMetadataResponse({
    $1.Status? status,
    $core.String? fileId,
    $core.String? relativePath,
    $fixnum.Int64? size,
    $core.String? globalHash,
    $core.Iterable<$core.String>? chunkHashes,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    if (fileId != null) {
      _result.fileId = fileId;
    }
    if (relativePath != null) {
      _result.relativePath = relativePath;
    }
    if (size != null) {
      _result.size = size;
    }
    if (globalHash != null) {
      _result.globalHash = globalHash;
    }
    if (chunkHashes != null) {
      _result.chunkHashes.addAll(chunkHashes);
    }
    return _result;
  }
  factory FileMetadataResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileMetadataResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FileMetadataResponse clone() => FileMetadataResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FileMetadataResponse copyWith(void Function(FileMetadataResponse) updates) => super.copyWith((message) => updates(message as FileMetadataResponse)) as FileMetadataResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PingRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deviceId')
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestamp')
    ..hasRequiredFields = false
  ;

  PingRequest._() : super();
  factory PingRequest({
    $core.String? deviceId,
    $fixnum.Int64? timestamp,
  }) {
    final _result = create();
    if (deviceId != null) {
      _result.deviceId = deviceId;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    return _result;
  }
  factory PingRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PingRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PingRequest clone() => PingRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PingRequest copyWith(void Function(PingRequest) updates) => super.copyWith((message) => updates(message as PingRequest)) as PingRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PingResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', subBuilder: $1.Status.create)
    ..aInt64(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'timestamp')
    ..aInt64(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'latencyMs')
    ..hasRequiredFields = false
  ;

  PingResponse._() : super();
  factory PingResponse({
    $1.Status? status,
    $fixnum.Int64? timestamp,
    $fixnum.Int64? latencyMs,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    if (timestamp != null) {
      _result.timestamp = timestamp;
    }
    if (latencyMs != null) {
      _result.latencyMs = latencyMs;
    }
    return _result;
  }
  factory PingResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PingResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PingResponse clone() => PingResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PingResponse copyWith(void Function(PingResponse) updates) => super.copyWith((message) => updates(message as PingResponse)) as PingResponse; // ignore: deprecated_member_use
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

