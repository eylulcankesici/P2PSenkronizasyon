///
//  Generated code. Do not modify.
//  source: api/proto/peer.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $7;
import 'common.pb.dart' as $1;

import 'common.pbenum.dart' as $1;

class Peer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Peer', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'deviceId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name')
    ..pPS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'knownAddresses')
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isTrusted')
    ..aOM<$7.Timestamp>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastSeen', subBuilder: $7.Timestamp.create)
    ..e<$1.PeerStatus>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: $1.PeerStatus.PEER_STATUS_UNKNOWN, valueOf: $1.PeerStatus.valueOf, enumValues: $1.PeerStatus.values)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'publicKey')
    ..aOM<$7.Timestamp>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt', subBuilder: $7.Timestamp.create)
    ..aOM<$7.Timestamp>(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedAt', subBuilder: $7.Timestamp.create)
    ..hasRequiredFields = false
  ;

  Peer._() : super();
  factory Peer({
    $core.String? deviceId,
    $core.String? name,
    $core.Iterable<$core.String>? knownAddresses,
    $core.bool? isTrusted,
    $7.Timestamp? lastSeen,
    $1.PeerStatus? status,
    $core.String? publicKey,
    $7.Timestamp? createdAt,
    $7.Timestamp? updatedAt,
  }) {
    final _result = create();
    if (deviceId != null) {
      _result.deviceId = deviceId;
    }
    if (name != null) {
      _result.name = name;
    }
    if (knownAddresses != null) {
      _result.knownAddresses.addAll(knownAddresses);
    }
    if (isTrusted != null) {
      _result.isTrusted = isTrusted;
    }
    if (lastSeen != null) {
      _result.lastSeen = lastSeen;
    }
    if (status != null) {
      _result.status = status;
    }
    if (publicKey != null) {
      _result.publicKey = publicKey;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      _result.updatedAt = updatedAt;
    }
    return _result;
  }
  factory Peer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Peer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Peer clone() => Peer()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Peer copyWith(void Function(Peer) updates) => super.copyWith((message) => updates(message as Peer)) as Peer; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DiscoverPeersRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lanOnly')
    ..hasRequiredFields = false
  ;

  DiscoverPeersRequest._() : super();
  factory DiscoverPeersRequest({
    $core.bool? lanOnly,
  }) {
    final _result = create();
    if (lanOnly != null) {
      _result.lanOnly = lanOnly;
    }
    return _result;
  }
  factory DiscoverPeersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DiscoverPeersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DiscoverPeersRequest clone() => DiscoverPeersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DiscoverPeersRequest copyWith(void Function(DiscoverPeersRequest) updates) => super.copyWith((message) => updates(message as DiscoverPeersRequest)) as DiscoverPeersRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DiscoverPeersResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', subBuilder: $1.Status.create)
    ..pc<Peer>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peers', $pb.PbFieldType.PM, subBuilder: Peer.create)
    ..hasRequiredFields = false
  ;

  DiscoverPeersResponse._() : super();
  factory DiscoverPeersResponse({
    $1.Status? status,
    $core.Iterable<Peer>? peers,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    if (peers != null) {
      _result.peers.addAll(peers);
    }
    return _result;
  }
  factory DiscoverPeersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DiscoverPeersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DiscoverPeersResponse clone() => DiscoverPeersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DiscoverPeersResponse copyWith(void Function(DiscoverPeersResponse) updates) => super.copyWith((message) => updates(message as DiscoverPeersResponse)) as DiscoverPeersResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ConnectToPeerRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peerId')
    ..hasRequiredFields = false
  ;

  ConnectToPeerRequest._() : super();
  factory ConnectToPeerRequest({
    $core.String? peerId,
  }) {
    final _result = create();
    if (peerId != null) {
      _result.peerId = peerId;
    }
    return _result;
  }
  factory ConnectToPeerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ConnectToPeerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ConnectToPeerRequest clone() => ConnectToPeerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ConnectToPeerRequest copyWith(void Function(ConnectToPeerRequest) updates) => super.copyWith((message) => updates(message as ConnectToPeerRequest)) as ConnectToPeerRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DisconnectFromPeerRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peerId')
    ..hasRequiredFields = false
  ;

  DisconnectFromPeerRequest._() : super();
  factory DisconnectFromPeerRequest({
    $core.String? peerId,
  }) {
    final _result = create();
    if (peerId != null) {
      _result.peerId = peerId;
    }
    return _result;
  }
  factory DisconnectFromPeerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DisconnectFromPeerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DisconnectFromPeerRequest clone() => DisconnectFromPeerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DisconnectFromPeerRequest copyWith(void Function(DisconnectFromPeerRequest) updates) => super.copyWith((message) => updates(message as DisconnectFromPeerRequest)) as DisconnectFromPeerRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListPeersRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'onlineOnly')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'trustedOnly')
    ..aOM<$1.PaginationRequest>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $1.PaginationRequest.create)
    ..hasRequiredFields = false
  ;

  ListPeersRequest._() : super();
  factory ListPeersRequest({
    $core.bool? onlineOnly,
    $core.bool? trustedOnly,
    $1.PaginationRequest? pagination,
  }) {
    final _result = create();
    if (onlineOnly != null) {
      _result.onlineOnly = onlineOnly;
    }
    if (trustedOnly != null) {
      _result.trustedOnly = trustedOnly;
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory ListPeersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListPeersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListPeersRequest clone() => ListPeersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListPeersRequest copyWith(void Function(ListPeersRequest) updates) => super.copyWith((message) => updates(message as ListPeersRequest)) as ListPeersRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListPeersResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..pc<Peer>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peers', $pb.PbFieldType.PM, subBuilder: Peer.create)
    ..aOM<$1.PaginationResponse>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $1.PaginationResponse.create)
    ..hasRequiredFields = false
  ;

  ListPeersResponse._() : super();
  factory ListPeersResponse({
    $core.Iterable<Peer>? peers,
    $1.PaginationResponse? pagination,
  }) {
    final _result = create();
    if (peers != null) {
      _result.peers.addAll(peers);
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory ListPeersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListPeersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListPeersResponse clone() => ListPeersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListPeersResponse copyWith(void Function(ListPeersResponse) updates) => super.copyWith((message) => updates(message as ListPeersResponse)) as ListPeersResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetPeerInfoRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peerId')
    ..hasRequiredFields = false
  ;

  GetPeerInfoRequest._() : super();
  factory GetPeerInfoRequest({
    $core.String? peerId,
  }) {
    final _result = create();
    if (peerId != null) {
      _result.peerId = peerId;
    }
    return _result;
  }
  factory GetPeerInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetPeerInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetPeerInfoRequest clone() => GetPeerInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetPeerInfoRequest copyWith(void Function(GetPeerInfoRequest) updates) => super.copyWith((message) => updates(message as GetPeerInfoRequest)) as GetPeerInfoRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PeerInfoResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', subBuilder: $1.Status.create)
    ..aOM<Peer>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peer', subBuilder: Peer.create)
    ..pPS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sharedFolders')
    ..a<$core.int>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sharedFiles', $pb.PbFieldType.O3)
    ..a<$core.int>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'totalChunks', $pb.PbFieldType.O3)
    ..aOM<$7.Timestamp>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastActivity', subBuilder: $7.Timestamp.create)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'connectionType')
    ..aInt64(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'latencyMs')
    ..hasRequiredFields = false
  ;

  PeerInfoResponse._() : super();
  factory PeerInfoResponse({
    $1.Status? status,
    Peer? peer,
    $core.Iterable<$core.String>? sharedFolders,
    $core.int? sharedFiles,
    $core.int? totalChunks,
    $7.Timestamp? lastActivity,
    $core.String? connectionType,
    $fixnum.Int64? latencyMs,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    if (peer != null) {
      _result.peer = peer;
    }
    if (sharedFolders != null) {
      _result.sharedFolders.addAll(sharedFolders);
    }
    if (sharedFiles != null) {
      _result.sharedFiles = sharedFiles;
    }
    if (totalChunks != null) {
      _result.totalChunks = totalChunks;
    }
    if (lastActivity != null) {
      _result.lastActivity = lastActivity;
    }
    if (connectionType != null) {
      _result.connectionType = connectionType;
    }
    if (latencyMs != null) {
      _result.latencyMs = latencyMs;
    }
    return _result;
  }
  factory PeerInfoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PeerInfoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PeerInfoResponse clone() => PeerInfoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PeerInfoResponse copyWith(void Function(PeerInfoResponse) updates) => super.copyWith((message) => updates(message as PeerInfoResponse)) as PeerInfoResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TrustPeerRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peerId')
    ..hasRequiredFields = false
  ;

  TrustPeerRequest._() : super();
  factory TrustPeerRequest({
    $core.String? peerId,
  }) {
    final _result = create();
    if (peerId != null) {
      _result.peerId = peerId;
    }
    return _result;
  }
  factory TrustPeerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrustPeerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrustPeerRequest clone() => TrustPeerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrustPeerRequest copyWith(void Function(TrustPeerRequest) updates) => super.copyWith((message) => updates(message as TrustPeerRequest)) as TrustPeerRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UntrustPeerRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peerId')
    ..hasRequiredFields = false
  ;

  UntrustPeerRequest._() : super();
  factory UntrustPeerRequest({
    $core.String? peerId,
  }) {
    final _result = create();
    if (peerId != null) {
      _result.peerId = peerId;
    }
    return _result;
  }
  factory UntrustPeerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UntrustPeerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UntrustPeerRequest clone() => UntrustPeerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UntrustPeerRequest copyWith(void Function(UntrustPeerRequest) updates) => super.copyWith((message) => updates(message as UntrustPeerRequest)) as UntrustPeerRequest; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RemovePeerRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'peerId')
    ..hasRequiredFields = false
  ;

  RemovePeerRequest._() : super();
  factory RemovePeerRequest({
    $core.String? peerId,
  }) {
    final _result = create();
    if (peerId != null) {
      _result.peerId = peerId;
    }
    return _result;
  }
  factory RemovePeerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemovePeerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemovePeerRequest clone() => RemovePeerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemovePeerRequest copyWith(void Function(RemovePeerRequest) updates) => super.copyWith((message) => updates(message as RemovePeerRequest)) as RemovePeerRequest; // ignore: deprecated_member_use
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

