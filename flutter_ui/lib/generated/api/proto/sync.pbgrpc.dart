// This is a generated file - do not edit.
//
// Generated from api/proto/sync.proto.

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
import 'sync.pb.dart' as $0;

export 'sync.pb.dart';

/// Sync servisi
@$pb.GrpcServiceName('aether.api.SyncService')
class SyncServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  SyncServiceClient(super.channel, {super.options, super.interceptors});

  /// Dosya senkronize et
  $grpc.ResponseFuture<$0.SyncFileResponse> syncFile(
    $0.SyncFileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$syncFile, request, options: options);
  }

  /// Klasör senkronize et (tüm dosyaları senkronize eder)
  $grpc.ResponseFuture<$0.SyncFolderResponse> syncFolder(
    $0.SyncFolderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$syncFolder, request, options: options);
  }

  /// Senkronizasyon durumunu getir
  $grpc.ResponseFuture<$0.SyncStatusResponse> getSyncStatus(
    $0.GetSyncStatusRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getSyncStatus, request, options: options);
  }

  /// Senkronizasyonu duraklat/devam ettir
  $grpc.ResponseFuture<$1.Status> pauseSync(
    $0.PauseSyncRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$pauseSync, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> resumeSync(
    $0.ResumeSyncRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$resumeSync, request, options: options);
  }

  /// Real-time senkronizasyon olaylarını dinle (streaming)
  $grpc.ResponseStream<$0.SyncEvent> watchSyncEvents(
    $0.WatchSyncEventsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createStreamingCall(
        _$watchSyncEvents, $async.Stream.fromIterable([request]),
        options: options);
  }

  // method descriptors

  static final _$syncFile =
      $grpc.ClientMethod<$0.SyncFileRequest, $0.SyncFileResponse>(
          '/aether.api.SyncService/SyncFile',
          ($0.SyncFileRequest value) => value.writeToBuffer(),
          $0.SyncFileResponse.fromBuffer);
  static final _$syncFolder =
      $grpc.ClientMethod<$0.SyncFolderRequest, $0.SyncFolderResponse>(
          '/aether.api.SyncService/SyncFolder',
          ($0.SyncFolderRequest value) => value.writeToBuffer(),
          $0.SyncFolderResponse.fromBuffer);
  static final _$getSyncStatus =
      $grpc.ClientMethod<$0.GetSyncStatusRequest, $0.SyncStatusResponse>(
          '/aether.api.SyncService/GetSyncStatus',
          ($0.GetSyncStatusRequest value) => value.writeToBuffer(),
          $0.SyncStatusResponse.fromBuffer);
  static final _$pauseSync = $grpc.ClientMethod<$0.PauseSyncRequest, $1.Status>(
      '/aether.api.SyncService/PauseSync',
      ($0.PauseSyncRequest value) => value.writeToBuffer(),
      $1.Status.fromBuffer);
  static final _$resumeSync =
      $grpc.ClientMethod<$0.ResumeSyncRequest, $1.Status>(
          '/aether.api.SyncService/ResumeSync',
          ($0.ResumeSyncRequest value) => value.writeToBuffer(),
          $1.Status.fromBuffer);
  static final _$watchSyncEvents =
      $grpc.ClientMethod<$0.WatchSyncEventsRequest, $0.SyncEvent>(
          '/aether.api.SyncService/WatchSyncEvents',
          ($0.WatchSyncEventsRequest value) => value.writeToBuffer(),
          $0.SyncEvent.fromBuffer);
}

@$pb.GrpcServiceName('aether.api.SyncService')
abstract class SyncServiceBase extends $grpc.Service {
  $core.String get $name => 'aether.api.SyncService';

  SyncServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.SyncFileRequest, $0.SyncFileResponse>(
        'SyncFile',
        syncFile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncFileRequest.fromBuffer(value),
        ($0.SyncFileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SyncFolderRequest, $0.SyncFolderResponse>(
        'SyncFolder',
        syncFolder_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SyncFolderRequest.fromBuffer(value),
        ($0.SyncFolderResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetSyncStatusRequest, $0.SyncStatusResponse>(
            'GetSyncStatus',
            getSyncStatus_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetSyncStatusRequest.fromBuffer(value),
            ($0.SyncStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.PauseSyncRequest, $1.Status>(
        'PauseSync',
        pauseSync_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.PauseSyncRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ResumeSyncRequest, $1.Status>(
        'ResumeSync',
        resumeSync_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ResumeSyncRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.WatchSyncEventsRequest, $0.SyncEvent>(
        'WatchSyncEvents',
        watchSyncEvents_Pre,
        false,
        true,
        ($core.List<$core.int> value) =>
            $0.WatchSyncEventsRequest.fromBuffer(value),
        ($0.SyncEvent value) => value.writeToBuffer()));
  }

  $async.Future<$0.SyncFileResponse> syncFile_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SyncFileRequest> $request) async {
    return syncFile($call, await $request);
  }

  $async.Future<$0.SyncFileResponse> syncFile(
      $grpc.ServiceCall call, $0.SyncFileRequest request);

  $async.Future<$0.SyncFolderResponse> syncFolder_Pre($grpc.ServiceCall $call,
      $async.Future<$0.SyncFolderRequest> $request) async {
    return syncFolder($call, await $request);
  }

  $async.Future<$0.SyncFolderResponse> syncFolder(
      $grpc.ServiceCall call, $0.SyncFolderRequest request);

  $async.Future<$0.SyncStatusResponse> getSyncStatus_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetSyncStatusRequest> $request) async {
    return getSyncStatus($call, await $request);
  }

  $async.Future<$0.SyncStatusResponse> getSyncStatus(
      $grpc.ServiceCall call, $0.GetSyncStatusRequest request);

  $async.Future<$1.Status> pauseSync_Pre($grpc.ServiceCall $call,
      $async.Future<$0.PauseSyncRequest> $request) async {
    return pauseSync($call, await $request);
  }

  $async.Future<$1.Status> pauseSync(
      $grpc.ServiceCall call, $0.PauseSyncRequest request);

  $async.Future<$1.Status> resumeSync_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ResumeSyncRequest> $request) async {
    return resumeSync($call, await $request);
  }

  $async.Future<$1.Status> resumeSync(
      $grpc.ServiceCall call, $0.ResumeSyncRequest request);

  $async.Stream<$0.SyncEvent> watchSyncEvents_Pre($grpc.ServiceCall $call,
      $async.Future<$0.WatchSyncEventsRequest> $request) async* {
    yield* watchSyncEvents($call, await $request);
  }

  $async.Stream<$0.SyncEvent> watchSyncEvents(
      $grpc.ServiceCall call, $0.WatchSyncEventsRequest request);
}
