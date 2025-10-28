//
//  Generated code. Do not modify.
//  source: api/proto/peer.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $1;
import 'peer.pb.dart' as $2;

export 'peer.pb.dart';

@$pb.GrpcServiceName('aether.api.PeerService')
class PeerServiceClient extends $grpc.Client {
  static final _$discoverPeers = $grpc.ClientMethod<$2.DiscoverPeersRequest, $2.DiscoverPeersResponse>(
      '/aether.api.PeerService/DiscoverPeers',
      ($2.DiscoverPeersRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.DiscoverPeersResponse.fromBuffer(value));
  static final _$connectToPeer = $grpc.ClientMethod<$2.ConnectToPeerRequest, $1.Status>(
      '/aether.api.PeerService/ConnectToPeer',
      ($2.ConnectToPeerRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Status.fromBuffer(value));
  static final _$disconnectFromPeer = $grpc.ClientMethod<$2.DisconnectFromPeerRequest, $1.Status>(
      '/aether.api.PeerService/DisconnectFromPeer',
      ($2.DisconnectFromPeerRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Status.fromBuffer(value));
  static final _$listPeers = $grpc.ClientMethod<$2.ListPeersRequest, $2.ListPeersResponse>(
      '/aether.api.PeerService/ListPeers',
      ($2.ListPeersRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.ListPeersResponse.fromBuffer(value));
  static final _$getPeerInfo = $grpc.ClientMethod<$2.GetPeerInfoRequest, $2.PeerInfoResponse>(
      '/aether.api.PeerService/GetPeerInfo',
      ($2.GetPeerInfoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.PeerInfoResponse.fromBuffer(value));
  static final _$trustPeer = $grpc.ClientMethod<$2.TrustPeerRequest, $1.Status>(
      '/aether.api.PeerService/TrustPeer',
      ($2.TrustPeerRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Status.fromBuffer(value));
  static final _$untrustPeer = $grpc.ClientMethod<$2.UntrustPeerRequest, $1.Status>(
      '/aether.api.PeerService/UntrustPeer',
      ($2.UntrustPeerRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Status.fromBuffer(value));
  static final _$removePeer = $grpc.ClientMethod<$2.RemovePeerRequest, $1.Status>(
      '/aether.api.PeerService/RemovePeer',
      ($2.RemovePeerRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Status.fromBuffer(value));
  static final _$getPendingConnections = $grpc.ClientMethod<$2.GetPendingConnectionsRequest, $2.GetPendingConnectionsResponse>(
      '/aether.api.PeerService/GetPendingConnections',
      ($2.GetPendingConnectionsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $2.GetPendingConnectionsResponse.fromBuffer(value));
  static final _$acceptConnection = $grpc.ClientMethod<$2.AcceptConnectionRequest, $1.Status>(
      '/aether.api.PeerService/AcceptConnection',
      ($2.AcceptConnectionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Status.fromBuffer(value));
  static final _$rejectConnection = $grpc.ClientMethod<$2.RejectConnectionRequest, $1.Status>(
      '/aether.api.PeerService/RejectConnection',
      ($2.RejectConnectionRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Status.fromBuffer(value));

  PeerServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$2.DiscoverPeersResponse> discoverPeers($2.DiscoverPeersRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$discoverPeers, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> connectToPeer($2.ConnectToPeerRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$connectToPeer, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> disconnectFromPeer($2.DisconnectFromPeerRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$disconnectFromPeer, request, options: options);
  }

  $grpc.ResponseFuture<$2.ListPeersResponse> listPeers($2.ListPeersRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listPeers, request, options: options);
  }

  $grpc.ResponseFuture<$2.PeerInfoResponse> getPeerInfo($2.GetPeerInfoRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getPeerInfo, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> trustPeer($2.TrustPeerRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$trustPeer, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> untrustPeer($2.UntrustPeerRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$untrustPeer, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> removePeer($2.RemovePeerRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$removePeer, request, options: options);
  }

  $grpc.ResponseFuture<$2.GetPendingConnectionsResponse> getPendingConnections($2.GetPendingConnectionsRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getPendingConnections, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> acceptConnection($2.AcceptConnectionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$acceptConnection, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> rejectConnection($2.RejectConnectionRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$rejectConnection, request, options: options);
  }
}

@$pb.GrpcServiceName('aether.api.PeerService')
abstract class PeerServiceBase extends $grpc.Service {
  $core.String get $name => 'aether.api.PeerService';

  PeerServiceBase() {
    $addMethod($grpc.ServiceMethod<$2.DiscoverPeersRequest, $2.DiscoverPeersResponse>(
        'DiscoverPeers',
        discoverPeers_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.DiscoverPeersRequest.fromBuffer(value),
        ($2.DiscoverPeersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.ConnectToPeerRequest, $1.Status>(
        'ConnectToPeer',
        connectToPeer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.ConnectToPeerRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.DisconnectFromPeerRequest, $1.Status>(
        'DisconnectFromPeer',
        disconnectFromPeer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.DisconnectFromPeerRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.ListPeersRequest, $2.ListPeersResponse>(
        'ListPeers',
        listPeers_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.ListPeersRequest.fromBuffer(value),
        ($2.ListPeersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.GetPeerInfoRequest, $2.PeerInfoResponse>(
        'GetPeerInfo',
        getPeerInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.GetPeerInfoRequest.fromBuffer(value),
        ($2.PeerInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.TrustPeerRequest, $1.Status>(
        'TrustPeer',
        trustPeer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.TrustPeerRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.UntrustPeerRequest, $1.Status>(
        'UntrustPeer',
        untrustPeer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.UntrustPeerRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.RemovePeerRequest, $1.Status>(
        'RemovePeer',
        removePeer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.RemovePeerRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.GetPendingConnectionsRequest, $2.GetPendingConnectionsResponse>(
        'GetPendingConnections',
        getPendingConnections_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.GetPendingConnectionsRequest.fromBuffer(value),
        ($2.GetPendingConnectionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.AcceptConnectionRequest, $1.Status>(
        'AcceptConnection',
        acceptConnection_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.AcceptConnectionRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.RejectConnectionRequest, $1.Status>(
        'RejectConnection',
        rejectConnection_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.RejectConnectionRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
  }

  $async.Future<$2.DiscoverPeersResponse> discoverPeers_Pre($grpc.ServiceCall call, $async.Future<$2.DiscoverPeersRequest> request) async {
    return discoverPeers(call, await request);
  }

  $async.Future<$1.Status> connectToPeer_Pre($grpc.ServiceCall call, $async.Future<$2.ConnectToPeerRequest> request) async {
    return connectToPeer(call, await request);
  }

  $async.Future<$1.Status> disconnectFromPeer_Pre($grpc.ServiceCall call, $async.Future<$2.DisconnectFromPeerRequest> request) async {
    return disconnectFromPeer(call, await request);
  }

  $async.Future<$2.ListPeersResponse> listPeers_Pre($grpc.ServiceCall call, $async.Future<$2.ListPeersRequest> request) async {
    return listPeers(call, await request);
  }

  $async.Future<$2.PeerInfoResponse> getPeerInfo_Pre($grpc.ServiceCall call, $async.Future<$2.GetPeerInfoRequest> request) async {
    return getPeerInfo(call, await request);
  }

  $async.Future<$1.Status> trustPeer_Pre($grpc.ServiceCall call, $async.Future<$2.TrustPeerRequest> request) async {
    return trustPeer(call, await request);
  }

  $async.Future<$1.Status> untrustPeer_Pre($grpc.ServiceCall call, $async.Future<$2.UntrustPeerRequest> request) async {
    return untrustPeer(call, await request);
  }

  $async.Future<$1.Status> removePeer_Pre($grpc.ServiceCall call, $async.Future<$2.RemovePeerRequest> request) async {
    return removePeer(call, await request);
  }

  $async.Future<$2.GetPendingConnectionsResponse> getPendingConnections_Pre($grpc.ServiceCall call, $async.Future<$2.GetPendingConnectionsRequest> request) async {
    return getPendingConnections(call, await request);
  }

  $async.Future<$1.Status> acceptConnection_Pre($grpc.ServiceCall call, $async.Future<$2.AcceptConnectionRequest> request) async {
    return acceptConnection(call, await request);
  }

  $async.Future<$1.Status> rejectConnection_Pre($grpc.ServiceCall call, $async.Future<$2.RejectConnectionRequest> request) async {
    return rejectConnection(call, await request);
  }

  $async.Future<$2.DiscoverPeersResponse> discoverPeers($grpc.ServiceCall call, $2.DiscoverPeersRequest request);
  $async.Future<$1.Status> connectToPeer($grpc.ServiceCall call, $2.ConnectToPeerRequest request);
  $async.Future<$1.Status> disconnectFromPeer($grpc.ServiceCall call, $2.DisconnectFromPeerRequest request);
  $async.Future<$2.ListPeersResponse> listPeers($grpc.ServiceCall call, $2.ListPeersRequest request);
  $async.Future<$2.PeerInfoResponse> getPeerInfo($grpc.ServiceCall call, $2.GetPeerInfoRequest request);
  $async.Future<$1.Status> trustPeer($grpc.ServiceCall call, $2.TrustPeerRequest request);
  $async.Future<$1.Status> untrustPeer($grpc.ServiceCall call, $2.UntrustPeerRequest request);
  $async.Future<$1.Status> removePeer($grpc.ServiceCall call, $2.RemovePeerRequest request);
  $async.Future<$2.GetPendingConnectionsResponse> getPendingConnections($grpc.ServiceCall call, $2.GetPendingConnectionsRequest request);
  $async.Future<$1.Status> acceptConnection($grpc.ServiceCall call, $2.AcceptConnectionRequest request);
  $async.Future<$1.Status> rejectConnection($grpc.ServiceCall call, $2.RejectConnectionRequest request);
}
