//
//  Generated code. Do not modify.
//  source: api/proto/folder.proto
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
import 'folder.pb.dart' as $4;

export 'folder.pb.dart';

@$pb.GrpcServiceName('aether.api.FolderService')
class FolderServiceClient extends $grpc.Client {
  static final _$createFolder = $grpc.ClientMethod<$4.CreateFolderRequest, $4.FolderResponse>(
      '/aether.api.FolderService/CreateFolder',
      ($4.CreateFolderRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.FolderResponse.fromBuffer(value));
  static final _$getFolder = $grpc.ClientMethod<$4.GetFolderRequest, $4.FolderResponse>(
      '/aether.api.FolderService/GetFolder',
      ($4.GetFolderRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.FolderResponse.fromBuffer(value));
  static final _$listFolders = $grpc.ClientMethod<$4.ListFoldersRequest, $4.ListFoldersResponse>(
      '/aether.api.FolderService/ListFolders',
      ($4.ListFoldersRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.ListFoldersResponse.fromBuffer(value));
  static final _$updateFolder = $grpc.ClientMethod<$4.UpdateFolderRequest, $4.FolderResponse>(
      '/aether.api.FolderService/UpdateFolder',
      ($4.UpdateFolderRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.FolderResponse.fromBuffer(value));
  static final _$deleteFolder = $grpc.ClientMethod<$4.DeleteFolderRequest, $1.Status>(
      '/aether.api.FolderService/DeleteFolder',
      ($4.DeleteFolderRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Status.fromBuffer(value));
  static final _$toggleFolderActive = $grpc.ClientMethod<$4.ToggleFolderActiveRequest, $4.FolderResponse>(
      '/aether.api.FolderService/ToggleFolderActive',
      ($4.ToggleFolderActiveRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.FolderResponse.fromBuffer(value));
  static final _$scanFolder = $grpc.ClientMethod<$4.ScanFolderRequest, $4.ScanFolderResponse>(
      '/aether.api.FolderService/ScanFolder',
      ($4.ScanFolderRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $4.ScanFolderResponse.fromBuffer(value));

  FolderServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$4.FolderResponse> createFolder($4.CreateFolderRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$createFolder, request, options: options);
  }

  $grpc.ResponseFuture<$4.FolderResponse> getFolder($4.GetFolderRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFolder, request, options: options);
  }

  $grpc.ResponseFuture<$4.ListFoldersResponse> listFolders($4.ListFoldersRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listFolders, request, options: options);
  }

  $grpc.ResponseFuture<$4.FolderResponse> updateFolder($4.UpdateFolderRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$updateFolder, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> deleteFolder($4.DeleteFolderRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteFolder, request, options: options);
  }

  $grpc.ResponseFuture<$4.FolderResponse> toggleFolderActive($4.ToggleFolderActiveRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$toggleFolderActive, request, options: options);
  }

  $grpc.ResponseFuture<$4.ScanFolderResponse> scanFolder($4.ScanFolderRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$scanFolder, request, options: options);
  }
}

@$pb.GrpcServiceName('aether.api.FolderService')
abstract class FolderServiceBase extends $grpc.Service {
  $core.String get $name => 'aether.api.FolderService';

  FolderServiceBase() {
    $addMethod($grpc.ServiceMethod<$4.CreateFolderRequest, $4.FolderResponse>(
        'CreateFolder',
        createFolder_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.CreateFolderRequest.fromBuffer(value),
        ($4.FolderResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.GetFolderRequest, $4.FolderResponse>(
        'GetFolder',
        getFolder_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.GetFolderRequest.fromBuffer(value),
        ($4.FolderResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.ListFoldersRequest, $4.ListFoldersResponse>(
        'ListFolders',
        listFolders_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.ListFoldersRequest.fromBuffer(value),
        ($4.ListFoldersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.UpdateFolderRequest, $4.FolderResponse>(
        'UpdateFolder',
        updateFolder_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.UpdateFolderRequest.fromBuffer(value),
        ($4.FolderResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.DeleteFolderRequest, $1.Status>(
        'DeleteFolder',
        deleteFolder_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.DeleteFolderRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.ToggleFolderActiveRequest, $4.FolderResponse>(
        'ToggleFolderActive',
        toggleFolderActive_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.ToggleFolderActiveRequest.fromBuffer(value),
        ($4.FolderResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$4.ScanFolderRequest, $4.ScanFolderResponse>(
        'ScanFolder',
        scanFolder_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $4.ScanFolderRequest.fromBuffer(value),
        ($4.ScanFolderResponse value) => value.writeToBuffer()));
  }

  $async.Future<$4.FolderResponse> createFolder_Pre($grpc.ServiceCall call, $async.Future<$4.CreateFolderRequest> request) async {
    return createFolder(call, await request);
  }

  $async.Future<$4.FolderResponse> getFolder_Pre($grpc.ServiceCall call, $async.Future<$4.GetFolderRequest> request) async {
    return getFolder(call, await request);
  }

  $async.Future<$4.ListFoldersResponse> listFolders_Pre($grpc.ServiceCall call, $async.Future<$4.ListFoldersRequest> request) async {
    return listFolders(call, await request);
  }

  $async.Future<$4.FolderResponse> updateFolder_Pre($grpc.ServiceCall call, $async.Future<$4.UpdateFolderRequest> request) async {
    return updateFolder(call, await request);
  }

  $async.Future<$1.Status> deleteFolder_Pre($grpc.ServiceCall call, $async.Future<$4.DeleteFolderRequest> request) async {
    return deleteFolder(call, await request);
  }

  $async.Future<$4.FolderResponse> toggleFolderActive_Pre($grpc.ServiceCall call, $async.Future<$4.ToggleFolderActiveRequest> request) async {
    return toggleFolderActive(call, await request);
  }

  $async.Future<$4.ScanFolderResponse> scanFolder_Pre($grpc.ServiceCall call, $async.Future<$4.ScanFolderRequest> request) async {
    return scanFolder(call, await request);
  }

  $async.Future<$4.FolderResponse> createFolder($grpc.ServiceCall call, $4.CreateFolderRequest request);
  $async.Future<$4.FolderResponse> getFolder($grpc.ServiceCall call, $4.GetFolderRequest request);
  $async.Future<$4.ListFoldersResponse> listFolders($grpc.ServiceCall call, $4.ListFoldersRequest request);
  $async.Future<$4.FolderResponse> updateFolder($grpc.ServiceCall call, $4.UpdateFolderRequest request);
  $async.Future<$1.Status> deleteFolder($grpc.ServiceCall call, $4.DeleteFolderRequest request);
  $async.Future<$4.FolderResponse> toggleFolderActive($grpc.ServiceCall call, $4.ToggleFolderActiveRequest request);
  $async.Future<$4.ScanFolderResponse> scanFolder($grpc.ServiceCall call, $4.ScanFolderRequest request);
}
