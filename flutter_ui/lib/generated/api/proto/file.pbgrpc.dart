// This is a generated file - do not edit.
//
// Generated from api/proto/file.proto.

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
import 'file.pb.dart' as $0;

export 'file.pb.dart';

/// File servisi
@$pb.GrpcServiceName('aether.api.FileService')
class FileServiceClient extends $grpc.Client {
  /// The hostname for this service.
  static const $core.String defaultHost = '';

  /// OAuth scopes needed for the client.
  static const $core.List<$core.String> oauthScopes = [
    '',
  ];

  FileServiceClient(super.channel, {super.options, super.interceptors});

  /// Dosya bilgisi getir
  $grpc.ResponseFuture<$0.FileResponse> getFile(
    $0.GetFileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getFile, request, options: options);
  }

  /// Klasördeki dosyaları listele
  $grpc.ResponseFuture<$0.ListFilesResponse> listFiles(
    $0.ListFilesRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$listFiles, request, options: options);
  }

  /// Dosya detay bilgisi getir
  $grpc.ResponseFuture<$0.FileInfoResponse> getFileInfo(
    $0.GetFileInfoRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getFileInfo, request, options: options);
  }

  /// Dosya sil
  $grpc.ResponseFuture<$1.Status> deleteFile(
    $0.DeleteFileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$deleteFile, request, options: options);
  }

  /// Dosya versiyonlarını getir
  $grpc.ResponseFuture<$0.FileVersionsResponse> getFileVersions(
    $0.GetFileVersionsRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$getFileVersions, request, options: options);
  }

  /// Dosyayı geri yükle
  $grpc.ResponseFuture<$1.Status> restoreFile(
    $0.RestoreFileRequest request, {
    $grpc.CallOptions? options,
  }) {
    return $createUnaryCall(_$restoreFile, request, options: options);
  }

  // method descriptors

  static final _$getFile =
      $grpc.ClientMethod<$0.GetFileRequest, $0.FileResponse>(
          '/aether.api.FileService/GetFile',
          ($0.GetFileRequest value) => value.writeToBuffer(),
          $0.FileResponse.fromBuffer);
  static final _$listFiles =
      $grpc.ClientMethod<$0.ListFilesRequest, $0.ListFilesResponse>(
          '/aether.api.FileService/ListFiles',
          ($0.ListFilesRequest value) => value.writeToBuffer(),
          $0.ListFilesResponse.fromBuffer);
  static final _$getFileInfo =
      $grpc.ClientMethod<$0.GetFileInfoRequest, $0.FileInfoResponse>(
          '/aether.api.FileService/GetFileInfo',
          ($0.GetFileInfoRequest value) => value.writeToBuffer(),
          $0.FileInfoResponse.fromBuffer);
  static final _$deleteFile =
      $grpc.ClientMethod<$0.DeleteFileRequest, $1.Status>(
          '/aether.api.FileService/DeleteFile',
          ($0.DeleteFileRequest value) => value.writeToBuffer(),
          $1.Status.fromBuffer);
  static final _$getFileVersions =
      $grpc.ClientMethod<$0.GetFileVersionsRequest, $0.FileVersionsResponse>(
          '/aether.api.FileService/GetFileVersions',
          ($0.GetFileVersionsRequest value) => value.writeToBuffer(),
          $0.FileVersionsResponse.fromBuffer);
  static final _$restoreFile =
      $grpc.ClientMethod<$0.RestoreFileRequest, $1.Status>(
          '/aether.api.FileService/RestoreFile',
          ($0.RestoreFileRequest value) => value.writeToBuffer(),
          $1.Status.fromBuffer);
}

@$pb.GrpcServiceName('aether.api.FileService')
abstract class FileServiceBase extends $grpc.Service {
  $core.String get $name => 'aether.api.FileService';

  FileServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.GetFileRequest, $0.FileResponse>(
        'GetFile',
        getFile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetFileRequest.fromBuffer(value),
        ($0.FileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ListFilesRequest, $0.ListFilesResponse>(
        'ListFiles',
        listFiles_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ListFilesRequest.fromBuffer(value),
        ($0.ListFilesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetFileInfoRequest, $0.FileInfoResponse>(
        'GetFileInfo',
        getFileInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetFileInfoRequest.fromBuffer(value),
        ($0.FileInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.DeleteFileRequest, $1.Status>(
        'DeleteFile',
        deleteFile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.DeleteFileRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.GetFileVersionsRequest, $0.FileVersionsResponse>(
            'GetFileVersions',
            getFileVersions_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.GetFileVersionsRequest.fromBuffer(value),
            ($0.FileVersionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.RestoreFileRequest, $1.Status>(
        'RestoreFile',
        restoreFile_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.RestoreFileRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
  }

  $async.Future<$0.FileResponse> getFile_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetFileRequest> $request) async {
    return getFile($call, await $request);
  }

  $async.Future<$0.FileResponse> getFile(
      $grpc.ServiceCall call, $0.GetFileRequest request);

  $async.Future<$0.ListFilesResponse> listFiles_Pre($grpc.ServiceCall $call,
      $async.Future<$0.ListFilesRequest> $request) async {
    return listFiles($call, await $request);
  }

  $async.Future<$0.ListFilesResponse> listFiles(
      $grpc.ServiceCall call, $0.ListFilesRequest request);

  $async.Future<$0.FileInfoResponse> getFileInfo_Pre($grpc.ServiceCall $call,
      $async.Future<$0.GetFileInfoRequest> $request) async {
    return getFileInfo($call, await $request);
  }

  $async.Future<$0.FileInfoResponse> getFileInfo(
      $grpc.ServiceCall call, $0.GetFileInfoRequest request);

  $async.Future<$1.Status> deleteFile_Pre($grpc.ServiceCall $call,
      $async.Future<$0.DeleteFileRequest> $request) async {
    return deleteFile($call, await $request);
  }

  $async.Future<$1.Status> deleteFile(
      $grpc.ServiceCall call, $0.DeleteFileRequest request);

  $async.Future<$0.FileVersionsResponse> getFileVersions_Pre(
      $grpc.ServiceCall $call,
      $async.Future<$0.GetFileVersionsRequest> $request) async {
    return getFileVersions($call, await $request);
  }

  $async.Future<$0.FileVersionsResponse> getFileVersions(
      $grpc.ServiceCall call, $0.GetFileVersionsRequest request);

  $async.Future<$1.Status> restoreFile_Pre($grpc.ServiceCall $call,
      $async.Future<$0.RestoreFileRequest> $request) async {
    return restoreFile($call, await $request);
  }

  $async.Future<$1.Status> restoreFile(
      $grpc.ServiceCall call, $0.RestoreFileRequest request);
}
