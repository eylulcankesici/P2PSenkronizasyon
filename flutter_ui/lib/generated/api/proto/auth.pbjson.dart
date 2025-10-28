//
//  Generated code. Do not modify.
//  source: api/proto/auth.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use userDescriptor instead')
const User$json = {
  '1': 'User',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'profile_name', '3': 2, '4': 1, '5': 9, '10': 'profileName'},
    {'1': 'role', '3': 3, '4': 1, '5': 14, '6': '.aether.api.UserRole', '10': 'role'},
    {'1': 'is_active', '3': 4, '4': 1, '5': 8, '10': 'isActive'},
    {'1': 'created_at', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

/// Descriptor for `User`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userDescriptor = $convert.base64Decode(
    'CgRVc2VyEg4KAmlkGAEgASgJUgJpZBIhCgxwcm9maWxlX25hbWUYAiABKAlSC3Byb2ZpbGVOYW'
    '1lEigKBHJvbGUYAyABKA4yFC5hZXRoZXIuYXBpLlVzZXJSb2xlUgRyb2xlEhsKCWlzX2FjdGl2'
    'ZRgEIAEoCFIIaXNBY3RpdmUSOQoKY3JlYXRlZF9hdBgFIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi'
    '5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAYgASgLMhouZ29vZ2xlLnByb3Rv'
    'YnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use registerRequestDescriptor instead')
const RegisterRequest$json = {
  '1': 'RegisterRequest',
  '2': [
    {'1': 'profile_name', '3': 1, '4': 1, '5': 9, '10': 'profileName'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
    {'1': 'role', '3': 3, '4': 1, '5': 14, '6': '.aether.api.UserRole', '10': 'role'},
  ],
};

/// Descriptor for `RegisterRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerRequestDescriptor = $convert.base64Decode(
    'Cg9SZWdpc3RlclJlcXVlc3QSIQoMcHJvZmlsZV9uYW1lGAEgASgJUgtwcm9maWxlTmFtZRIaCg'
    'hwYXNzd29yZBgCIAEoCVIIcGFzc3dvcmQSKAoEcm9sZRgDIAEoDjIULmFldGhlci5hcGkuVXNl'
    'clJvbGVSBHJvbGU=');

@$core.Deprecated('Use registerResponseDescriptor instead')
const RegisterResponse$json = {
  '1': 'RegisterResponse',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    {'1': 'user', '3': 2, '4': 1, '5': 11, '6': '.aether.api.User', '10': 'user'},
  ],
};

/// Descriptor for `RegisterResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List registerResponseDescriptor = $convert.base64Decode(
    'ChBSZWdpc3RlclJlc3BvbnNlEioKBnN0YXR1cxgBIAEoCzISLmFldGhlci5hcGkuU3RhdHVzUg'
    'ZzdGF0dXMSJAoEdXNlchgCIAEoCzIQLmFldGhlci5hcGkuVXNlclIEdXNlcg==');

@$core.Deprecated('Use loginRequestDescriptor instead')
const LoginRequest$json = {
  '1': 'LoginRequest',
  '2': [
    {'1': 'profile_name', '3': 1, '4': 1, '5': 9, '10': 'profileName'},
    {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

/// Descriptor for `LoginRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginRequestDescriptor = $convert.base64Decode(
    'CgxMb2dpblJlcXVlc3QSIQoMcHJvZmlsZV9uYW1lGAEgASgJUgtwcm9maWxlTmFtZRIaCghwYX'
    'Nzd29yZBgCIAEoCVIIcGFzc3dvcmQ=');

@$core.Deprecated('Use loginResponseDescriptor instead')
const LoginResponse$json = {
  '1': 'LoginResponse',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    {'1': 'user', '3': 3, '4': 1, '5': 11, '6': '.aether.api.User', '10': 'user'},
    {'1': 'expires_at', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'expiresAt'},
  ],
};

/// Descriptor for `LoginResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List loginResponseDescriptor = $convert.base64Decode(
    'Cg1Mb2dpblJlc3BvbnNlEioKBnN0YXR1cxgBIAEoCzISLmFldGhlci5hcGkuU3RhdHVzUgZzdG'
    'F0dXMSFAoFdG9rZW4YAiABKAlSBXRva2VuEiQKBHVzZXIYAyABKAsyEC5hZXRoZXIuYXBpLlVz'
    'ZXJSBHVzZXISOQoKZXhwaXJlc19hdBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbX'
    'BSCWV4cGlyZXNBdA==');

@$core.Deprecated('Use logoutRequestDescriptor instead')
const LogoutRequest$json = {
  '1': 'LogoutRequest',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `LogoutRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List logoutRequestDescriptor = $convert.base64Decode(
    'Cg1Mb2dvdXRSZXF1ZXN0EhQKBXRva2VuGAEgASgJUgV0b2tlbg==');

@$core.Deprecated('Use validateTokenRequestDescriptor instead')
const ValidateTokenRequest$json = {
  '1': 'ValidateTokenRequest',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 9, '10': 'token'},
  ],
};

/// Descriptor for `ValidateTokenRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateTokenRequestDescriptor = $convert.base64Decode(
    'ChRWYWxpZGF0ZVRva2VuUmVxdWVzdBIUCgV0b2tlbhgBIAEoCVIFdG9rZW4=');

@$core.Deprecated('Use validateTokenResponseDescriptor instead')
const ValidateTokenResponse$json = {
  '1': 'ValidateTokenResponse',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    {'1': 'is_valid', '3': 2, '4': 1, '5': 8, '10': 'isValid'},
    {'1': 'user', '3': 3, '4': 1, '5': 11, '6': '.aether.api.User', '10': 'user'},
  ],
};

/// Descriptor for `ValidateTokenResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List validateTokenResponseDescriptor = $convert.base64Decode(
    'ChVWYWxpZGF0ZVRva2VuUmVzcG9uc2USKgoGc3RhdHVzGAEgASgLMhIuYWV0aGVyLmFwaS5TdG'
    'F0dXNSBnN0YXR1cxIZCghpc192YWxpZBgCIAEoCFIHaXNWYWxpZBIkCgR1c2VyGAMgASgLMhAu'
    'YWV0aGVyLmFwaS5Vc2VyUgR1c2Vy');

@$core.Deprecated('Use changePasswordRequestDescriptor instead')
const ChangePasswordRequest$json = {
  '1': 'ChangePasswordRequest',
  '2': [
    {'1': 'user_id', '3': 1, '4': 1, '5': 9, '10': 'userId'},
    {'1': 'old_password', '3': 2, '4': 1, '5': 9, '10': 'oldPassword'},
    {'1': 'new_password', '3': 3, '4': 1, '5': 9, '10': 'newPassword'},
  ],
};

/// Descriptor for `ChangePasswordRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List changePasswordRequestDescriptor = $convert.base64Decode(
    'ChVDaGFuZ2VQYXNzd29yZFJlcXVlc3QSFwoHdXNlcl9pZBgBIAEoCVIGdXNlcklkEiEKDG9sZF'
    '9wYXNzd29yZBgCIAEoCVILb2xkUGFzc3dvcmQSIQoMbmV3X3Bhc3N3b3JkGAMgASgJUgtuZXdQ'
    'YXNzd29yZA==');

