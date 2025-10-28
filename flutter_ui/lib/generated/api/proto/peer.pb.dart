//
//  Generated code. Do not modify.
//  source: api/proto/peer.proto
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
import 'common.pbenum.dart' as $1;

class Peer extends $pb.GeneratedMessage {
  factory Peer() => create();
  Peer._() : super();
  factory Peer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Peer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Peer', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..pPS(3, _omitFieldNames ? '' : 'knownAddresses')
    ..aOB(4, _omitFieldNames ? '' : 'isTrusted')
    ..aOM<$7.Timestamp>(5, _omitFieldNames ? '' : 'lastSeen', subBuilder: $7.Timestamp.create)
    ..e<$1.PeerStatus>(6, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: $1.PeerStatus.PEER_STATUS_UNKNOWN, valueOf: $1.PeerStatus.valueOf, enumValues: $1.PeerStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'publicKey')
    ..aOM<$7.Timestamp>(8, _omitFieldNames ? '' : 'createdAt', subBuilder: $7.Timestamp.create)
    ..aOM<$7.Timestamp>(9, _omitFieldNames ? '' : 'updatedAt', subBuilder: $7.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Peer clone() => Peer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Peer copyWith(void Function(Peer) updates) => super.copyWith((message) => updates(message as Peer)) as Peer;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Peer create() => Peer._();
  Peer createEmptyInstance() => create();
  static $pb.PbList<Peer> createRepeated() => $pb.PbList<Peer>();
  @$core.pragma('dart2js:noInline')
  static Peer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Peer>(create);
  static Peer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.String> get knownAddresses => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get isTrusted => $_getBF(3);
  @$pb.TagNumber(4)
  set isTrusted($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsTrusted() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsTrusted() => clearField(4);

  @$pb.TagNumber(5)
  $7.Timestamp get lastSeen => $_getN(4);
  @$pb.TagNumber(5)
  set lastSeen($7.Timestamp v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasLastSeen() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastSeen() => clearField(5);
  @$pb.TagNumber(5)
  $7.Timestamp ensureLastSeen() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.PeerStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status($1.PeerStatus v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get publicKey => $_getSZ(6);
  @$pb.TagNumber(7)
  set publicKey($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasPublicKey() => $_has(6);
  @$pb.TagNumber(7)
  void clearPublicKey() => clearField(7);

  @$pb.TagNumber(8)
  $7.Timestamp get createdAt => $_getN(7);
  @$pb.TagNumber(8)
  set createdAt($7.Timestamp v) { setField(8, v); }
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => clearField(8);
  @$pb.TagNumber(8)
  $7.Timestamp ensureCreatedAt() => $_ensure(7);

  @$pb.TagNumber(9)
  $7.Timestamp get updatedAt => $_getN(8);
  @$pb.TagNumber(9)
  set updatedAt($7.Timestamp v) { setField(9, v); }
  @$pb.TagNumber(9)
  $core.bool hasUpdatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdatedAt() => clearField(9);
  @$pb.TagNumber(9)
  $7.Timestamp ensureUpdatedAt() => $_ensure(8);
}

class DiscoverPeersRequest extends $pb.GeneratedMessage {
  factory DiscoverPeersRequest() => create();
  DiscoverPeersRequest._() : super();
  factory DiscoverPeersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DiscoverPeersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DiscoverPeersRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'lanOnly')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DiscoverPeersRequest clone() => DiscoverPeersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DiscoverPeersRequest copyWith(void Function(DiscoverPeersRequest) updates) => super.copyWith((message) => updates(message as DiscoverPeersRequest)) as DiscoverPeersRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscoverPeersRequest create() => DiscoverPeersRequest._();
  DiscoverPeersRequest createEmptyInstance() => create();
  static $pb.PbList<DiscoverPeersRequest> createRepeated() => $pb.PbList<DiscoverPeersRequest>();
  @$core.pragma('dart2js:noInline')
  static DiscoverPeersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DiscoverPeersRequest>(create);
  static DiscoverPeersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get lanOnly => $_getBF(0);
  @$pb.TagNumber(1)
  set lanOnly($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLanOnly() => $_has(0);
  @$pb.TagNumber(1)
  void clearLanOnly() => clearField(1);
}

class DiscoverPeersResponse extends $pb.GeneratedMessage {
  factory DiscoverPeersResponse() => create();
  DiscoverPeersResponse._() : super();
  factory DiscoverPeersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DiscoverPeersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DiscoverPeersResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status', subBuilder: $1.Status.create)
    ..pc<Peer>(2, _omitFieldNames ? '' : 'peers', $pb.PbFieldType.PM, subBuilder: Peer.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DiscoverPeersResponse clone() => DiscoverPeersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DiscoverPeersResponse copyWith(void Function(DiscoverPeersResponse) updates) => super.copyWith((message) => updates(message as DiscoverPeersResponse)) as DiscoverPeersResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscoverPeersResponse create() => DiscoverPeersResponse._();
  DiscoverPeersResponse createEmptyInstance() => create();
  static $pb.PbList<DiscoverPeersResponse> createRepeated() => $pb.PbList<DiscoverPeersResponse>();
  @$core.pragma('dart2js:noInline')
  static DiscoverPeersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DiscoverPeersResponse>(create);
  static DiscoverPeersResponse? _defaultInstance;

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
  $core.List<Peer> get peers => $_getList(1);
}

class ConnectToPeerRequest extends $pb.GeneratedMessage {
  factory ConnectToPeerRequest() => create();
  ConnectToPeerRequest._() : super();
  factory ConnectToPeerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectToPeerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConnectToPeerRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'peerId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectToPeerRequest clone() => ConnectToPeerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectToPeerRequest copyWith(void Function(ConnectToPeerRequest) updates) => super.copyWith((message) => updates(message as ConnectToPeerRequest)) as ConnectToPeerRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectToPeerRequest create() => ConnectToPeerRequest._();
  ConnectToPeerRequest createEmptyInstance() => create();
  static $pb.PbList<ConnectToPeerRequest> createRepeated() => $pb.PbList<ConnectToPeerRequest>();
  @$core.pragma('dart2js:noInline')
  static ConnectToPeerRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectToPeerRequest>(create);
  static ConnectToPeerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get peerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set peerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPeerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerId() => clearField(1);
}

class DisconnectFromPeerRequest extends $pb.GeneratedMessage {
  factory DisconnectFromPeerRequest() => create();
  DisconnectFromPeerRequest._() : super();
  factory DisconnectFromPeerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DisconnectFromPeerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DisconnectFromPeerRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'peerId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DisconnectFromPeerRequest clone() => DisconnectFromPeerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DisconnectFromPeerRequest copyWith(void Function(DisconnectFromPeerRequest) updates) => super.copyWith((message) => updates(message as DisconnectFromPeerRequest)) as DisconnectFromPeerRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisconnectFromPeerRequest create() => DisconnectFromPeerRequest._();
  DisconnectFromPeerRequest createEmptyInstance() => create();
  static $pb.PbList<DisconnectFromPeerRequest> createRepeated() => $pb.PbList<DisconnectFromPeerRequest>();
  @$core.pragma('dart2js:noInline')
  static DisconnectFromPeerRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DisconnectFromPeerRequest>(create);
  static DisconnectFromPeerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get peerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set peerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPeerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerId() => clearField(1);
}

class ListPeersRequest extends $pb.GeneratedMessage {
  factory ListPeersRequest() => create();
  ListPeersRequest._() : super();
  factory ListPeersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListPeersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListPeersRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'onlineOnly')
    ..aOB(2, _omitFieldNames ? '' : 'trustedOnly')
    ..aOM<$1.PaginationRequest>(3, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationRequest.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListPeersRequest clone() => ListPeersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListPeersRequest copyWith(void Function(ListPeersRequest) updates) => super.copyWith((message) => updates(message as ListPeersRequest)) as ListPeersRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPeersRequest create() => ListPeersRequest._();
  ListPeersRequest createEmptyInstance() => create();
  static $pb.PbList<ListPeersRequest> createRepeated() => $pb.PbList<ListPeersRequest>();
  @$core.pragma('dart2js:noInline')
  static ListPeersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPeersRequest>(create);
  static ListPeersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get onlineOnly => $_getBF(0);
  @$pb.TagNumber(1)
  set onlineOnly($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOnlineOnly() => $_has(0);
  @$pb.TagNumber(1)
  void clearOnlineOnly() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get trustedOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set trustedOnly($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTrustedOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrustedOnly() => clearField(2);

  @$pb.TagNumber(3)
  $1.PaginationRequest get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($1.PaginationRequest v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => clearField(3);
  @$pb.TagNumber(3)
  $1.PaginationRequest ensurePagination() => $_ensure(2);
}

class ListPeersResponse extends $pb.GeneratedMessage {
  factory ListPeersResponse() => create();
  ListPeersResponse._() : super();
  factory ListPeersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListPeersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ListPeersResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..pc<Peer>(1, _omitFieldNames ? '' : 'peers', $pb.PbFieldType.PM, subBuilder: Peer.create)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination', subBuilder: $1.PaginationResponse.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListPeersResponse clone() => ListPeersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListPeersResponse copyWith(void Function(ListPeersResponse) updates) => super.copyWith((message) => updates(message as ListPeersResponse)) as ListPeersResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPeersResponse create() => ListPeersResponse._();
  ListPeersResponse createEmptyInstance() => create();
  static $pb.PbList<ListPeersResponse> createRepeated() => $pb.PbList<ListPeersResponse>();
  @$core.pragma('dart2js:noInline')
  static ListPeersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListPeersResponse>(create);
  static ListPeersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Peer> get peers => $_getList(0);

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

class GetPeerInfoRequest extends $pb.GeneratedMessage {
  factory GetPeerInfoRequest() => create();
  GetPeerInfoRequest._() : super();
  factory GetPeerInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetPeerInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetPeerInfoRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'peerId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetPeerInfoRequest clone() => GetPeerInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetPeerInfoRequest copyWith(void Function(GetPeerInfoRequest) updates) => super.copyWith((message) => updates(message as GetPeerInfoRequest)) as GetPeerInfoRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPeerInfoRequest create() => GetPeerInfoRequest._();
  GetPeerInfoRequest createEmptyInstance() => create();
  static $pb.PbList<GetPeerInfoRequest> createRepeated() => $pb.PbList<GetPeerInfoRequest>();
  @$core.pragma('dart2js:noInline')
  static GetPeerInfoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetPeerInfoRequest>(create);
  static GetPeerInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get peerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set peerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPeerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerId() => clearField(1);
}

class PeerInfoResponse extends $pb.GeneratedMessage {
  factory PeerInfoResponse() => create();
  PeerInfoResponse._() : super();
  factory PeerInfoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PeerInfoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PeerInfoResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status', subBuilder: $1.Status.create)
    ..aOM<Peer>(2, _omitFieldNames ? '' : 'peer', subBuilder: Peer.create)
    ..pPS(3, _omitFieldNames ? '' : 'sharedFolders')
    ..a<$core.int>(4, _omitFieldNames ? '' : 'sharedFiles', $pb.PbFieldType.O3)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'totalChunks', $pb.PbFieldType.O3)
    ..aOM<$7.Timestamp>(6, _omitFieldNames ? '' : 'lastActivity', subBuilder: $7.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'connectionType')
    ..aInt64(8, _omitFieldNames ? '' : 'latencyMs')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PeerInfoResponse clone() => PeerInfoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PeerInfoResponse copyWith(void Function(PeerInfoResponse) updates) => super.copyWith((message) => updates(message as PeerInfoResponse)) as PeerInfoResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PeerInfoResponse create() => PeerInfoResponse._();
  PeerInfoResponse createEmptyInstance() => create();
  static $pb.PbList<PeerInfoResponse> createRepeated() => $pb.PbList<PeerInfoResponse>();
  @$core.pragma('dart2js:noInline')
  static PeerInfoResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PeerInfoResponse>(create);
  static PeerInfoResponse? _defaultInstance;

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
  Peer get peer => $_getN(1);
  @$pb.TagNumber(2)
  set peer(Peer v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPeer() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeer() => clearField(2);
  @$pb.TagNumber(2)
  Peer ensurePeer() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.List<$core.String> get sharedFolders => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get sharedFiles => $_getIZ(3);
  @$pb.TagNumber(4)
  set sharedFiles($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSharedFiles() => $_has(3);
  @$pb.TagNumber(4)
  void clearSharedFiles() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get totalChunks => $_getIZ(4);
  @$pb.TagNumber(5)
  set totalChunks($core.int v) { $_setSignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasTotalChunks() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalChunks() => clearField(5);

  @$pb.TagNumber(6)
  $7.Timestamp get lastActivity => $_getN(5);
  @$pb.TagNumber(6)
  set lastActivity($7.Timestamp v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasLastActivity() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastActivity() => clearField(6);
  @$pb.TagNumber(6)
  $7.Timestamp ensureLastActivity() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get connectionType => $_getSZ(6);
  @$pb.TagNumber(7)
  set connectionType($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasConnectionType() => $_has(6);
  @$pb.TagNumber(7)
  void clearConnectionType() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get latencyMs => $_getI64(7);
  @$pb.TagNumber(8)
  set latencyMs($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasLatencyMs() => $_has(7);
  @$pb.TagNumber(8)
  void clearLatencyMs() => clearField(8);
}

class TrustPeerRequest extends $pb.GeneratedMessage {
  factory TrustPeerRequest() => create();
  TrustPeerRequest._() : super();
  factory TrustPeerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrustPeerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrustPeerRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'peerId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrustPeerRequest clone() => TrustPeerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrustPeerRequest copyWith(void Function(TrustPeerRequest) updates) => super.copyWith((message) => updates(message as TrustPeerRequest)) as TrustPeerRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrustPeerRequest create() => TrustPeerRequest._();
  TrustPeerRequest createEmptyInstance() => create();
  static $pb.PbList<TrustPeerRequest> createRepeated() => $pb.PbList<TrustPeerRequest>();
  @$core.pragma('dart2js:noInline')
  static TrustPeerRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrustPeerRequest>(create);
  static TrustPeerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get peerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set peerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPeerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerId() => clearField(1);
}

class UntrustPeerRequest extends $pb.GeneratedMessage {
  factory UntrustPeerRequest() => create();
  UntrustPeerRequest._() : super();
  factory UntrustPeerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UntrustPeerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UntrustPeerRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'peerId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UntrustPeerRequest clone() => UntrustPeerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UntrustPeerRequest copyWith(void Function(UntrustPeerRequest) updates) => super.copyWith((message) => updates(message as UntrustPeerRequest)) as UntrustPeerRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UntrustPeerRequest create() => UntrustPeerRequest._();
  UntrustPeerRequest createEmptyInstance() => create();
  static $pb.PbList<UntrustPeerRequest> createRepeated() => $pb.PbList<UntrustPeerRequest>();
  @$core.pragma('dart2js:noInline')
  static UntrustPeerRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UntrustPeerRequest>(create);
  static UntrustPeerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get peerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set peerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPeerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerId() => clearField(1);
}

class RemovePeerRequest extends $pb.GeneratedMessage {
  factory RemovePeerRequest() => create();
  RemovePeerRequest._() : super();
  factory RemovePeerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemovePeerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RemovePeerRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'peerId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemovePeerRequest clone() => RemovePeerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemovePeerRequest copyWith(void Function(RemovePeerRequest) updates) => super.copyWith((message) => updates(message as RemovePeerRequest)) as RemovePeerRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemovePeerRequest create() => RemovePeerRequest._();
  RemovePeerRequest createEmptyInstance() => create();
  static $pb.PbList<RemovePeerRequest> createRepeated() => $pb.PbList<RemovePeerRequest>();
  @$core.pragma('dart2js:noInline')
  static RemovePeerRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemovePeerRequest>(create);
  static RemovePeerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get peerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set peerId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPeerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerId() => clearField(1);
}

class GetPendingConnectionsRequest extends $pb.GeneratedMessage {
  factory GetPendingConnectionsRequest() => create();
  GetPendingConnectionsRequest._() : super();
  factory GetPendingConnectionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetPendingConnectionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetPendingConnectionsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetPendingConnectionsRequest clone() => GetPendingConnectionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetPendingConnectionsRequest copyWith(void Function(GetPendingConnectionsRequest) updates) => super.copyWith((message) => updates(message as GetPendingConnectionsRequest)) as GetPendingConnectionsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPendingConnectionsRequest create() => GetPendingConnectionsRequest._();
  GetPendingConnectionsRequest createEmptyInstance() => create();
  static $pb.PbList<GetPendingConnectionsRequest> createRepeated() => $pb.PbList<GetPendingConnectionsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetPendingConnectionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetPendingConnectionsRequest>(create);
  static GetPendingConnectionsRequest? _defaultInstance;
}

class GetPendingConnectionsResponse extends $pb.GeneratedMessage {
  factory GetPendingConnectionsResponse() => create();
  GetPendingConnectionsResponse._() : super();
  factory GetPendingConnectionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetPendingConnectionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'GetPendingConnectionsResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status', subBuilder: $1.Status.create)
    ..pc<PendingConnection>(2, _omitFieldNames ? '' : 'pendingConnections', $pb.PbFieldType.PM, subBuilder: PendingConnection.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetPendingConnectionsResponse clone() => GetPendingConnectionsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetPendingConnectionsResponse copyWith(void Function(GetPendingConnectionsResponse) updates) => super.copyWith((message) => updates(message as GetPendingConnectionsResponse)) as GetPendingConnectionsResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPendingConnectionsResponse create() => GetPendingConnectionsResponse._();
  GetPendingConnectionsResponse createEmptyInstance() => create();
  static $pb.PbList<GetPendingConnectionsResponse> createRepeated() => $pb.PbList<GetPendingConnectionsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetPendingConnectionsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetPendingConnectionsResponse>(create);
  static GetPendingConnectionsResponse? _defaultInstance;

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
  $core.List<PendingConnection> get pendingConnections => $_getList(1);
}

class PendingConnection extends $pb.GeneratedMessage {
  factory PendingConnection() => create();
  PendingConnection._() : super();
  factory PendingConnection.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PendingConnection.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PendingConnection', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'deviceName')
    ..aInt64(3, _omitFieldNames ? '' : 'timestamp')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PendingConnection clone() => PendingConnection()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PendingConnection copyWith(void Function(PendingConnection) updates) => super.copyWith((message) => updates(message as PendingConnection)) as PendingConnection;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PendingConnection create() => PendingConnection._();
  PendingConnection createEmptyInstance() => create();
  static $pb.PbList<PendingConnection> createRepeated() => $pb.PbList<PendingConnection>();
  @$core.pragma('dart2js:noInline')
  static PendingConnection getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PendingConnection>(create);
  static PendingConnection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeviceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceName() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => clearField(3);
}

class AcceptConnectionRequest extends $pb.GeneratedMessage {
  factory AcceptConnectionRequest() => create();
  AcceptConnectionRequest._() : super();
  factory AcceptConnectionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AcceptConnectionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AcceptConnectionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AcceptConnectionRequest clone() => AcceptConnectionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AcceptConnectionRequest copyWith(void Function(AcceptConnectionRequest) updates) => super.copyWith((message) => updates(message as AcceptConnectionRequest)) as AcceptConnectionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcceptConnectionRequest create() => AcceptConnectionRequest._();
  AcceptConnectionRequest createEmptyInstance() => create();
  static $pb.PbList<AcceptConnectionRequest> createRepeated() => $pb.PbList<AcceptConnectionRequest>();
  @$core.pragma('dart2js:noInline')
  static AcceptConnectionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AcceptConnectionRequest>(create);
  static AcceptConnectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);
}

class RejectConnectionRequest extends $pb.GeneratedMessage {
  factory RejectConnectionRequest() => create();
  RejectConnectionRequest._() : super();
  factory RejectConnectionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RejectConnectionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RejectConnectionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RejectConnectionRequest clone() => RejectConnectionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RejectConnectionRequest copyWith(void Function(RejectConnectionRequest) updates) => super.copyWith((message) => updates(message as RejectConnectionRequest)) as RejectConnectionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectConnectionRequest create() => RejectConnectionRequest._();
  RejectConnectionRequest createEmptyInstance() => create();
  static $pb.PbList<RejectConnectionRequest> createRepeated() => $pb.PbList<RejectConnectionRequest>();
  @$core.pragma('dart2js:noInline')
  static RejectConnectionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RejectConnectionRequest>(create);
  static RejectConnectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => clearField(2);
}

class ConnectionRequest extends $pb.GeneratedMessage {
  factory ConnectionRequest() => create();
  ConnectionRequest._() : super();
  factory ConnectionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConnectionRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'deviceName')
    ..aInt64(3, _omitFieldNames ? '' : 'timestamp')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectionRequest clone() => ConnectionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectionRequest copyWith(void Function(ConnectionRequest) updates) => super.copyWith((message) => updates(message as ConnectionRequest)) as ConnectionRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectionRequest create() => ConnectionRequest._();
  ConnectionRequest createEmptyInstance() => create();
  static $pb.PbList<ConnectionRequest> createRepeated() => $pb.PbList<ConnectionRequest>();
  @$core.pragma('dart2js:noInline')
  static ConnectionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectionRequest>(create);
  static ConnectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceName($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasDeviceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceName() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => clearField(3);
}

class ConnectionResponse extends $pb.GeneratedMessage {
  factory ConnectionResponse() => create();
  ConnectionResponse._() : super();
  factory ConnectionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConnectionResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'accepted')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'deviceId')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectionResponse clone() => ConnectionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectionResponse copyWith(void Function(ConnectionResponse) updates) => super.copyWith((message) => updates(message as ConnectionResponse)) as ConnectionResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectionResponse create() => ConnectionResponse._();
  ConnectionResponse createEmptyInstance() => create();
  static $pb.PbList<ConnectionResponse> createRepeated() => $pb.PbList<ConnectionResponse>();
  @$core.pragma('dart2js:noInline')
  static ConnectionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConnectionResponse>(create);
  static ConnectionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get accepted => $_getBF(0);
  @$pb.TagNumber(1)
  set accepted($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAccepted() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccepted() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get deviceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set deviceId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDeviceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeviceId() => clearField(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
