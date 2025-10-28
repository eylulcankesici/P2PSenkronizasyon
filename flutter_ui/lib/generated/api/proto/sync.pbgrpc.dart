//
//  Generated code. Do not modify.
//  source: api/proto/sync.proto
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
import 'sync.pb.dart' as $6;

export 'sync.pb.dart';

@$pb.GrpcServiceName('aether.api.SyncService')
class SyncServiceClient extends $grpc.Client {
  static final _$syncFile = $grpc.ClientMethod<$6.SyncFileRequest, $6.SyncFileResponse>(
      '/aether.api.SyncService/SyncFile',
      ($6.SyncFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $6.SyncFileResponse.fromBuffer(value));
  static final _$getSyncStatus = $grpc.ClientMethod<$6.GetSyncStatusRequest, $6.SyncStatusResponse>(
      '/aether.api.SyncService/GetSyncStatus',
      ($6.GetSyncStatusRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $6.SyncStatusResponse.fromBuffer(value));
  static final _$pauseSync = $grpc.ClientMethod<$6.PauseSyncRequest, $1.Status>(
      '/aether.api.SyncService/PauseSync',
      ($6.PauseSyncRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Status.fromBuffer(value));
  static final _$resumeSync = $grpc.ClientMethod<$6.ResumeSyncRequest, $1.Status>(
      '/aether.api.SyncService/ResumeSync',
      ($6.ResumeSyncRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Status.fromBuffer(value));
  static final _$watchSyncEvents = $grpc.ClientMethod<$6.WatchSyncEventsRequest, $6.SyncEvent>(
      '/aether.api.SyncService/WatchSyncEvents',
      ($6.WatchSyncEventsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $6.SyncEvent.fromBuffer(value));

  SyncServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$6.SyncFileResponse> syncFile($6.SyncFileRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$syncFile, request, options: options);
  }

  $grpc.ResponseFuture<$6.SyncStatusResponse> getSyncStatus($6.GetSyncStatusRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getSyncStatus, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> pauseSync($6.PauseSyncRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$pauseSync, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> resumeSync($6.ResumeSyncRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$resumeSync, request, options: options);
  }

  $grpc.ResponseStream<$6.SyncEvent> watchSyncEvents($6.WatchSyncEventsRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$watchSyncEvents, $async.Stream.fromIterable([request]), options: options);
  }
}

@$pb.GrpcServiceName('aether.api.SyncService')
abstract class SyncServiceBase extends $grpc.Service {
  $core.String get $name => 'aether.api.SyncService';

  SyncServiceBase() {
    $addMethod($grpc.ServiceMethod<$6.SyncFileRequest, $6.SyncFileResponse>(
        'SyncFile',
        syncFile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.SyncFileRequest.fromBuffer(value),
        ($6.SyncFileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.GetSyncStatusRequest, $6.SyncStatusResponse>(
        'GetSyncStatus',
        getSyncStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.GetSyncStatusRequest.fromBuffer(value),
        ($6.SyncStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.PauseSyncRequest, $1.Status>(
        'PauseSync',
        pauseSync_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.PauseSyncRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.ResumeSyncRequest, $1.Status>(
        'ResumeSync',
        resumeSync_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $6.ResumeSyncRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$6.WatchSyncEventsRequest, $6.SyncEvent>(
        'WatchSyncEvents',
        watchSyncEvents_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $6.WatchSyncEventsRequest.fromBuffer(value),
        ($6.SyncEvent value) => value.writeToBuffer()));
  }

  $async.Future<$6.SyncFileResponse> syncFile_Pre($grpc.ServiceCall call, $async.Future<$6.SyncFileRequest> request) async {
    return syncFile(call, await request);
  }

  $async.Future<$6.SyncStatusResponse> getSyncStatus_Pre($grpc.ServiceCall call, $async.Future<$6.GetSyncStatusRequest> request) async {
    return getSyncStatus(call, await request);
  }

  $async.Future<$1.Status> pauseSync_Pre($grpc.ServiceCall call, $async.Future<$6.PauseSyncRequest> request) async {
    return pauseSync(call, await request);
  }

  $async.Future<$1.Status> resumeSync_Pre($grpc.ServiceCall call, $async.Future<$6.ResumeSyncRequest> request) async {
    return resumeSync(call, await request);
  }

  $async.Stream<$6.SyncEvent> watchSyncEvents_Pre($grpc.ServiceCall call, $async.Future<$6.WatchSyncEventsRequest> request) async* {
    yield* watchSyncEvents(call, await request);
  }

  $async.Future<$6.SyncFileResponse> syncFile($grpc.ServiceCall call, $6.SyncFileRequest request);
  $async.Future<$6.SyncStatusResponse> getSyncStatus($grpc.ServiceCall call, $6.GetSyncStatusRequest request);
  $async.Future<$1.Status> pauseSync($grpc.ServiceCall call, $6.PauseSyncRequest request);
  $async.Future<$1.Status> resumeSync($grpc.ServiceCall call, $6.ResumeSyncRequest request);
  $async.Stream<$6.SyncEvent> watchSyncEvents($grpc.ServiceCall call, $6.WatchSyncEventsRequest request);
}
