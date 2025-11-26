// This is a generated file - do not edit.
//
// Generated from api/proto/chunk.proto.

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

import 'chunk.pb.dart' as $0;

export 'chunk.pb.dart';

/// Chunk servisi - Dosya parçalama ve deduplication
@$pb.GrpcServiceName('aether.api.ChunkService')
class ChunkServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  ChunkServiceClient(super.channel, {super.options, super.interceptors});

  /// Dosyayı chunk'la ve kaydet
  $grpc.ResponseFuture<$0.ChunkFileResponse> chunkFile(
    $0.ChunkFileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$chunkFile, request, options: options);
  }

  /// Dosyanın chunk'larını getir
  $grpc.ResponseFuture<$0.GetFileChunksResponse> getFileChunks(
    $0.GetFileChunksRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getFileChunks, request, options: options);
  }

  /// Chunk verisi indir (binary data)
  $grpc.ResponseStream<$0.ChunkDataResponse> downloadChunk(
    $0.DownloadChunkRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$downloadChunk, $async.Stream.fromIterable([request]),
        options: options);
  }

  /// Chunk yükle (binary data)
  $grpc.ResponseFuture<$0.UploadChunkResponse> uploadChunk(
    $async.Stream<$0.UploadChunkRequest> request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(_$uploadChunk, request, options: options)
        .single;
  }

  /// Dosya bütünlüğünü doğrula
  $grpc.ResponseFuture<$0.VerifyFileIntegrityResponse> verifyFileIntegrity(
    $0.VerifyFileIntegrityRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$verifyFileIntegrity, request, options: options);
  }

  /// Deduplication istatistikleri
  $grpc.ResponseFuture<$0.GetDeduplicationStatsResponse> getDeduplicationStats(
    $0.GetDeduplicationStatsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getDeduplicationStats, request, options: options);
  }

  /// Orphan chunk'ları temizle
  $grpc.ResponseFuture<$0.CleanOrphanChunksResponse> cleanOrphanChunks(
    $0.CleanOrphanChunksRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$cleanOrphanChunks, request, options: options);
  }

  // method descriptors

  static final _$chunkFile =
      $grpc.ClientMethod<$0.ChunkFileRequest, $0.ChunkFileResponse>(
          '/aether.api.ChunkService/ChunkFile',
          ($0.ChunkFileRequest value) => value.writeToBuffer(),
          $0.ChunkFileResponse.fromBuffer);
  static final _$getFileChunks =
      $grpc.ClientMethod<$0.GetFileChunksRequest, $0.GetFileChunksResponse>(
          '/aether.api.ChunkService/GetFileChunks',
          ($0.GetFileChunksRequest value) => value.writeToBuffer(),
          $0.GetFileChunksResponse.fromBuffer);
  static final _$downloadChunk =
      $grpc.ClientMethod<$0.DownloadChunkRequest, $0.ChunkDataResponse>(
          '/aether.api.ChunkService/DownloadChunk',
          ($0.DownloadChunkRequest value) => value.writeToBuffer(),
          $0.ChunkDataResponse.fromBuffer);
  static final _$uploadChunk =
      $grpc.ClientMethod<$0.UploadChunkRequest, $0.UploadChunkResponse>(
          '/aether.api.ChunkService/UploadChunk',
          ($0.UploadChunkRequest value) => value.writeToBuffer(),
          $0.UploadChunkResponse.fromBuffer);
  static final _$verifyFileIntegrity = $grpc.ClientMethod<
          $0.VerifyFileIntegrityRequest, $0.VerifyFileIntegrityResponse>(
      '/aether.api.ChunkService/VerifyFileIntegrity',
      ($0.VerifyFileIntegrityRequest value) => value.writeToBuffer(),
      $0.VerifyFileIntegrityResponse.fromBuffer);
  static final _$getDeduplicationStats = $grpc.ClientMethod<
          $0.GetDeduplicationStatsRequest, $0.GetDeduplicationStatsResponse>(
      '/aether.api.ChunkService/GetDeduplicationStats',
      ($0.GetDeduplicationStatsRequest value) => value.writeToBuffer(),
      $0.GetDeduplicationStatsResponse.fromBuffer);
  static final _$cleanOrphanChunks = $grpc.ClientMethod<
          $0.CleanOrphanChunksRequest, $0.CleanOrphanChunksResponse>(
      '/aether.api.ChunkService/CleanOrphanChunks',
      ($0.CleanOrphanChunksRequest value) => value.writeToBuffer(),
      $0.CleanOrphanChunksResponse.fromBuffer);
}

@$pb.GrpcServiceName('aether.api.ChunkService')
abstract class ChunkServiceBase extends $grpc.Service {
  $core.String get $name => 'aether.api.ChunkService';

  ChunkServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.ChunkFileRequest, $0.ChunkFileResponse>(
        'ChunkFile',
        chunkFile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ChunkFileRequest.fromBuffer(value),
        ($0.ChunkFileResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetFileChunksRequest, $0.GetFileChunksResponse>(
            'GetFileChunks',
            getFileChunks_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetFileChunksRequest.fromBuffer(value),
            ($0.GetFileChunksResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.DownloadChunkRequest, $0.ChunkDataResponse>(
            'DownloadChunk',
            downloadChunk_Pre,
            false,
            true,
            ($core.List<$core.int> value) =>
                $0.DownloadChunkRequest.fromBuffer(value),
            ($0.ChunkDataResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UploadChunkRequest, $0.UploadChunkResponse>(
            'UploadChunk',
            uploadChunk,
            true,
            false,
            ($core.List<$core.int> value) =>
                $0.UploadChunkRequest.fromBuffer(value),
            ($0.UploadChunkResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.VerifyFileIntegrityRequest,
            $0.VerifyFileIntegrityResponse>(
        'VerifyFileIntegrity',
        verifyFileIntegrity_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.VerifyFileIntegrityRequest.fromBuffer(value),
        ($0.VerifyFileIntegrityResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetDeduplicationStatsRequest,
            $0.GetDeduplicationStatsResponse>(
        'GetDeduplicationStats',
        getDeduplicationStats_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetDeduplicationStatsRequest.fromBuffer(value),
        ($0.GetDeduplicationStatsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CleanOrphanChunksRequest,
            $0.CleanOrphanChunksResponse>(
        'CleanOrphanChunks',
        cleanOrphanChunks_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CleanOrphanChunksRequest.fromBuffer(value),
        ($0.CleanOrphanChunksResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ChunkFileResponse> chunkFile_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ChunkFileRequest> $request) async {
    return chunkFile($call, await $request);
  }

  $async.Future<$0.ChunkFileResponse> chunkFile(
      $grpc.ServiceCall call, $0.ChunkFileRequest request);

  $async.Future<$0.GetFileChunksResponse> getFileChunks_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetFileChunksRequest> $request) async {
    return getFileChunks($call, await $request);
  }

  $async.Future<$0.GetFileChunksResponse> getFileChunks(
      $grpc.ServiceCall call, $0.GetFileChunksRequest request);

  $async.Stream<$0.ChunkDataResponse> downloadChunk_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DownloadChunkRequest> $request) async* {
    yield* downloadChunk($call, await $request);
  }

  $async.Stream<$0.ChunkDataResponse> downloadChunk(
      $grpc.ServiceCall call, $0.DownloadChunkRequest request);

  $async.Future<$0.UploadChunkResponse> uploadChunk(
      $grpc.ServiceCall call, $async.Stream<$0.UploadChunkRequest> request);

  $async.Future<$0.VerifyFileIntegrityResponse> verifyFileIntegrity_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.VerifyFileIntegrityRequest> $request) async {
    return verifyFileIntegrity($call, await $request);
  }

  $async.Future<$0.VerifyFileIntegrityResponse> verifyFileIntegrity(
      $grpc.ServiceCall call, $0.VerifyFileIntegrityRequest request);

  $async.Future<$0.GetDeduplicationStatsResponse> getDeduplicationStats_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetDeduplicationStatsRequest> $request) async {
    return getDeduplicationStats($call, await $request);
  }

  $async.Future<$0.GetDeduplicationStatsResponse> getDeduplicationStats(
      $grpc.ServiceCall call, $0.GetDeduplicationStatsRequest request);

  $async.Future<$0.CleanOrphanChunksResponse> cleanOrphanChunks_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.CleanOrphanChunksRequest> $request) async {
    return cleanOrphanChunks($call, await $request);
  }

  $async.Future<$0.CleanOrphanChunksResponse> cleanOrphanChunks(
      $grpc.ServiceCall call, $0.CleanOrphanChunksRequest request);
}
