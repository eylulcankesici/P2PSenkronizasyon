//
//  Generated code. Do not modify.
//  source: api/proto/common.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use syncModeDescriptor instead')
const SyncMode$json = {
  '1': 'SyncMode',
  '2': [
    {'1': 'SYNC_MODE_UNSPECIFIED', '2': 0},
    {'1': 'SYNC_MODE_BIDIRECTIONAL', '2': 1},
    {'1': 'SYNC_MODE_SEND_ONLY', '2': 2},
    {'1': 'SYNC_MODE_RECEIVE_ONLY', '2': 3},
  ],
};

/// Descriptor for `SyncMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List syncModeDescriptor = $convert.base64Decode(
    'CghTeW5jTW9kZRIZChVTWU5DX01PREVfVU5TUEVDSUZJRUQQABIbChdTWU5DX01PREVfQklESV'
    'JFQ1RJT05BTBABEhcKE1NZTkNfTU9ERV9TRU5EX09OTFkQAhIaChZTWU5DX01PREVfUkVDRUlW'
    'RV9PTkxZEAM=');

@$core.Deprecated('Use peerStatusDescriptor instead')
const PeerStatus$json = {
  '1': 'PeerStatus',
  '2': [
    {'1': 'PEER_STATUS_UNKNOWN', '2': 0},
    {'1': 'PEER_STATUS_ONLINE', '2': 1},
    {'1': 'PEER_STATUS_OFFLINE', '2': 2},
    {'1': 'PEER_STATUS_CONNECTING', '2': 3},
  ],
};

/// Descriptor for `PeerStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List peerStatusDescriptor = $convert.base64Decode(
    'CgpQZWVyU3RhdHVzEhcKE1BFRVJfU1RBVFVTX1VOS05PV04QABIWChJQRUVSX1NUQVRVU19PTk'
    'xJTkUQARIXChNQRUVSX1NUQVRVU19PRkZMSU5FEAISGgoWUEVFUl9TVEFUVVNfQ09OTkVDVElO'
    'RxAD');

@$core.Deprecated('Use userRoleDescriptor instead')
const UserRole$json = {
  '1': 'UserRole',
  '2': [
    {'1': 'USER_ROLE_STANDARD', '2': 0},
    {'1': 'USER_ROLE_ADMIN', '2': 1},
  ],
};

/// Descriptor for `UserRole`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List userRoleDescriptor = $convert.base64Decode(
    'CghVc2VyUm9sZRIWChJVU0VSX1JPTEVfU1RBTkRBUkQQABITCg9VU0VSX1JPTEVfQURNSU4QAQ'
    '==');

@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode(
    'CgVFbXB0eQ==');

@$core.Deprecated('Use statusDescriptor instead')
const Status$json = {
  '1': 'Status',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'code', '3': 3, '4': 1, '5': 5, '10': 'code'},
  ],
};

/// Descriptor for `Status`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List statusDescriptor = $convert.base64Decode(
    'CgZTdGF0dXMSGAoHc3VjY2VzcxgBIAEoCFIHc3VjY2VzcxIYCgdtZXNzYWdlGAIgASgJUgdtZX'
    'NzYWdlEhIKBGNvZGUYAyABKAVSBGNvZGU=');

@$core.Deprecated('Use paginationRequestDescriptor instead')
const PaginationRequest$json = {
  '1': 'PaginationRequest',
  '2': [
    {'1': 'page', '3': 1, '4': 1, '5': 5, '10': 'page'},
    {'1': 'page_size', '3': 2, '4': 1, '5': 5, '10': 'pageSize'},
  ],
};

/// Descriptor for `PaginationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paginationRequestDescriptor = $convert.base64Decode(
    'ChFQYWdpbmF0aW9uUmVxdWVzdBISCgRwYWdlGAEgASgFUgRwYWdlEhsKCXBhZ2Vfc2l6ZRgCIA'
    'EoBVIIcGFnZVNpemU=');

@$core.Deprecated('Use paginationResponseDescriptor instead')
const PaginationResponse$json = {
  '1': 'PaginationResponse',
  '2': [
    {'1': 'total_count', '3': 1, '4': 1, '5': 5, '10': 'totalCount'},
    {'1': 'total_pages', '3': 2, '4': 1, '5': 5, '10': 'totalPages'},
    {'1': 'current_page', '3': 3, '4': 1, '5': 5, '10': 'currentPage'},
  ],
};

/// Descriptor for `PaginationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List paginationResponseDescriptor = $convert.base64Decode(
    'ChJQYWdpbmF0aW9uUmVzcG9uc2USHwoLdG90YWxfY291bnQYASABKAVSCnRvdGFsQ291bnQSHw'
    'oLdG90YWxfcGFnZXMYAiABKAVSCnRvdGFsUGFnZXMSIQoMY3VycmVudF9wYWdlGAMgASgFUgtj'
    'dXJyZW50UGFnZQ==');

