// This is a generated file - do not edit.
//
// Generated from api/proto/p2p.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $1;
import 'p2p.pb.dart' as $0;

export 'p2p.pb.dart';

/// P2P data transfer servisi
/// Bu servis peer'lar arası direkt iletişim için kullanılır
@$pb.GrpcServiceName('aether.api.P2PDataService')
class P2PDataServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  P2PDataServiceClient(super.channel, {super.options, super.interceptors});

  /// Chunk talep et
  $grpc.ResponseFuture<$0.ChunkResponse> requestChunk(
    $0.ChunkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$requestChunk, request, options: options);
  }

  /// Chunk gönder (streaming)
  $grpc.ResponseFuture<$0.TransferStatus> transferChunk(
    $async.Stream<$0.ChunkData> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$transferChunk, request, options: options)
        .single;
  }

  /// Dosya metadata'sını paylaş
  $grpc.ResponseFuture<$0.FileMetadataResponse> shareFileMetadata(
    $0.FileMetadataRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$shareFileMetadata, request, options: options);
  }

  /// Ping (bağlantı testi)
  $grpc.ResponseFuture<$0.PingResponse> ping(
    $0.PingRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$ping, request, options: options);
  }

  // method descriptors

  static final _$requestChunk =
      $grpc.ClientMethod<$0.ChunkRequest, $0.ChunkResponse>(
          '/aether.api.P2PDataService/RequestChunk',
          ($0.ChunkRequest value) => value.writeToBuffer(),
          $0.ChunkResponse.fromBuffer);
  static final _$transferChunk =
      $grpc.ClientMethod<$0.ChunkData, $0.TransferStatus>(
          '/aether.api.P2PDataService/TransferChunk',
          ($0.ChunkData value) => value.writeToBuffer(),
          $0.TransferStatus.fromBuffer);
  static final _$shareFileMetadata =
      $grpc.ClientMethod<$0.FileMetadataRequest, $0.FileMetadataResponse>(
          '/aether.api.P2PDataService/ShareFileMetadata',
          ($0.FileMetadataRequest value) => value.writeToBuffer(),
          $0.FileMetadataResponse.fromBuffer);
  static final _$ping = $grpc.ClientMethod<$0.PingRequest, $0.PingResponse>(
      '/aether.api.P2PDataService/Ping',
      ($0.PingRequest value) => value.writeToBuffer(),
      $0.PingResponse.fromBuffer);
}

@$pb.GrpcServiceName('aether.api.P2PDataService')
abstract class P2PDataServiceBase extends $grpc.Service {
  $core.String get $name => 'aether.api.P2PDataService';

  P2PDataServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ChunkRequest, $0.ChunkResponse>(
        'RequestChunk',
        requestChunk_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ChunkRequest.fromBuffer(value),
        ($0.ChunkResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ChunkData, $0.TransferStatus>(
        'TransferChunk',
        transferChunk,
        true,
        false,
        ($core.List<$core.int> value) => $0.ChunkData.fromBuffer(value),
        ($0.TransferStatus value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.FileMetadataRequest, $0.FileMetadataResponse>(
            'ShareFileMetadata',
            shareFileMetadata_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.FileMetadataRequest.fromBuffer(value),
            ($0.FileMetadataResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PingRequest, $0.PingResponse>(
        'Ping',
        ping_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PingRequest.fromBuffer(value),
        ($0.PingResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ChunkResponse> requestChunk_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.ChunkRequest> $request) async {
    return requestChunk($call, await $request);
  }

  $async.Future<$0.ChunkResponse> requestChunk(
      $grpc.ServiceCall call, $0.ChunkRequest request);

  $async.Future<$0.TransferStatus> transferChunk(
      $grpc.ServiceCall call, $async.Stream<$0.ChunkData> request);

  $async.Future<$0.FileMetadataResponse> shareFileMetadata_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.FileMetadataRequest> $request) async {
    return shareFileMetadata($call, await $request);
  }

  $async.Future<$0.FileMetadataResponse> shareFileMetadata(
      $grpc.ServiceCall call, $0.FileMetadataRequest request);

  $async.Future<$0.PingResponse> ping_Pre(
      $grpc.ServiceCall $call, $async.Future<$0.PingRequest> $request) async {
    return ping($call, await $request);
  }

  $async.Future<$0.PingResponse> ping(
      $grpc.ServiceCall call, $0.PingRequest request);
}

/// Transfer servisi - transfer durumunu yönetir
@$pb.GrpcServiceName('aether.api.TransferService')
class TransferServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  TransferServiceClient(super.channel, {super.options, super.interceptors});

  /// Aktif transferleri listele
  $grpc.ResponseFuture<$0.ListTransfersResponse> listTransfers(
    $0.ListTransfersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listTransfers, request, options: options);
  }

  /// Belirli bir transfer durumunu al
  $grpc.ResponseFuture<$0.GetTransferStatusResponse> getTransferStatus(
    $0.GetTransferStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getTransferStatus, request, options: options);
  }

  /// Transfer'i iptal et
  $grpc.ResponseFuture<$1.Status> cancelTransfer(
    $0.CancelTransferRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cancelTransfer, request, options: options);
  }

  // method descriptors

  static final _$listTransfers =
      $grpc.ClientMethod<$0.ListTransfersRequest, $0.ListTransfersResponse>(
          '/aether.api.TransferService/ListTransfers',
          ($0.ListTransfersRequest value) => value.writeToBuffer(),
          $0.ListTransfersResponse.fromBuffer);
  static final _$getTransferStatus = $grpc.ClientMethod<
          $0.GetTransferStatusRequest, $0.GetTransferStatusResponse>(
      '/aether.api.TransferService/GetTransferStatus',
      ($0.GetTransferStatusRequest value) => value.writeToBuffer(),
      $0.GetTransferStatusResponse.fromBuffer);
  static final _$cancelTransfer =
      $grpc.ClientMethod<$0.CancelTransferRequest, $1.Status>(
          '/aether.api.TransferService/CancelTransfer',
          ($0.CancelTransferRequest value) => value.writeToBuffer(),
          $1.Status.fromBuffer);
}

@$pb.GrpcServiceName('aether.api.TransferService')
abstract class TransferServiceBase extends $grpc.Service {
  $core.String get $name => 'aether.api.TransferService';

  TransferServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.ListTransfersRequest, $0.ListTransfersResponse>(
            'ListTransfers',
            listTransfers_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListTransfersRequest.fromBuffer(value),
            ($0.ListTransfersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetTransferStatusRequest,
            $0.GetTransferStatusResponse>(
        'GetTransferStatus',
        getTransferStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetTransferStatusRequest.fromBuffer(value),
        ($0.GetTransferStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CancelTransferRequest, $1.Status>(
        'CancelTransfer',
        cancelTransfer_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CancelTransferRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
  }

  $async.Future<$0.ListTransfersResponse> listTransfers_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ListTransfersRequest> $request) async {
    return listTransfers($call, await $request);
  }

  $async.Future<$0.ListTransfersResponse> listTransfers(
      $grpc.ServiceCall call, $0.ListTransfersRequest request);

  $async.Future<$0.GetTransferStatusResponse> getTransferStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetTransferStatusRequest> $request) async {
    return getTransferStatus($call, await $request);
  }

  $async.Future<$0.GetTransferStatusResponse> getTransferStatus(
      $grpc.ServiceCall call, $0.GetTransferStatusRequest request);

  $async.Future<$1.Status> cancelTransfer_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CancelTransferRequest> $request) async {
    return cancelTransfer($call, await $request);
  }

  $async.Future<$1.Status> cancelTransfer(
      $grpc.ServiceCall call, $0.CancelTransferRequest request);
}
