///
//  Generated code. Do not modify.
//  source: api/proto/peer.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'peer.pb.dart' as $5;
import 'common.pb.dart' as $1;
export 'peer.pb.dart';

class PeerServiceClient extends $grpc.Client {
  static final _$discoverPeers =
      $grpc.ClientMethod<$5.DiscoverPeersRequest, $5.DiscoverPeersResponse>(
          '/aether.api.PeerService/DiscoverPeers',
          ($5.DiscoverPeersRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $5.DiscoverPeersResponse.fromBuffer(value));
  static final _$connectToPeer =
      $grpc.ClientMethod<$5.ConnectToPeerRequest, $1.Status>(
          '/aether.api.PeerService/ConnectToPeer',
          ($5.ConnectToPeerRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Status.fromBuffer(value));
  static final _$disconnectFromPeer =
      $grpc.ClientMethod<$5.DisconnectFromPeerRequest, $1.Status>(
          '/aether.api.PeerService/DisconnectFromPeer',
          ($5.DisconnectFromPeerRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Status.fromBuffer(value));
  static final _$listPeers =
      $grpc.ClientMethod<$5.ListPeersRequest, $5.ListPeersResponse>(
          '/aether.api.PeerService/ListPeers',
          ($5.ListPeersRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $5.ListPeersResponse.fromBuffer(value));
  static final _$getPeerInfo =
      $grpc.ClientMethod<$5.GetPeerInfoRequest, $5.PeerInfoResponse>(
          '/aether.api.PeerService/GetPeerInfo',
          ($5.GetPeerInfoRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $5.PeerInfoResponse.fromBuffer(value));
  static final _$trustPeer = $grpc.ClientMethod<$5.TrustPeerRequest, $1.Status>(
      '/aether.api.PeerService/TrustPeer',
      ($5.TrustPeerRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Status.fromBuffer(value));
  static final _$untrustPeer =
      $grpc.ClientMethod<$5.UntrustPeerRequest, $1.Status>(
          '/aether.api.PeerService/UntrustPeer',
          ($5.UntrustPeerRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Status.fromBuffer(value));
  static final _$removePeer =
      $grpc.ClientMethod<$5.RemovePeerRequest, $1.Status>(
          '/aether.api.PeerService/RemovePeer',
          ($5.RemovePeerRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Status.fromBuffer(value));

  PeerServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$5.DiscoverPeersResponse> discoverPeers(
      $5.DiscoverPeersRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$discoverPeers, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> connectToPeer($5.ConnectToPeerRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$connectToPeer, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> disconnectFromPeer(
      $5.DisconnectFromPeerRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$disconnectFromPeer, request, options: options);
  }

  $grpc.ResponseFuture<$5.ListPeersResponse> listPeers(
      $5.ListPeersRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listPeers, request, options: options);
  }

  $grpc.ResponseFuture<$5.PeerInfoResponse> getPeerInfo(
      $5.GetPeerInfoRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getPeerInfo, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> trustPeer($5.TrustPeerRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$trustPeer, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> untrustPeer($5.UntrustPeerRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$untrustPeer, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> removePeer($5.RemovePeerRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$removePeer, request, options: options);
  }
}

abstract class PeerServiceBase extends $grpc.Service {
  $core.String get $name => 'aether.api.PeerService';

  PeerServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$5.DiscoverPeersRequest, $5.DiscoverPeersResponse>(
            'DiscoverPeers',
            discoverPeers_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $5.DiscoverPeersRequest.fromBuffer(value),
            ($5.DiscoverPeersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.ConnectToPeerRequest, $1.Status>(
        'ConnectToPeer',
        connectToPeer_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $5.ConnectToPeerRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.DisconnectFromPeerRequest, $1.Status>(
        'DisconnectFromPeer',
        disconnectFromPeer_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $5.DisconnectFromPeerRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.ListPeersRequest, $5.ListPeersResponse>(
        'ListPeers',
        listPeers_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.ListPeersRequest.fromBuffer(value),
        ($5.ListPeersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.GetPeerInfoRequest, $5.PeerInfoResponse>(
        'GetPeerInfo',
        getPeerInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $5.GetPeerInfoRequest.fromBuffer(value),
        ($5.PeerInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.TrustPeerRequest, $1.Status>(
        'TrustPeer',
        trustPeer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.TrustPeerRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.UntrustPeerRequest, $1.Status>(
        'UntrustPeer',
        untrustPeer_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $5.UntrustPeerRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.RemovePeerRequest, $1.Status>(
        'RemovePeer',
        removePeer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.RemovePeerRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
  }

  $async.Future<$5.DiscoverPeersResponse> discoverPeers_Pre(
      $grpc.ServiceCall call,
      $async.Future<$5.DiscoverPeersRequest> request) async {
    return discoverPeers(call, await request);
  }

  $async.Future<$1.Status> connectToPeer_Pre($grpc.ServiceCall call,
      $async.Future<$5.ConnectToPeerRequest> request) async {
    return connectToPeer(call, await request);
  }

  $async.Future<$1.Status> disconnectFromPeer_Pre($grpc.ServiceCall call,
      $async.Future<$5.DisconnectFromPeerRequest> request) async {
    return disconnectFromPeer(call, await request);
  }

  $async.Future<$5.ListPeersResponse> listPeers_Pre($grpc.ServiceCall call,
      $async.Future<$5.ListPeersRequest> request) async {
    return listPeers(call, await request);
  }

  $async.Future<$5.PeerInfoResponse> getPeerInfo_Pre($grpc.ServiceCall call,
      $async.Future<$5.GetPeerInfoRequest> request) async {
    return getPeerInfo(call, await request);
  }

  $async.Future<$1.Status> trustPeer_Pre($grpc.ServiceCall call,
      $async.Future<$5.TrustPeerRequest> request) async {
    return trustPeer(call, await request);
  }

  $async.Future<$1.Status> untrustPeer_Pre($grpc.ServiceCall call,
      $async.Future<$5.UntrustPeerRequest> request) async {
    return untrustPeer(call, await request);
  }

  $async.Future<$1.Status> removePeer_Pre($grpc.ServiceCall call,
      $async.Future<$5.RemovePeerRequest> request) async {
    return removePeer(call, await request);
  }

  $async.Future<$5.DiscoverPeersResponse> discoverPeers(
      $grpc.ServiceCall call, $5.DiscoverPeersRequest request);
  $async.Future<$1.Status> connectToPeer(
      $grpc.ServiceCall call, $5.ConnectToPeerRequest request);
  $async.Future<$1.Status> disconnectFromPeer(
      $grpc.ServiceCall call, $5.DisconnectFromPeerRequest request);
  $async.Future<$5.ListPeersResponse> listPeers(
      $grpc.ServiceCall call, $5.ListPeersRequest request);
  $async.Future<$5.PeerInfoResponse> getPeerInfo(
      $grpc.ServiceCall call, $5.GetPeerInfoRequest request);
  $async.Future<$1.Status> trustPeer(
      $grpc.ServiceCall call, $5.TrustPeerRequest request);
  $async.Future<$1.Status> untrustPeer(
      $grpc.ServiceCall call, $5.UntrustPeerRequest request);
  $async.Future<$1.Status> removePeer(
      $grpc.ServiceCall call, $5.RemovePeerRequest request);
}
