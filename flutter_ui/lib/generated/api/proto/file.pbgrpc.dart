///
//  Generated code. Do not modify.
//  source: api/proto/file.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'file.pb.dart' as $2;
import 'common.pb.dart' as $1;
export 'file.pb.dart';

class FileServiceClient extends $grpc.Client {
  static final _$getFile =
      $grpc.ClientMethod<$2.GetFileRequest, $2.FileResponse>(
          '/aether.api.FileService/GetFile',
          ($2.GetFileRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $2.FileResponse.fromBuffer(value));
  static final _$listFiles =
      $grpc.ClientMethod<$2.ListFilesRequest, $2.ListFilesResponse>(
          '/aether.api.FileService/ListFiles',
          ($2.ListFilesRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $2.ListFilesResponse.fromBuffer(value));
  static final _$getFileInfo =
      $grpc.ClientMethod<$2.GetFileInfoRequest, $2.FileInfoResponse>(
          '/aether.api.FileService/GetFileInfo',
          ($2.GetFileInfoRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $2.FileInfoResponse.fromBuffer(value));
  static final _$deleteFile =
      $grpc.ClientMethod<$2.DeleteFileRequest, $1.Status>(
          '/aether.api.FileService/DeleteFile',
          ($2.DeleteFileRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Status.fromBuffer(value));
  static final _$getFileVersions =
      $grpc.ClientMethod<$2.GetFileVersionsRequest, $2.FileVersionsResponse>(
          '/aether.api.FileService/GetFileVersions',
          ($2.GetFileVersionsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $2.FileVersionsResponse.fromBuffer(value));
  static final _$restoreFile =
      $grpc.ClientMethod<$2.RestoreFileRequest, $1.Status>(
          '/aether.api.FileService/RestoreFile',
          ($2.RestoreFileRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $1.Status.fromBuffer(value));

  FileServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$2.FileResponse> getFile($2.GetFileRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFile, request, options: options);
  }

  $grpc.ResponseFuture<$2.ListFilesResponse> listFiles(
      $2.ListFilesRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listFiles, request, options: options);
  }

  $grpc.ResponseFuture<$2.FileInfoResponse> getFileInfo(
      $2.GetFileInfoRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFileInfo, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> deleteFile($2.DeleteFileRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteFile, request, options: options);
  }

  $grpc.ResponseFuture<$2.FileVersionsResponse> getFileVersions(
      $2.GetFileVersionsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFileVersions, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> restoreFile($2.RestoreFileRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$restoreFile, request, options: options);
  }
}

abstract class FileServiceBase extends $grpc.Service {
  $core.String get $name => 'aether.api.FileService';

  FileServiceBase() {
    $addMethod($grpc.ServiceMethod<$2.GetFileRequest, $2.FileResponse>(
        'GetFile',
        getFile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.GetFileRequest.fromBuffer(value),
        ($2.FileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.ListFilesRequest, $2.ListFilesResponse>(
        'ListFiles',
        listFiles_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.ListFilesRequest.fromBuffer(value),
        ($2.ListFilesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.GetFileInfoRequest, $2.FileInfoResponse>(
        'GetFileInfo',
        getFileInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $2.GetFileInfoRequest.fromBuffer(value),
        ($2.FileInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.DeleteFileRequest, $1.Status>(
        'DeleteFile',
        deleteFile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $2.DeleteFileRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$2.GetFileVersionsRequest, $2.FileVersionsResponse>(
            'GetFileVersions',
            getFileVersions_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $2.GetFileVersionsRequest.fromBuffer(value),
            ($2.FileVersionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$2.RestoreFileRequest, $1.Status>(
        'RestoreFile',
        restoreFile_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $2.RestoreFileRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
  }

  $async.Future<$2.FileResponse> getFile_Pre(
      $grpc.ServiceCall call, $async.Future<$2.GetFileRequest> request) async {
    return getFile(call, await request);
  }

  $async.Future<$2.ListFilesResponse> listFiles_Pre($grpc.ServiceCall call,
      $async.Future<$2.ListFilesRequest> request) async {
    return listFiles(call, await request);
  }

  $async.Future<$2.FileInfoResponse> getFileInfo_Pre($grpc.ServiceCall call,
      $async.Future<$2.GetFileInfoRequest> request) async {
    return getFileInfo(call, await request);
  }

  $async.Future<$1.Status> deleteFile_Pre($grpc.ServiceCall call,
      $async.Future<$2.DeleteFileRequest> request) async {
    return deleteFile(call, await request);
  }

  $async.Future<$2.FileVersionsResponse> getFileVersions_Pre(
      $grpc.ServiceCall call,
      $async.Future<$2.GetFileVersionsRequest> request) async {
    return getFileVersions(call, await request);
  }

  $async.Future<$1.Status> restoreFile_Pre($grpc.ServiceCall call,
      $async.Future<$2.RestoreFileRequest> request) async {
    return restoreFile(call, await request);
  }

  $async.Future<$2.FileResponse> getFile(
      $grpc.ServiceCall call, $2.GetFileRequest request);
  $async.Future<$2.ListFilesResponse> listFiles(
      $grpc.ServiceCall call, $2.ListFilesRequest request);
  $async.Future<$2.FileInfoResponse> getFileInfo(
      $grpc.ServiceCall call, $2.GetFileInfoRequest request);
  $async.Future<$1.Status> deleteFile(
      $grpc.ServiceCall call, $2.DeleteFileRequest request);
  $async.Future<$2.FileVersionsResponse> getFileVersions(
      $grpc.ServiceCall call, $2.GetFileVersionsRequest request);
  $async.Future<$1.Status> restoreFile(
      $grpc.ServiceCall call, $2.RestoreFileRequest request);
}
