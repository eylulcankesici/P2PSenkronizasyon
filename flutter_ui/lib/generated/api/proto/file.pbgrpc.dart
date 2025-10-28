//
//  Generated code. Do not modify.
//  source: api/proto/file.proto
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
import 'file.pb.dart' as $3;

export 'file.pb.dart';

@$pb.GrpcServiceName('aether.api.FileService')
class FileServiceClient extends $grpc.Client {
  static final _$getFile = $grpc.ClientMethod<$3.GetFileRequest, $3.FileResponse>(
      '/aether.api.FileService/GetFile',
      ($3.GetFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.FileResponse.fromBuffer(value));
  static final _$listFiles = $grpc.ClientMethod<$3.ListFilesRequest, $3.ListFilesResponse>(
      '/aether.api.FileService/ListFiles',
      ($3.ListFilesRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.ListFilesResponse.fromBuffer(value));
  static final _$getFileInfo = $grpc.ClientMethod<$3.GetFileInfoRequest, $3.FileInfoResponse>(
      '/aether.api.FileService/GetFileInfo',
      ($3.GetFileInfoRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.FileInfoResponse.fromBuffer(value));
  static final _$deleteFile = $grpc.ClientMethod<$3.DeleteFileRequest, $1.Status>(
      '/aether.api.FileService/DeleteFile',
      ($3.DeleteFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Status.fromBuffer(value));
  static final _$getFileVersions = $grpc.ClientMethod<$3.GetFileVersionsRequest, $3.FileVersionsResponse>(
      '/aether.api.FileService/GetFileVersions',
      ($3.GetFileVersionsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $3.FileVersionsResponse.fromBuffer(value));
  static final _$restoreFile = $grpc.ClientMethod<$3.RestoreFileRequest, $1.Status>(
      '/aether.api.FileService/RestoreFile',
      ($3.RestoreFileRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Status.fromBuffer(value));

  FileServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$3.FileResponse> getFile($3.GetFileRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFile, request, options: options);
  }

  $grpc.ResponseFuture<$3.ListFilesResponse> listFiles($3.ListFilesRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$listFiles, request, options: options);
  }

  $grpc.ResponseFuture<$3.FileInfoResponse> getFileInfo($3.GetFileInfoRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFileInfo, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> deleteFile($3.DeleteFileRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$deleteFile, request, options: options);
  }

  $grpc.ResponseFuture<$3.FileVersionsResponse> getFileVersions($3.GetFileVersionsRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getFileVersions, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> restoreFile($3.RestoreFileRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$restoreFile, request, options: options);
  }
}

@$pb.GrpcServiceName('aether.api.FileService')
abstract class FileServiceBase extends $grpc.Service {
  $core.String get $name => 'aether.api.FileService';

  FileServiceBase() {
    $addMethod($grpc.ServiceMethod<$3.GetFileRequest, $3.FileResponse>(
        'GetFile',
        getFile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.GetFileRequest.fromBuffer(value),
        ($3.FileResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.ListFilesRequest, $3.ListFilesResponse>(
        'ListFiles',
        listFiles_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.ListFilesRequest.fromBuffer(value),
        ($3.ListFilesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.GetFileInfoRequest, $3.FileInfoResponse>(
        'GetFileInfo',
        getFileInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.GetFileInfoRequest.fromBuffer(value),
        ($3.FileInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.DeleteFileRequest, $1.Status>(
        'DeleteFile',
        deleteFile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.DeleteFileRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.GetFileVersionsRequest, $3.FileVersionsResponse>(
        'GetFileVersions',
        getFileVersions_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.GetFileVersionsRequest.fromBuffer(value),
        ($3.FileVersionsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$3.RestoreFileRequest, $1.Status>(
        'RestoreFile',
        restoreFile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $3.RestoreFileRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
  }

  $async.Future<$3.FileResponse> getFile_Pre($grpc.ServiceCall call, $async.Future<$3.GetFileRequest> request) async {
    return getFile(call, await request);
  }

  $async.Future<$3.ListFilesResponse> listFiles_Pre($grpc.ServiceCall call, $async.Future<$3.ListFilesRequest> request) async {
    return listFiles(call, await request);
  }

  $async.Future<$3.FileInfoResponse> getFileInfo_Pre($grpc.ServiceCall call, $async.Future<$3.GetFileInfoRequest> request) async {
    return getFileInfo(call, await request);
  }

  $async.Future<$1.Status> deleteFile_Pre($grpc.ServiceCall call, $async.Future<$3.DeleteFileRequest> request) async {
    return deleteFile(call, await request);
  }

  $async.Future<$3.FileVersionsResponse> getFileVersions_Pre($grpc.ServiceCall call, $async.Future<$3.GetFileVersionsRequest> request) async {
    return getFileVersions(call, await request);
  }

  $async.Future<$1.Status> restoreFile_Pre($grpc.ServiceCall call, $async.Future<$3.RestoreFileRequest> request) async {
    return restoreFile(call, await request);
  }

  $async.Future<$3.FileResponse> getFile($grpc.ServiceCall call, $3.GetFileRequest request);
  $async.Future<$3.ListFilesResponse> listFiles($grpc.ServiceCall call, $3.ListFilesRequest request);
  $async.Future<$3.FileInfoResponse> getFileInfo($grpc.ServiceCall call, $3.GetFileInfoRequest request);
  $async.Future<$1.Status> deleteFile($grpc.ServiceCall call, $3.DeleteFileRequest request);
  $async.Future<$3.FileVersionsResponse> getFileVersions($grpc.ServiceCall call, $3.GetFileVersionsRequest request);
  $async.Future<$1.Status> restoreFile($grpc.ServiceCall call, $3.RestoreFileRequest request);
}
