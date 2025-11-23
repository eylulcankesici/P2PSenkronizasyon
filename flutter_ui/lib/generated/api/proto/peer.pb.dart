// This is a generated file - do not edit.
//
// Generated from api/proto/peer.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $2;
import 'common.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Peer extends $pb.GeneratedMessage {
  factory Peer({
    $core.String? deviceId,
    $core.String? name,
    $core.Iterable<$core.String>? knownAddresses,
    $core.bool? isTrusted,
    $2.Timestamp? lastSeen,
    $1.PeerStatus? status,
    $core.String? publicKey,
    $2.Timestamp? createdAt,
    $2.Timestamp? updatedAt,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (name != null) result.name = name;
    if (knownAddresses != null) result.knownAddresses.addAll(knownAddresses);
    if (isTrusted != null) result.isTrusted = isTrusted;
    if (lastSeen != null) result.lastSeen = lastSeen;
    if (status != null) result.status = status;
    if (publicKey != null) result.publicKey = publicKey;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Peer._();

  factory Peer.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Peer.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Peer',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..pPS(3, _omitFieldNames ? '' : 'knownAddresses')
    ..aOB(4, _omitFieldNames ? '' : 'isTrusted')
    ..aOM<$2.Timestamp>(5, _omitFieldNames ? '' : 'lastSeen',
        subBuilder: $2.Timestamp.create)
    ..aE<$1.PeerStatus>(6, _omitFieldNames ? '' : 'status',
        enumValues: $1.PeerStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'publicKey')
    ..aOM<$2.Timestamp>(8, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(9, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Peer clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Peer copyWith(void Function(Peer) updates) =>
      super.copyWith((message) => updates(message as Peer)) as Peer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Peer create() => Peer._();
  @$core.override
  Peer createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Peer getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Peer>(create);
  static Peer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get knownAddresses => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get isTrusted => $_getBF(3);
  @$pb.TagNumber(4)
  set isTrusted($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsTrusted() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsTrusted() => $_clearField(4);

  @$pb.TagNumber(5)
  $2.Timestamp get lastSeen => $_getN(4);
  @$pb.TagNumber(5)
  set lastSeen($2.Timestamp value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasLastSeen() => $_has(4);
  @$pb.TagNumber(5)
  void clearLastSeen() => $_clearField(5);
  @$pb.TagNumber(5)
  $2.Timestamp ensureLastSeen() => $_ensure(4);

  @$pb.TagNumber(6)
  $1.PeerStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status($1.PeerStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get publicKey => $_getSZ(6);
  @$pb.TagNumber(7)
  set publicKey($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPublicKey() => $_has(6);
  @$pb.TagNumber(7)
  void clearPublicKey() => $_clearField(7);

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
  $2.Timestamp get updatedAt => $_getN(8);
  @$pb.TagNumber(9)
  set updatedAt($2.Timestamp value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasUpdatedAt() => $_has(8);
  @$pb.TagNumber(9)
  void clearUpdatedAt() => $_clearField(9);
  @$pb.TagNumber(9)
  $2.Timestamp ensureUpdatedAt() => $_ensure(8);
}

class DiscoverPeersRequest extends $pb.GeneratedMessage {
  factory DiscoverPeersRequest({
    $core.bool? lanOnly,
  }) {
    final result = create();
    if (lanOnly != null) result.lanOnly = lanOnly;
    return result;
  }

  DiscoverPeersRequest._();

  factory DiscoverPeersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DiscoverPeersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiscoverPeersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'lanOnly')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoverPeersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoverPeersRequest copyWith(void Function(DiscoverPeersRequest) updates) =>
      super.copyWith((message) => updates(message as DiscoverPeersRequest))
          as DiscoverPeersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscoverPeersRequest create() => DiscoverPeersRequest._();
  @$core.override
  DiscoverPeersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DiscoverPeersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscoverPeersRequest>(create);
  static DiscoverPeersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get lanOnly => $_getBF(0);
  @$pb.TagNumber(1)
  set lanOnly($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLanOnly() => $_has(0);
  @$pb.TagNumber(1)
  void clearLanOnly() => $_clearField(1);
}

class DiscoverPeersResponse extends $pb.GeneratedMessage {
  factory DiscoverPeersResponse({
    $1.Status? status,
    $core.Iterable<Peer>? peers,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (peers != null) result.peers.addAll(peers);
    return result;
  }

  DiscoverPeersResponse._();

  factory DiscoverPeersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DiscoverPeersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DiscoverPeersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..pPM<Peer>(2, _omitFieldNames ? '' : 'peers', subBuilder: Peer.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoverPeersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DiscoverPeersResponse copyWith(
          void Function(DiscoverPeersResponse) updates) =>
      super.copyWith((message) => updates(message as DiscoverPeersResponse))
          as DiscoverPeersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DiscoverPeersResponse create() => DiscoverPeersResponse._();
  @$core.override
  DiscoverPeersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DiscoverPeersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DiscoverPeersResponse>(create);
  static DiscoverPeersResponse? _defaultInstance;

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
  $pb.PbList<Peer> get peers => $_getList(1);
}

class ConnectToPeerRequest extends $pb.GeneratedMessage {
  factory ConnectToPeerRequest({
    $core.String? peerId,
  }) {
    final result = create();
    if (peerId != null) result.peerId = peerId;
    return result;
  }

  ConnectToPeerRequest._();

  factory ConnectToPeerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConnectToPeerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectToPeerRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'peerId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectToPeerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectToPeerRequest copyWith(void Function(ConnectToPeerRequest) updates) =>
      super.copyWith((message) => updates(message as ConnectToPeerRequest))
          as ConnectToPeerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectToPeerRequest create() => ConnectToPeerRequest._();
  @$core.override
  ConnectToPeerRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConnectToPeerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectToPeerRequest>(create);
  static ConnectToPeerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get peerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set peerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPeerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerId() => $_clearField(1);
}

class DisconnectFromPeerRequest extends $pb.GeneratedMessage {
  factory DisconnectFromPeerRequest({
    $core.String? peerId,
  }) {
    final result = create();
    if (peerId != null) result.peerId = peerId;
    return result;
  }

  DisconnectFromPeerRequest._();

  factory DisconnectFromPeerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DisconnectFromPeerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DisconnectFromPeerRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'peerId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisconnectFromPeerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DisconnectFromPeerRequest copyWith(
          void Function(DisconnectFromPeerRequest) updates) =>
      super.copyWith((message) => updates(message as DisconnectFromPeerRequest))
          as DisconnectFromPeerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DisconnectFromPeerRequest create() => DisconnectFromPeerRequest._();
  @$core.override
  DisconnectFromPeerRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DisconnectFromPeerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DisconnectFromPeerRequest>(create);
  static DisconnectFromPeerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get peerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set peerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPeerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerId() => $_clearField(1);
}

class ListPeersRequest extends $pb.GeneratedMessage {
  factory ListPeersRequest({
    $core.bool? onlineOnly,
    $core.bool? trustedOnly,
    $1.PaginationRequest? pagination,
  }) {
    final result = create();
    if (onlineOnly != null) result.onlineOnly = onlineOnly;
    if (trustedOnly != null) result.trustedOnly = trustedOnly;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListPeersRequest._();

  factory ListPeersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPeersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPeersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'onlineOnly')
    ..aOB(2, _omitFieldNames ? '' : 'trustedOnly')
    ..aOM<$1.PaginationRequest>(3, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPeersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPeersRequest copyWith(void Function(ListPeersRequest) updates) =>
      super.copyWith((message) => updates(message as ListPeersRequest))
          as ListPeersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPeersRequest create() => ListPeersRequest._();
  @$core.override
  ListPeersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPeersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPeersRequest>(create);
  static ListPeersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get onlineOnly => $_getBF(0);
  @$pb.TagNumber(1)
  set onlineOnly($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOnlineOnly() => $_has(0);
  @$pb.TagNumber(1)
  void clearOnlineOnly() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get trustedOnly => $_getBF(1);
  @$pb.TagNumber(2)
  set trustedOnly($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTrustedOnly() => $_has(1);
  @$pb.TagNumber(2)
  void clearTrustedOnly() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.PaginationRequest get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($1.PaginationRequest value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.PaginationRequest ensurePagination() => $_ensure(2);
}

class ListPeersResponse extends $pb.GeneratedMessage {
  factory ListPeersResponse({
    $core.Iterable<Peer>? peers,
    $1.PaginationResponse? pagination,
  }) {
    final result = create();
    if (peers != null) result.peers.addAll(peers);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListPeersResponse._();

  factory ListPeersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListPeersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListPeersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..pPM<Peer>(1, _omitFieldNames ? '' : 'peers', subBuilder: Peer.create)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPeersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListPeersResponse copyWith(void Function(ListPeersResponse) updates) =>
      super.copyWith((message) => updates(message as ListPeersResponse))
          as ListPeersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListPeersResponse create() => ListPeersResponse._();
  @$core.override
  ListPeersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListPeersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListPeersResponse>(create);
  static ListPeersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Peer> get peers => $_getList(0);

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

class GetPeerInfoRequest extends $pb.GeneratedMessage {
  factory GetPeerInfoRequest({
    $core.String? peerId,
  }) {
    final result = create();
    if (peerId != null) result.peerId = peerId;
    return result;
  }

  GetPeerInfoRequest._();

  factory GetPeerInfoRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPeerInfoRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPeerInfoRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'peerId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPeerInfoRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPeerInfoRequest copyWith(void Function(GetPeerInfoRequest) updates) =>
      super.copyWith((message) => updates(message as GetPeerInfoRequest))
          as GetPeerInfoRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPeerInfoRequest create() => GetPeerInfoRequest._();
  @$core.override
  GetPeerInfoRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPeerInfoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPeerInfoRequest>(create);
  static GetPeerInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get peerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set peerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPeerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerId() => $_clearField(1);
}

class PeerInfoResponse extends $pb.GeneratedMessage {
  factory PeerInfoResponse({
    $1.Status? status,
    Peer? peer,
    $core.Iterable<$core.String>? sharedFolders,
    $core.int? sharedFiles,
    $core.int? totalChunks,
    $2.Timestamp? lastActivity,
    $core.String? connectionType,
    $fixnum.Int64? latencyMs,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (peer != null) result.peer = peer;
    if (sharedFolders != null) result.sharedFolders.addAll(sharedFolders);
    if (sharedFiles != null) result.sharedFiles = sharedFiles;
    if (totalChunks != null) result.totalChunks = totalChunks;
    if (lastActivity != null) result.lastActivity = lastActivity;
    if (connectionType != null) result.connectionType = connectionType;
    if (latencyMs != null) result.latencyMs = latencyMs;
    return result;
  }

  PeerInfoResponse._();

  factory PeerInfoResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PeerInfoResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PeerInfoResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..aOM<Peer>(2, _omitFieldNames ? '' : 'peer', subBuilder: Peer.create)
    ..pPS(3, _omitFieldNames ? '' : 'sharedFolders')
    ..aI(4, _omitFieldNames ? '' : 'sharedFiles')
    ..aI(5, _omitFieldNames ? '' : 'totalChunks')
    ..aOM<$2.Timestamp>(6, _omitFieldNames ? '' : 'lastActivity',
        subBuilder: $2.Timestamp.create)
    ..aOS(7, _omitFieldNames ? '' : 'connectionType')
    ..aInt64(8, _omitFieldNames ? '' : 'latencyMs')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PeerInfoResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PeerInfoResponse copyWith(void Function(PeerInfoResponse) updates) =>
      super.copyWith((message) => updates(message as PeerInfoResponse))
          as PeerInfoResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PeerInfoResponse create() => PeerInfoResponse._();
  @$core.override
  PeerInfoResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PeerInfoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PeerInfoResponse>(create);
  static PeerInfoResponse? _defaultInstance;

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
  Peer get peer => $_getN(1);
  @$pb.TagNumber(2)
  set peer(Peer value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPeer() => $_has(1);
  @$pb.TagNumber(2)
  void clearPeer() => $_clearField(2);
  @$pb.TagNumber(2)
  Peer ensurePeer() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get sharedFolders => $_getList(2);

  @$pb.TagNumber(4)
  $core.int get sharedFiles => $_getIZ(3);
  @$pb.TagNumber(4)
  set sharedFiles($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSharedFiles() => $_has(3);
  @$pb.TagNumber(4)
  void clearSharedFiles() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get totalChunks => $_getIZ(4);
  @$pb.TagNumber(5)
  set totalChunks($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTotalChunks() => $_has(4);
  @$pb.TagNumber(5)
  void clearTotalChunks() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.Timestamp get lastActivity => $_getN(5);
  @$pb.TagNumber(6)
  set lastActivity($2.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLastActivity() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastActivity() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Timestamp ensureLastActivity() => $_ensure(5);

  @$pb.TagNumber(7)
  $core.String get connectionType => $_getSZ(6);
  @$pb.TagNumber(7)
  set connectionType($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasConnectionType() => $_has(6);
  @$pb.TagNumber(7)
  void clearConnectionType() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get latencyMs => $_getI64(7);
  @$pb.TagNumber(8)
  set latencyMs($fixnum.Int64 value) => $_setInt64(7, value);
  @$pb.TagNumber(8)
  $core.bool hasLatencyMs() => $_has(7);
  @$pb.TagNumber(8)
  void clearLatencyMs() => $_clearField(8);
}

class TrustPeerRequest extends $pb.GeneratedMessage {
  factory TrustPeerRequest({
    $core.String? peerId,
  }) {
    final result = create();
    if (peerId != null) result.peerId = peerId;
    return result;
  }

  TrustPeerRequest._();

  factory TrustPeerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TrustPeerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TrustPeerRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'peerId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrustPeerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TrustPeerRequest copyWith(void Function(TrustPeerRequest) updates) =>
      super.copyWith((message) => updates(message as TrustPeerRequest))
          as TrustPeerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrustPeerRequest create() => TrustPeerRequest._();
  @$core.override
  TrustPeerRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TrustPeerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TrustPeerRequest>(create);
  static TrustPeerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get peerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set peerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPeerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerId() => $_clearField(1);
}

class UntrustPeerRequest extends $pb.GeneratedMessage {
  factory UntrustPeerRequest({
    $core.String? peerId,
  }) {
    final result = create();
    if (peerId != null) result.peerId = peerId;
    return result;
  }

  UntrustPeerRequest._();

  factory UntrustPeerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UntrustPeerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UntrustPeerRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'peerId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UntrustPeerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UntrustPeerRequest copyWith(void Function(UntrustPeerRequest) updates) =>
      super.copyWith((message) => updates(message as UntrustPeerRequest))
          as UntrustPeerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UntrustPeerRequest create() => UntrustPeerRequest._();
  @$core.override
  UntrustPeerRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UntrustPeerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UntrustPeerRequest>(create);
  static UntrustPeerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get peerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set peerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPeerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerId() => $_clearField(1);
}

class RemovePeerRequest extends $pb.GeneratedMessage {
  factory RemovePeerRequest({
    $core.String? peerId,
  }) {
    final result = create();
    if (peerId != null) result.peerId = peerId;
    return result;
  }

  RemovePeerRequest._();

  factory RemovePeerRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RemovePeerRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RemovePeerRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'peerId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemovePeerRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RemovePeerRequest copyWith(void Function(RemovePeerRequest) updates) =>
      super.copyWith((message) => updates(message as RemovePeerRequest))
          as RemovePeerRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemovePeerRequest create() => RemovePeerRequest._();
  @$core.override
  RemovePeerRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RemovePeerRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RemovePeerRequest>(create);
  static RemovePeerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get peerId => $_getSZ(0);
  @$pb.TagNumber(1)
  set peerId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasPeerId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPeerId() => $_clearField(1);
}

/// Bağlantı istekleri için mesajlar
class GetPendingConnectionsRequest extends $pb.GeneratedMessage {
  factory GetPendingConnectionsRequest() => create();

  GetPendingConnectionsRequest._();

  factory GetPendingConnectionsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPendingConnectionsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPendingConnectionsRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPendingConnectionsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPendingConnectionsRequest copyWith(
          void Function(GetPendingConnectionsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as GetPendingConnectionsRequest))
          as GetPendingConnectionsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPendingConnectionsRequest create() =>
      GetPendingConnectionsRequest._();
  @$core.override
  GetPendingConnectionsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPendingConnectionsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPendingConnectionsRequest>(create);
  static GetPendingConnectionsRequest? _defaultInstance;
}

class GetPendingConnectionsResponse extends $pb.GeneratedMessage {
  factory GetPendingConnectionsResponse({
    $1.Status? status,
    $core.Iterable<PendingConnection>? pendingConnections,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (pendingConnections != null)
      result.pendingConnections.addAll(pendingConnections);
    return result;
  }

  GetPendingConnectionsResponse._();

  factory GetPendingConnectionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetPendingConnectionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetPendingConnectionsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..pPM<PendingConnection>(2, _omitFieldNames ? '' : 'pendingConnections',
        subBuilder: PendingConnection.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPendingConnectionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetPendingConnectionsResponse copyWith(
          void Function(GetPendingConnectionsResponse) updates) =>
      super.copyWith(
              (message) => updates(message as GetPendingConnectionsResponse))
          as GetPendingConnectionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetPendingConnectionsResponse create() =>
      GetPendingConnectionsResponse._();
  @$core.override
  GetPendingConnectionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetPendingConnectionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetPendingConnectionsResponse>(create);
  static GetPendingConnectionsResponse? _defaultInstance;

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
  $pb.PbList<PendingConnection> get pendingConnections => $_getList(1);
}

class PendingConnection extends $pb.GeneratedMessage {
  factory PendingConnection({
    $core.String? deviceId,
    $core.String? deviceName,
    $fixnum.Int64? timestamp,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (deviceName != null) result.deviceName = deviceName;
    if (timestamp != null) result.timestamp = timestamp;
    return result;
  }

  PendingConnection._();

  factory PendingConnection.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory PendingConnection.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PendingConnection',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'deviceName')
    ..aInt64(3, _omitFieldNames ? '' : 'timestamp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PendingConnection clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PendingConnection copyWith(void Function(PendingConnection) updates) =>
      super.copyWith((message) => updates(message as PendingConnection))
          as PendingConnection;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PendingConnection create() => PendingConnection._();
  @$core.override
  PendingConnection createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static PendingConnection getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PendingConnection>(create);
  static PendingConnection? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceName() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => $_clearField(3);
}

class AcceptConnectionRequest extends $pb.GeneratedMessage {
  factory AcceptConnectionRequest({
    $core.String? deviceId,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    return result;
  }

  AcceptConnectionRequest._();

  factory AcceptConnectionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AcceptConnectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AcceptConnectionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptConnectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AcceptConnectionRequest copyWith(
          void Function(AcceptConnectionRequest) updates) =>
      super.copyWith((message) => updates(message as AcceptConnectionRequest))
          as AcceptConnectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AcceptConnectionRequest create() => AcceptConnectionRequest._();
  @$core.override
  AcceptConnectionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AcceptConnectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AcceptConnectionRequest>(create);
  static AcceptConnectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);
}

class RejectConnectionRequest extends $pb.GeneratedMessage {
  factory RejectConnectionRequest({
    $core.String? deviceId,
    $core.String? reason,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (reason != null) result.reason = reason;
    return result;
  }

  RejectConnectionRequest._();

  factory RejectConnectionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RejectConnectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RejectConnectionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'reason')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectConnectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RejectConnectionRequest copyWith(
          void Function(RejectConnectionRequest) updates) =>
      super.copyWith((message) => updates(message as RejectConnectionRequest))
          as RejectConnectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RejectConnectionRequest create() => RejectConnectionRequest._();
  @$core.override
  RejectConnectionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RejectConnectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RejectConnectionRequest>(create);
  static RejectConnectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get reason => $_getSZ(1);
  @$pb.TagNumber(2)
  set reason($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasReason() => $_has(1);
  @$pb.TagNumber(2)
  void clearReason() => $_clearField(2);
}

/// P2P bağlantı istek mesajları (binary protokol için)
class ConnectionRequest extends $pb.GeneratedMessage {
  factory ConnectionRequest({
    $core.String? deviceId,
    $core.String? deviceName,
    $fixnum.Int64? timestamp,
  }) {
    final result = create();
    if (deviceId != null) result.deviceId = deviceId;
    if (deviceName != null) result.deviceName = deviceName;
    if (timestamp != null) result.timestamp = timestamp;
    return result;
  }

  ConnectionRequest._();

  factory ConnectionRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConnectionRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectionRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'deviceId')
    ..aOS(2, _omitFieldNames ? '' : 'deviceName')
    ..aInt64(3, _omitFieldNames ? '' : 'timestamp')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectionRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectionRequest copyWith(void Function(ConnectionRequest) updates) =>
      super.copyWith((message) => updates(message as ConnectionRequest))
          as ConnectionRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectionRequest create() => ConnectionRequest._();
  @$core.override
  ConnectionRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConnectionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectionRequest>(create);
  static ConnectionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get deviceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set deviceId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get deviceName => $_getSZ(1);
  @$pb.TagNumber(2)
  set deviceName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeviceName() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeviceName() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get timestamp => $_getI64(2);
  @$pb.TagNumber(3)
  set timestamp($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTimestamp() => $_has(2);
  @$pb.TagNumber(3)
  void clearTimestamp() => $_clearField(3);
}

class ConnectionResponse extends $pb.GeneratedMessage {
  factory ConnectionResponse({
    $core.bool? accepted,
    $core.String? message,
    $core.String? deviceId,
  }) {
    final result = create();
    if (accepted != null) result.accepted = accepted;
    if (message != null) result.message = message;
    if (deviceId != null) result.deviceId = deviceId;
    return result;
  }

  ConnectionResponse._();

  factory ConnectionResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ConnectionResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ConnectionResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'accepted')
    ..aOS(2, _omitFieldNames ? '' : 'message')
    ..aOS(3, _omitFieldNames ? '' : 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectionResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConnectionResponse copyWith(void Function(ConnectionResponse) updates) =>
      super.copyWith((message) => updates(message as ConnectionResponse))
          as ConnectionResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConnectionResponse create() => ConnectionResponse._();
  @$core.override
  ConnectionResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ConnectionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ConnectionResponse>(create);
  static ConnectionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get accepted => $_getBF(0);
  @$pb.TagNumber(1)
  set accepted($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAccepted() => $_has(0);
  @$pb.TagNumber(1)
  void clearAccepted() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get message => $_getSZ(1);
  @$pb.TagNumber(2)
  set message($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get deviceId => $_getSZ(2);
  @$pb.TagNumber(3)
  set deviceId($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDeviceId() => $_has(2);
  @$pb.TagNumber(3)
  void clearDeviceId() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
