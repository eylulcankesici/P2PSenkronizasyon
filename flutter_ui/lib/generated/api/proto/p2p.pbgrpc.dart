///
//  Generated code. Do not modify.
//  source: api/proto/p2p.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'p2p.pb.dart' as $4;
export 'p2p.pb.dart';

class P2PDataServiceClient extends $grpc.Client {
  static final _$requestChunk =
      $grpc.ClientMethod<$4.ChunkRequest, $4.ChunkResponse>(
          '/aether.api.P2PDataService/RequestChunk',
          ($4.ChunkRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $4.ChunkResponse.fromBuffer(value));
  static final _$transferChunk =
      $grpc.ClientMethod<$4.ChunkData, $4.TransferStatus>(
          '/aether.api.P2PDataService/TransferChunk',
          ($4.ChunkData value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $4.TransferStatus.fromBuffer(value));
  static final _$shareFileMetadata =
      $grpc.ClientMethod<$4.FileMetadataRequest, $4.FileMetadataResponse>(
          '/aether.api.P2PDataService/ShareFileMetadata',
          ($4.FileMetadataRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $4.FileMetadataResponse.fromBuffer(value));
  static final _$ping = $grpc.ClientMethod<$4.PingRequest, $4.PingResponse>(
      '/aether.api.P2PDataService/Ping',
      ($4.PingRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.PingResponse.fromBuffer(value));

  P2PDataServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$4.ChunkResponse> requestChunk($4.ChunkRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$requestChunk, request, options: options);
  }

  $grpc.ResponseFuture<$4.TransferStatus> transferChunk(
      $async.Stream<$4.ChunkData> request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$transferChunk, request, options: options)
        .single;
  }

  $grpc.ResponseFuture<$4.FileMetadataResponse> shareFileMetadata(
      $4.FileMetadataRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$shareFileMetadata, request, options: options);
  }

  $grpc.ResponseFuture<$4.PingResponse> ping($4.PingRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$ping, request, options: options);
  }
}

abstract class P2PDataServiceBase extends $grpc.Service {
  $core.String get $name => 'aether.api.P2PDataService';

  P2PDataServiceBase() {
    $addMethod($grpc.ServiceMethod<$4.ChunkRequest, $4.ChunkResponse>(
        'RequestChunk',
        requestChunk_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.ChunkRequest.fromBuffer(value),
        ($4.ChunkResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.ChunkData, $4.TransferStatus>(
        'TransferChunk',
        transferChunk,
        true,
        false,
        ($core.List<$core.int> value) => $4.ChunkData.fromBuffer(value),
        ($4.TransferStatus value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$4.FileMetadataRequest, $4.FileMetadataResponse>(
            'ShareFileMetadata',
            shareFileMetadata_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $4.FileMetadataRequest.fromBuffer(value),
            ($4.FileMetadataResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.PingRequest, $4.PingResponse>(
        'Ping',
        ping_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.PingRequest.fromBuffer(value),
        ($4.PingResponse value) => value.writeToBuffer()));
  }

  $async.Future<$4.ChunkResponse> requestChunk_Pre(
      $grpc.ServiceCall call, $async.Future<$4.ChunkRequest> request) async {
    return requestChunk(call, await request);
  }

  $async.Future<$4.FileMetadataResponse> shareFileMetadata_Pre(
      $grpc.ServiceCall call,
      $async.Future<$4.FileMetadataRequest> request) async {
    return shareFileMetadata(call, await request);
  }

  $async.Future<$4.PingResponse> ping_Pre(
      $grpc.ServiceCall call, $async.Future<$4.PingRequest> request) async {
    return ping(call, await request);
  }

  $async.Future<$4.ChunkResponse> requestChunk(
      $grpc.ServiceCall call, $4.ChunkRequest request);
  $async.Future<$4.TransferStatus> transferChunk(
      $grpc.ServiceCall call, $async.Stream<$4.ChunkData> request);
  $async.Future<$4.FileMetadataResponse> shareFileMetadata(
      $grpc.ServiceCall call, $4.FileMetadataRequest request);
  $async.Future<$4.PingResponse> ping(
      $grpc.ServiceCall call, $4.PingRequest request);
}
