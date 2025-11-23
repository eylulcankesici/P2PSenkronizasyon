// This is a generated file - do not edit.
//
// Generated from api/proto/folder.proto.

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
import 'folder.pb.dart' as $0;

export 'folder.pb.dart';

/// Folder servisi
@$pb.GrpcServiceName('aether.api.FolderService')
class FolderServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  FolderServiceClient(super.channel, {super.options, super.interceptors});

  /// Yeni klasör oluştur
  $grpc.ResponseFuture<$0.FolderResponse> createFolder(
    $0.CreateFolderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$createFolder, request, options: options);
  }

  /// Klasör getir
  $grpc.ResponseFuture<$0.FolderResponse> getFolder(
    $0.GetFolderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getFolder, request, options: options);
  }

  /// Tüm klasörleri listele
  $grpc.ResponseFuture<$0.ListFoldersResponse> listFolders(
    $0.ListFoldersRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listFolders, request, options: options);
  }

  /// Klasör güncelle
  $grpc.ResponseFuture<$0.FolderResponse> updateFolder(
    $0.UpdateFolderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$updateFolder, request, options: options);
  }

  /// Klasör sil
  $grpc.ResponseFuture<$1.Status> deleteFolder(
    $0.DeleteFolderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteFolder, request, options: options);
  }

  /// Klasörü aktif/pasif yap
  $grpc.ResponseFuture<$0.FolderResponse> toggleFolderActive(
    $0.ToggleFolderActiveRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$toggleFolderActive, request, options: options);
  }

  /// Klasörü tara ve dosyaları kaydet
  $grpc.ResponseFuture<$0.ScanFolderResponse> scanFolder(
    $0.ScanFolderRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$scanFolder, request, options: options);
  }

  // method descriptors

  static final _$createFolder =
      $grpc.ClientMethod<$0.CreateFolderRequest, $0.FolderResponse>(
          '/aether.api.FolderService/CreateFolder',
          ($0.CreateFolderRequest value) => value.writeToBuffer(),
          $0.FolderResponse.fromBuffer);
  static final _$getFolder =
      $grpc.ClientMethod<$0.GetFolderRequest, $0.FolderResponse>(
          '/aether.api.FolderService/GetFolder',
          ($0.GetFolderRequest value) => value.writeToBuffer(),
          $0.FolderResponse.fromBuffer);
  static final _$listFolders =
      $grpc.ClientMethod<$0.ListFoldersRequest, $0.ListFoldersResponse>(
          '/aether.api.FolderService/ListFolders',
          ($0.ListFoldersRequest value) => value.writeToBuffer(),
          $0.ListFoldersResponse.fromBuffer);
  static final _$updateFolder =
      $grpc.ClientMethod<$0.UpdateFolderRequest, $0.FolderResponse>(
          '/aether.api.FolderService/UpdateFolder',
          ($0.UpdateFolderRequest value) => value.writeToBuffer(),
          $0.FolderResponse.fromBuffer);
  static final _$deleteFolder =
      $grpc.ClientMethod<$0.DeleteFolderRequest, $1.Status>(
          '/aether.api.FolderService/DeleteFolder',
          ($0.DeleteFolderRequest value) => value.writeToBuffer(),
          $1.Status.fromBuffer);
  static final _$toggleFolderActive =
      $grpc.ClientMethod<$0.ToggleFolderActiveRequest, $0.FolderResponse>(
          '/aether.api.FolderService/ToggleFolderActive',
          ($0.ToggleFolderActiveRequest value) => value.writeToBuffer(),
          $0.FolderResponse.fromBuffer);
  static final _$scanFolder =
      $grpc.ClientMethod<$0.ScanFolderRequest, $0.ScanFolderResponse>(
          '/aether.api.FolderService/ScanFolder',
          ($0.ScanFolderRequest value) => value.writeToBuffer(),
          $0.ScanFolderResponse.fromBuffer);
}

@$pb.GrpcServiceName('aether.api.FolderService')
abstract class FolderServiceBase extends $grpc.Service {
  $core.String get $name => 'aether.api.FolderService';

  FolderServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.CreateFolderRequest, $0.FolderResponse>(
        'CreateFolder',
        createFolder_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.CreateFolderRequest.fromBuffer(value),
        ($0.FolderResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetFolderRequest, $0.FolderResponse>(
        'GetFolder',
        getFolder_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetFolderRequest.fromBuffer(value),
        ($0.FolderResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ListFoldersRequest, $0.ListFoldersResponse>(
            'ListFolders',
            listFolders_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ListFoldersRequest.fromBuffer(value),
            ($0.ListFoldersResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdateFolderRequest, $0.FolderResponse>(
        'UpdateFolder',
        updateFolder_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdateFolderRequest.fromBuffer(value),
        ($0.FolderResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteFolderRequest, $1.Status>(
        'DeleteFolder',
        deleteFolder_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.DeleteFolderRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.ToggleFolderActiveRequest, $0.FolderResponse>(
            'ToggleFolderActive',
            toggleFolderActive_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.ToggleFolderActiveRequest.fromBuffer(value),
            ($0.FolderResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ScanFolderRequest, $0.ScanFolderResponse>(
        'ScanFolder',
        scanFolder_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ScanFolderRequest.fromBuffer(value),
        ($0.ScanFolderResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.FolderResponse> createFolder_Pre($grpc.ServiceCall $call,
      $async.Future<$0.CreateFolderRequest> $request) async {
    return createFolder($call, await $request);
  }

  $async.Future<$0.FolderResponse> createFolder(
      $grpc.ServiceCall call, $0.CreateFolderRequest request);

  $async.Future<$0.FolderResponse> getFolder_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetFolderRequest> $request) async {
    return getFolder($call, await $request);
  }

  $async.Future<$0.FolderResponse> getFolder(
      $grpc.ServiceCall call, $0.GetFolderRequest request);

  $async.Future<$0.ListFoldersResponse> listFolders_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListFoldersRequest> $request) async {
    return listFolders($call, await $request);
  }

  $async.Future<$0.ListFoldersResponse> listFolders(
      $grpc.ServiceCall call, $0.ListFoldersRequest request);

  $async.Future<$0.FolderResponse> updateFolder_Pre($grpc.ServiceCall $call,
      $async.Future<$0.UpdateFolderRequest> $request) async {
    return updateFolder($call, await $request);
  }

  $async.Future<$0.FolderResponse> updateFolder(
      $grpc.ServiceCall call, $0.UpdateFolderRequest request);

  $async.Future<$1.Status> deleteFolder_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteFolderRequest> $request) async {
    return deleteFolder($call, await $request);
  }

  $async.Future<$1.Status> deleteFolder(
      $grpc.ServiceCall call, $0.DeleteFolderRequest request);

  $async.Future<$0.FolderResponse> toggleFolderActive_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.ToggleFolderActiveRequest> $request) async {
    return toggleFolderActive($call, await $request);
  }

  $async.Future<$0.FolderResponse> toggleFolderActive(
      $grpc.ServiceCall call, $0.ToggleFolderActiveRequest request);

  $async.Future<$0.ScanFolderResponse> scanFolder_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ScanFolderRequest> $request) async {
    return scanFolder($call, await $request);
  }

  $async.Future<$0.ScanFolderResponse> scanFolder(
      $grpc.ServiceCall call, $0.ScanFolderRequest request);
}
