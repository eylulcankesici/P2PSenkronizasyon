//
//  Generated code. Do not modify.
//  source: api/proto/auth.proto
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

import 'auth.pb.dart' as $0;
import 'common.pb.dart' as $1;

export 'auth.pb.dart';

@$pb.GrpcServiceName('aether.api.AuthService')
class AuthServiceClient extends $grpc.Client {
  static final _$register = $grpc.ClientMethod<$0.RegisterRequest, $0.RegisterResponse>(
      '/aether.api.AuthService/Register',
      ($0.RegisterRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.RegisterResponse.fromBuffer(value));
  static final _$login = $grpc.ClientMethod<$0.LoginRequest, $0.LoginResponse>(
      '/aether.api.AuthService/Login',
      ($0.LoginRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.LoginResponse.fromBuffer(value));
  static final _$logout = $grpc.ClientMethod<$0.LogoutRequest, $1.Status>(
      '/aether.api.AuthService/Logout',
      ($0.LogoutRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Status.fromBuffer(value));
  static final _$validateToken = $grpc.ClientMethod<$0.ValidateTokenRequest, $0.ValidateTokenResponse>(
      '/aether.api.AuthService/ValidateToken',
      ($0.ValidateTokenRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ValidateTokenResponse.fromBuffer(value));
  static final _$changePassword = $grpc.ClientMethod<$0.ChangePasswordRequest, $1.Status>(
      '/aether.api.AuthService/ChangePassword',
      ($0.ChangePasswordRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $1.Status.fromBuffer(value));

  AuthServiceClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.RegisterResponse> register($0.RegisterRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$register, request, options: options);
  }

  $grpc.ResponseFuture<$0.LoginResponse> login($0.LoginRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$login, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> logout($0.LogoutRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$logout, request, options: options);
  }

  $grpc.ResponseFuture<$0.ValidateTokenResponse> validateToken($0.ValidateTokenRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$validateToken, request, options: options);
  }

  $grpc.ResponseFuture<$1.Status> changePassword($0.ChangePasswordRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$changePassword, request, options: options);
  }
}

@$pb.GrpcServiceName('aether.api.AuthService')
abstract class AuthServiceBase extends $grpc.Service {
  $core.String get $name => 'aether.api.AuthService';

  AuthServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.RegisterRequest, $0.RegisterResponse>(
        'Register',
        register_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.RegisterRequest.fromBuffer(value),
        ($0.RegisterResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LoginRequest, $0.LoginResponse>(
        'Login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LoginRequest.fromBuffer(value),
        ($0.LoginResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.LogoutRequest, $1.Status>(
        'Logout',
        logout_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.LogoutRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ValidateTokenRequest, $0.ValidateTokenResponse>(
        'ValidateToken',
        validateToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ValidateTokenRequest.fromBuffer(value),
        ($0.ValidateTokenResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ChangePasswordRequest, $1.Status>(
        'ChangePassword',
        changePassword_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ChangePasswordRequest.fromBuffer(value),
        ($1.Status value) => value.writeToBuffer()));
  }

  $async.Future<$0.RegisterResponse> register_Pre($grpc.ServiceCall call, $async.Future<$0.RegisterRequest> request) async {
    return register(call, await request);
  }

  $async.Future<$0.LoginResponse> login_Pre($grpc.ServiceCall call, $async.Future<$0.LoginRequest> request) async {
    return login(call, await request);
  }

  $async.Future<$1.Status> logout_Pre($grpc.ServiceCall call, $async.Future<$0.LogoutRequest> request) async {
    return logout(call, await request);
  }

  $async.Future<$0.ValidateTokenResponse> validateToken_Pre($grpc.ServiceCall call, $async.Future<$0.ValidateTokenRequest> request) async {
    return validateToken(call, await request);
  }

  $async.Future<$1.Status> changePassword_Pre($grpc.ServiceCall call, $async.Future<$0.ChangePasswordRequest> request) async {
    return changePassword(call, await request);
  }

  $async.Future<$0.RegisterResponse> register($grpc.ServiceCall call, $0.RegisterRequest request);
  $async.Future<$0.LoginResponse> login($grpc.ServiceCall call, $0.LoginRequest request);
  $async.Future<$1.Status> logout($grpc.ServiceCall call, $0.LogoutRequest request);
  $async.Future<$0.ValidateTokenResponse> validateToken($grpc.ServiceCall call, $0.ValidateTokenRequest request);
  $async.Future<$1.Status> changePassword($grpc.ServiceCall call, $0.ChangePasswordRequest request);
}
