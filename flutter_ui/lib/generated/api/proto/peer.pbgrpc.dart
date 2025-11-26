// This is a generated file - do not edit.
//
// Generated from api/proto/peer.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $1;
import 'peer.pb.dart' as $0;

export 'peer.pb.dart';

/// Peer servisi
@$pb.GrpcServiceName('aether.api.PeerService')
class PeerServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  PeerServiceClient(super.channel, {super.options, super.interceptors});

  /// Peer'ları keşfet
  $grpc.ResponseFuture<$0.DiscoverPeersResponse> discoverPeers(
    $0.DiscoverPeersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$discoverPeers, request, options: options);
  }

  /// Peer'a bağlan
  $grpc.ResponseFuture<$1.Status> connectToPeer(
    $0.ConnectToPeerRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$connectToPeer, request, options: options);
  }

  /// Peer bağlantısını kes
  $grpc.ResponseFuture<$1.Status> disconnectFromPeer(
    $0.DisconnectFromPeerRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$disconnectFromPeer, request, options: options);
  }

  /// Tüm peer'ları listele
  $grpc.ResponseFuture<$0.ListPeersResponse> listPeers(
    $0.ListPeersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listPeers, request, options: options);
  }

  /// Peer detay bilgisi getir
  $grpc.ResponseFuture<$0.PeerInfoResponse> getPeerInfo(
    $0.GetPeerInfoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPeerInfo, request, options: options);
  }

  /// Peer'i güvenilir yap
  $grpc.ResponseFuture<$1.Status> trustPeer(
    $0.TrustPeerRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$trustPeer, request, options: options);
  }

  /// Peer'i güvenilmez yap
  $grpc.ResponseFuture<$1.Status> untrustPeer(
    $0.UntrustPeerRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$untrustPeer, request, options: options);
  }

  /// Peer'ı kaldır
  $grpc.ResponseFuture<$1.Status> removePeer(
    $0.RemovePeerRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$removePeer, request, options: options);
  }

  /// Bekleyen bağlantı isteklerini al
  $grpc.ResponseFuture<$0.GetPendingConnectionsResponse> getPendingConnections(
    $0.GetPendingConnectionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getPendingConnections, request, options: options);
  }

  /// Bağlantı isteğini onayla
  $grpc.ResponseFuture<$1.Status> acceptConnection(
    $0.AcceptConnectionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$acceptConnection, request, options: options);
  }

  /// Bağlantı isteğini reddet
  $grpc.ResponseFuture<$1.Status> rejectConnection(
    $0.RejectConnectionRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$rejectConnection, request, options: options);
  }

  // method descriptors

  static final _$discoverPeers =
      $grpc.ClientMethod<$0.DiscoverPeersRequest, $0.DiscoverPeersResponse>(
          '/aether.api.PeerService/DiscoverPeers',
          ($0.DiscoverPeersRequest value) => value.writeToBuffer(),
          $0.DiscoverPeersResponse.fromBuffer);
  static final _$connectToPeer =
      $grpc.ClientMethod<$0.ConnectToPeerRequest, $1.Status>(
          '/aether.api.PeerService/ConnectToPeer',
          ($0.ConnectToPeerRequest value) => value.writeToBuffer(),
          $1.Status.fromBuffer);
  static final _$disconnectFromPeer =
      $grpc.ClientMethod<$0.DisconnectFromPeerRequest, $1.Status>(
          '/aether.api.PeerService/DisconnectFromPeer',
          ($0.DisconnectFromPeerRequest value) => value.writeToBuffer(),
          $1.Status.fromBuffer);
  static final _$listPeers =
      $grpc.ClientMethod<$0.ListPeersRequest, $0.ListPeersResponse>(
          '/aether.api.PeerService/ListPeers',
          ($0.ListPeersRequest value) => value.writeToBuffer(),
          $0.ListPeersResponse.fromBuffer);
  static final _$getPeerInfo =
      $grpc.ClientMethod<$0.GetPeerInfoRequest, $0.PeerInfoResponse>(
          '/aether.api.PeerService/GetPeerInfo',
          ($0.GetPeerInfoRequest value) => value.writeToBuffer(),
          $0.PeerInfoResponse.fromBuffer);
  static final _$trustPeer = $grpc.ClientMethod<$0.TrustPeerRequest, $1.Status>(
      '/aether.api.PeerService/TrustPeer',
      ($0.TrustPeerRequest value) => value.writeToBuffer(),
      $1.Status.fromBuffer);
  static final _$untrustPeer =
      $grpc.ClientMethod<$0.UntrustPeerRequest, $1.Status>(
          '/aether.api.PeerService/UntrustPeer',
          ($0.UntrustPeerRequest value) => value.writeToBuffer(),
          $1.Status.fromBuffer);
  static final _$removePeer =
      $grpc.ClientMethod<$0.RemovePeerRequest, $1.Status>(
          '/aether.api.PeerService/RemovePeer',
          ($0.RemovePeerRequest value) => value.writeToBuffer(),
          $1.Status.fromBuffer);
  static final _$getPendingConnections = $grpc.ClientMethod<
          $0.GetPendingConnectionsRequest, $0.GetPendingConnectionsResponse>(
      '/aether.api.PeerService/GetPendingConnections',
      ($0.GetPendingConnectionsRequest value) => value.writeToBuffer(),
      $0.GetPendingConnectionsResponse.fromBuffer);
  static final _$acceptConnection =
      $grpc.ClientMethod<$0.AcceptConnectionRequest, $1.Status>(
          '/aether.api.PeerService/AcceptConnection',
          ($0.AcceptConnectionRequest value) => value.writeToBuffer(),
          $1.Status.fromBuffer);
  static final _$rejectConnection =
      $grpc.ClientMethod<$0.RejectConnectionRequest, $1.Status>(
          '/aether.api.PeerService/RejectConnection',
          ($0.RejectConnectionRequest value) => value.writeToBuffer(),
          $1.Status.fromBuffer);
}

@$pb.GrpcServiceName('aether.api.PeerService')
abstract class PeerServiceBase extends $grpc.Service {
  $core.String get $name => 'aether.api.PeerService';

  PeerServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.DiscoverPeersRequest, $0.DiscoverPeersResponse>(
            'DiscoverPeers',
            discoverPeers_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.DiscoverPeersRequest.fromBuffer(value),
            ($0.DiscoverPeersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ConnectToPeerRequest, $1.Status>(
        'ConnectToPeer',
        connectToPeer_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.ConnectToPeerRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DisconnectFromPeerRequest, $1.Status>(
        'DisconnectFromPeer',
        disconnectFromPeer_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DisconnectFromPeerRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListPeersRequest, $0.ListPeersResponse>(
        'ListPeers',
        listPeers_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListPeersRequest.fromBuffer(value),
        ($0.ListPeersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPeerInfoRequest, $0.PeerInfoResponse>(
        'GetPeerInfo',
        getPeerInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetPeerInfoRequest.fromBuffer(value),
        ($0.PeerInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.TrustPeerRequest, $1.Status>(
        'TrustPeer',
        trustPeer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.TrustPeerRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UntrustPeerRequest, $1.Status>(
        'UntrustPeer',
        untrustPeer_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UntrustPeerRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RemovePeerRequest, $1.Status>(
        'RemovePeer',
        removePeer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RemovePeerRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetPendingConnectionsRequest,
            $0.GetPendingConnectionsResponse>(
        'GetPendingConnections',
        getPendingConnections_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetPendingConnectionsRequest.fromBuffer(value),
        ($0.GetPendingConnectionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AcceptConnectionRequest, $1.Status>(
        'AcceptConnection',
        acceptConnection_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.AcceptConnectionRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RejectConnectionRequest, $1.Status>(
        'RejectConnection',
        rejectConnection_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RejectConnectionRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
  }

  $async.Future<$0.DiscoverPeersResponse> discoverPeers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.DiscoverPeersRequest> $request) async {
    return discoverPeers($call, await $request);
  }

  $async.Future<$0.DiscoverPeersResponse> discoverPeers(
      $grpc.ServiceCall call, $0.DiscoverPeersRequest request);

  $async.Future<$1.Status> connectToPeer_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ConnectToPeerRequest> $request) async {
    return connectToPeer($call, await $request);
  }

  $async.Future<$1.Status> connectToPeer(
      $grpc.ServiceCall call, $0.ConnectToPeerRequest request);

  $async.Future<$1.Status> disconnectFromPeer_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DisconnectFromPeerRequest> $request) async {
    return disconnectFromPeer($call, await $request);
  }

  $async.Future<$1.Status> disconnectFromPeer(
      $grpc.ServiceCall call, $0.DisconnectFromPeerRequest request);

  $async.Future<$0.ListPeersResponse> listPeers_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListPeersRequest> $request) async {
    return listPeers($call, await $request);
  }

  $async.Future<$0.ListPeersResponse> listPeers(
      $grpc.ServiceCall call, $0.ListPeersRequest request);

  $async.Future<$0.PeerInfoResponse> getPeerInfo_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetPeerInfoRequest> $request) async {
    return getPeerInfo($call, await $request);
  }

  $async.Future<$0.PeerInfoResponse> getPeerInfo(
      $grpc.ServiceCall call, $0.GetPeerInfoRequest request);

  $async.Future<$1.Status> trustPeer_Pre($grpc.ServiceCall $call,
      $async.Future<$0.TrustPeerRequest> $request) async {
    return trustPeer($call, await $request);
  }

  $async.Future<$1.Status> trustPeer(
      $grpc.ServiceCall call, $0.TrustPeerRequest request);

  $async.Future<$1.Status> untrustPeer_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UntrustPeerRequest> $request) async {
    return untrustPeer($call, await $request);
  }

  $async.Future<$1.Status> untrustPeer(
      $grpc.ServiceCall call, $0.UntrustPeerRequest request);

  $async.Future<$1.Status> removePeer_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RemovePeerRequest> $request) async {
    return removePeer($call, await $request);
  }

  $async.Future<$1.Status> removePeer(
      $grpc.ServiceCall call, $0.RemovePeerRequest request);

  $async.Future<$0.GetPendingConnectionsResponse> getPendingConnections_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetPendingConnectionsRequest> $request) async {
    return getPendingConnections($call, await $request);
  }

  $async.Future<$0.GetPendingConnectionsResponse> getPendingConnections(
      $grpc.ServiceCall call, $0.GetPendingConnectionsRequest request);

  $async.Future<$1.Status> acceptConnection_Pre($grpc.ServiceCall $call,
      $async.Future<$0.AcceptConnectionRequest> $request) async {
    return acceptConnection($call, await $request);
  }

  $async.Future<$1.Status> acceptConnection(
      $grpc.ServiceCall call, $0.AcceptConnectionRequest request);

  $async.Future<$1.Status> rejectConnection_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RejectConnectionRequest> $request) async {
    return rejectConnection($call, await $request);
  }

  $async.Future<$1.Status> rejectConnection(
      $grpc.ServiceCall call, $0.RejectConnectionRequest request);
}
