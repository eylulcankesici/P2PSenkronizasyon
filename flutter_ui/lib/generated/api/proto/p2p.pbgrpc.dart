//
//  Generated code. Do not modify.
//  source: api/proto/p2p.proto
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

import 'p2p.pb.dart' as $5;

export 'p2p.pb.dart';

@$pb.GrpcServiceName('aether.api.P2PDataService')
class P2PDataServiceClient extends $grpc.Client {
  static final _$requestChunk = $grpc.ClientMethod<$5.ChunkRequest, $5.ChunkResponse>(
      '/aether.api.P2PDataService/RequestChunk',
      ($5.ChunkRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $5.ChunkResponse.fromBuffer(value));
  static final _$transferChunk = $grpc.ClientMethod<$5.ChunkData, $5.TransferStatus>(
      '/aether.api.P2PDataService/TransferChunk',
      ($5.ChunkData value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $5.TransferStatus.fromBuffer(value));
  static final _$shareFileMetadata = $grpc.ClientMethod<$5.FileMetadataRequest, $5.FileMetadataResponse>(
      '/aether.api.P2PDataService/ShareFileMetadata',
      ($5.FileMetadataRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $5.FileMetadataResponse.fromBuffer(value));
  static final _$ping = $grpc.ClientMethod<$5.PingRequest, $5.PingResponse>(
      '/aether.api.P2PDataService/Ping',
      ($5.PingRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $5.PingResponse.fromBuffer(value));

  P2PDataServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$5.ChunkResponse> requestChunk($5.ChunkRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$requestChunk, request, options: options);
  }

  $grpc.ResponseFuture<$5.TransferStatus> transferChunk($async.Stream<$5.ChunkData> request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$transferChunk, request, options: options).single;
  }

  $grpc.ResponseFuture<$5.FileMetadataResponse> shareFileMetadata($5.FileMetadataRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$shareFileMetadata, request, options: options);
  }

  $grpc.ResponseFuture<$5.PingResponse> ping($5.PingRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$ping, request, options: options);
  }
}

@$pb.GrpcServiceName('aether.api.P2PDataService')
abstract class P2PDataServiceBase extends $grpc.Service {
  $core.String get $name => 'aether.api.P2PDataService';

  P2PDataServiceBase() {
    $addMethod($grpc.ServiceMethod<$5.ChunkRequest, $5.ChunkResponse>(
        'RequestChunk',
        requestChunk_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.ChunkRequest.fromBuffer(value),
        ($5.ChunkResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.ChunkData, $5.TransferStatus>(
        'TransferChunk',
        transferChunk,
        true,
        false,
        ($core.List<$core.int> value) => $5.ChunkData.fromBuffer(value),
        ($5.TransferStatus value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.FileMetadataRequest, $5.FileMetadataResponse>(
        'ShareFileMetadata',
        shareFileMetadata_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.FileMetadataRequest.fromBuffer(value),
        ($5.FileMetadataResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$5.PingRequest, $5.PingResponse>(
        'Ping',
        ping_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $5.PingRequest.fromBuffer(value),
        ($5.PingResponse value) => value.writeToBuffer()));
  }

  $async.Future<$5.ChunkResponse> requestChunk_Pre($grpc.ServiceCall call, $async.Future<$5.ChunkRequest> request) async {
    return requestChunk(call, await request);
  }

  $async.Future<$5.FileMetadataResponse> shareFileMetadata_Pre($grpc.ServiceCall call, $async.Future<$5.FileMetadataRequest> request) async {
    return shareFileMetadata(call, await request);
  }

  $async.Future<$5.PingResponse> ping_Pre($grpc.ServiceCall call, $async.Future<$5.PingRequest> request) async {
    return ping(call, await request);
  }

  $async.Future<$5.ChunkResponse> requestChunk($grpc.ServiceCall call, $5.ChunkRequest request);
  $async.Future<$5.TransferStatus> transferChunk($grpc.ServiceCall call, $async.Stream<$5.ChunkData> request);
  $async.Future<$5.FileMetadataResponse> shareFileMetadata($grpc.ServiceCall call, $5.FileMetadataRequest request);
  $async.Future<$5.PingResponse> ping($grpc.ServiceCall call, $5.PingRequest request);
}
