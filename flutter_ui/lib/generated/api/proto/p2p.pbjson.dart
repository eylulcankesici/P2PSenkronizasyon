// This is a generated file - do not edit.
//
// Generated from api/proto/p2p.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use transferDirectionDescriptor instead')
const TransferDirection$json = {
  '1': 'TransferDirection',
  '2': [
    {'1': 'TRANSFER_DIRECTION_UNSPECIFIED', '2': 0},
    {'1': 'TRANSFER_DIRECTION_SEND', '2': 1},
    {'1': 'TRANSFER_DIRECTION_RECEIVE', '2': 2},
  ],
};

/// Descriptor for `TransferDirection`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List transferDirectionDescriptor = $convert.base64Decode(
    'ChFUcmFuc2ZlckRpcmVjdGlvbhIiCh5UUkFOU0ZFUl9ESVJFQ1RJT05fVU5TUEVDSUZJRUQQAB'
    'IbChdUUkFOU0ZFUl9ESVJFQ1RJT05fU0VORBABEh4KGlRSQU5TRkVSX0RJUkVDVElPTl9SRUNF'
    'SVZFEAI=');

@$core.Deprecated('Use transferStateDescriptor instead')
const TransferState$json = {
  '1': 'TransferState',
  '2': [
    {'1': 'TRANSFER_STATE_UNSPECIFIED', '2': 0},
    {'1': 'TRANSFER_STATE_ACTIVE', '2': 1},
    {'1': 'TRANSFER_STATE_COMPLETED', '2': 2},
    {'1': 'TRANSFER_STATE_FAILED', '2': 3},
    {'1': 'TRANSFER_STATE_CANCELLED', '2': 4},
  ],
};

/// Descriptor for `TransferState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List transferStateDescriptor = $convert.base64Decode(
    'Cg1UcmFuc2ZlclN0YXRlEh4KGlRSQU5TRkVSX1NUQVRFX1VOU1BFQ0lGSUVEEAASGQoVVFJBTl'
    'NGRVJfU1RBVEVfQUNUSVZFEAESHAoYVFJBTlNGRVJfU1RBVEVfQ09NUExFVEVEEAISGQoVVFJB'
    'TlNGRVJfU1RBVEVfRkFJTEVEEAMSHAoYVFJBTlNGRVJfU1RBVEVfQ0FOQ0VMTEVEEAQ=');

@$core.Deprecated('Use chunkRequestDescriptor instead')
const ChunkRequest$json = {
  '1': 'ChunkRequest',
  '2': [
    {'1': 'chunk_hash', '3': 1, '4': 1, '5': 9, '10': 'chunkHash'},
    {'1': 'file_id', '3': 2, '4': 1, '5': 9, '10': 'fileId'},
    {
      '1': 'requester_device_id',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'requesterDeviceId'
    },
  ],
};

/// Descriptor for `ChunkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chunkRequestDescriptor = $convert.base64Decode(
    'CgxDaHVua1JlcXVlc3QSHQoKY2h1bmtfaGFzaBgBIAEoCVIJY2h1bmtIYXNoEhcKB2ZpbGVfaW'
    'QYAiABKAlSBmZpbGVJZBIuChNyZXF1ZXN0ZXJfZGV2aWNlX2lkGAMgASgJUhFyZXF1ZXN0ZXJE'
    'ZXZpY2VJZA==');

@$core.Deprecated('Use chunkResponseDescriptor instead')
const ChunkResponse$json = {
  '1': 'ChunkResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.aether.api.Status',
      '10': 'status'
    },
    {'1': 'chunk_data', '3': 2, '4': 1, '5': 12, '10': 'chunkData'},
    {'1': 'chunk_hash', '3': 3, '4': 1, '5': 9, '10': 'chunkHash'},
    {'1': 'chunk_size', '3': 4, '4': 1, '5': 3, '10': 'chunkSize'},
    {'1': 'file_id', '3': 5, '4': 1, '5': 9, '10': 'fileId'},
    {'1': 'chunk_index', '3': 6, '4': 1, '5': 5, '10': 'chunkIndex'},
    {'1': 'total_chunks', '3': 7, '4': 1, '5': 5, '10': 'totalChunks'},
    {'1': 'file_name', '3': 8, '4': 1, '5': 9, '10': 'fileName'},
  ],
};

/// Descriptor for `ChunkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chunkResponseDescriptor = $convert.base64Decode(
    'Cg1DaHVua1Jlc3BvbnNlEioKBnN0YXR1cxgBIAEoCzISLmFldGhlci5hcGkuU3RhdHVzUgZzdG'
    'F0dXMSHQoKY2h1bmtfZGF0YRgCIAEoDFIJY2h1bmtEYXRhEh0KCmNodW5rX2hhc2gYAyABKAlS'
    'CWNodW5rSGFzaBIdCgpjaHVua19zaXplGAQgASgDUgljaHVua1NpemUSFwoHZmlsZV9pZBgFIA'
    'EoCVIGZmlsZUlkEh8KC2NodW5rX2luZGV4GAYgASgFUgpjaHVua0luZGV4EiEKDHRvdGFsX2No'
    'dW5rcxgHIAEoBVILdG90YWxDaHVua3MSGwoJZmlsZV9uYW1lGAggASgJUghmaWxlTmFtZQ==');

@$core.Deprecated('Use chunkDataDescriptor instead')
const ChunkData$json = {
  '1': 'ChunkData',
  '2': [
    {'1': 'chunk_hash', '3': 1, '4': 1, '5': 9, '10': 'chunkHash'},
    {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
    {'1': 'offset', '3': 3, '4': 1, '5': 3, '10': 'offset'},
    {'1': 'total_size', '3': 4, '4': 1, '5': 3, '10': 'totalSize'},
    {'1': 'is_final', '3': 5, '4': 1, '5': 8, '10': 'isFinal'},
  ],
};

/// Descriptor for `ChunkData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chunkDataDescriptor = $convert.base64Decode(
    'CglDaHVua0RhdGESHQoKY2h1bmtfaGFzaBgBIAEoCVIJY2h1bmtIYXNoEhIKBGRhdGEYAiABKA'
    'xSBGRhdGESFgoGb2Zmc2V0GAMgASgDUgZvZmZzZXQSHQoKdG90YWxfc2l6ZRgEIAEoA1IJdG90'
    'YWxTaXplEhkKCGlzX2ZpbmFsGAUgASgIUgdpc0ZpbmFs');

@$core.Deprecated('Use transferStatusDescriptor instead')
const TransferStatus$json = {
  '1': 'TransferStatus',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.aether.api.Status',
      '10': 'status'
    },
    {'1': 'bytes_received', '3': 2, '4': 1, '5': 3, '10': 'bytesReceived'},
    {'1': 'received_hash', '3': 3, '4': 1, '5': 9, '10': 'receivedHash'},
  ],
};

/// Descriptor for `TransferStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferStatusDescriptor = $convert.base64Decode(
    'Cg5UcmFuc2ZlclN0YXR1cxIqCgZzdGF0dXMYASABKAsyEi5hZXRoZXIuYXBpLlN0YXR1c1IGc3'
    'RhdHVzEiUKDmJ5dGVzX3JlY2VpdmVkGAIgASgDUg1ieXRlc1JlY2VpdmVkEiMKDXJlY2VpdmVk'
    'X2hhc2gYAyABKAlSDHJlY2VpdmVkSGFzaA==');

@$core.Deprecated('Use fileMetadataRequestDescriptor instead')
const FileMetadataRequest$json = {
  '1': 'FileMetadataRequest',
  '2': [
    {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
    {'1': 'sender_device_id', '3': 2, '4': 1, '5': 9, '10': 'senderDeviceId'},
  ],
};

/// Descriptor for `FileMetadataRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileMetadataRequestDescriptor = $convert.base64Decode(
    'ChNGaWxlTWV0YWRhdGFSZXF1ZXN0EhcKB2ZpbGVfaWQYASABKAlSBmZpbGVJZBIoChBzZW5kZX'
    'JfZGV2aWNlX2lkGAIgASgJUg5zZW5kZXJEZXZpY2VJZA==');

@$core.Deprecated('Use fileMetadataResponseDescriptor instead')
const FileMetadataResponse$json = {
  '1': 'FileMetadataResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.aether.api.Status',
      '10': 'status'
    },
    {'1': 'file_id', '3': 2, '4': 1, '5': 9, '10': 'fileId'},
    {'1': 'relative_path', '3': 3, '4': 1, '5': 9, '10': 'relativePath'},
    {'1': 'size', '3': 4, '4': 1, '5': 3, '10': 'size'},
    {'1': 'global_hash', '3': 5, '4': 1, '5': 9, '10': 'globalHash'},
    {'1': 'chunk_hashes', '3': 6, '4': 3, '5': 9, '10': 'chunkHashes'},
  ],
};

/// Descriptor for `FileMetadataResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileMetadataResponseDescriptor = $convert.base64Decode(
    'ChRGaWxlTWV0YWRhdGFSZXNwb25zZRIqCgZzdGF0dXMYASABKAsyEi5hZXRoZXIuYXBpLlN0YX'
    'R1c1IGc3RhdHVzEhcKB2ZpbGVfaWQYAiABKAlSBmZpbGVJZBIjCg1yZWxhdGl2ZV9wYXRoGAMg'
    'ASgJUgxyZWxhdGl2ZVBhdGgSEgoEc2l6ZRgEIAEoA1IEc2l6ZRIfCgtnbG9iYWxfaGFzaBgFIA'
    'EoCVIKZ2xvYmFsSGFzaBIhCgxjaHVua19oYXNoZXMYBiADKAlSC2NodW5rSGFzaGVz');

@$core.Deprecated('Use pingRequestDescriptor instead')
const PingRequest$json = {
  '1': 'PingRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'timestamp', '3': 2, '4': 1, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `PingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingRequestDescriptor = $convert.base64Decode(
    'CgtQaW5nUmVxdWVzdBIbCglkZXZpY2VfaWQYASABKAlSCGRldmljZUlkEhwKCXRpbWVzdGFtcB'
    'gCIAEoA1IJdGltZXN0YW1w');

@$core.Deprecated('Use pingResponseDescriptor instead')
const PingResponse$json = {
  '1': 'PingResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.aether.api.Status',
      '10': 'status'
    },
    {'1': 'timestamp', '3': 2, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'latency_ms', '3': 3, '4': 1, '5': 3, '10': 'latencyMs'},
  ],
};

/// Descriptor for `PingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingResponseDescriptor = $convert.base64Decode(
    'CgxQaW5nUmVzcG9uc2USKgoGc3RhdHVzGAEgASgLMhIuYWV0aGVyLmFwaS5TdGF0dXNSBnN0YX'
    'R1cxIcCgl0aW1lc3RhbXAYAiABKANSCXRpbWVzdGFtcBIdCgpsYXRlbmN5X21zGAMgASgDUgls'
    'YXRlbmN5TXM=');

@$core.Deprecated('Use listTransfersRequestDescriptor instead')
const ListTransfersRequest$json = {
  '1': 'ListTransfersRequest',
  '2': [
    {'1': 'active_only', '3': 1, '4': 1, '5': 8, '10': 'activeOnly'},
    {'1': 'completed_only', '3': 2, '4': 1, '5': 8, '10': 'completedOnly'},
    {'1': 'failed_only', '3': 3, '4': 1, '5': 8, '10': 'failedOnly'},
  ],
};

/// Descriptor for `ListTransfersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTransfersRequestDescriptor = $convert.base64Decode(
    'ChRMaXN0VHJhbnNmZXJzUmVxdWVzdBIfCgthY3RpdmVfb25seRgBIAEoCFIKYWN0aXZlT25seR'
    'IlCg5jb21wbGV0ZWRfb25seRgCIAEoCFINY29tcGxldGVkT25seRIfCgtmYWlsZWRfb25seRgD'
    'IAEoCFIKZmFpbGVkT25seQ==');

@$core.Deprecated('Use listTransfersResponseDescriptor instead')
const ListTransfersResponse$json = {
  '1': 'ListTransfersResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.aether.api.Status',
      '10': 'status'
    },
    {
      '1': 'transfers',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.aether.api.TransferInfo',
      '10': 'transfers'
    },
  ],
};

/// Descriptor for `ListTransfersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listTransfersResponseDescriptor = $convert.base64Decode(
    'ChVMaXN0VHJhbnNmZXJzUmVzcG9uc2USKgoGc3RhdHVzGAEgASgLMhIuYWV0aGVyLmFwaS5TdG'
    'F0dXNSBnN0YXR1cxI2Cgl0cmFuc2ZlcnMYAiADKAsyGC5hZXRoZXIuYXBpLlRyYW5zZmVySW5m'
    'b1IJdHJhbnNmZXJz');

@$core.Deprecated('Use getTransferStatusRequestDescriptor instead')
const GetTransferStatusRequest$json = {
  '1': 'GetTransferStatusRequest',
  '2': [
    {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
  ],
};

/// Descriptor for `GetTransferStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTransferStatusRequestDescriptor =
    $convert.base64Decode(
        'ChhHZXRUcmFuc2ZlclN0YXR1c1JlcXVlc3QSFwoHZmlsZV9pZBgBIAEoCVIGZmlsZUlk');

@$core.Deprecated('Use getTransferStatusResponseDescriptor instead')
const GetTransferStatusResponse$json = {
  '1': 'GetTransferStatusResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.aether.api.Status',
      '10': 'status'
    },
    {
      '1': 'transfer',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.aether.api.TransferInfo',
      '10': 'transfer'
    },
  ],
};

/// Descriptor for `GetTransferStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getTransferStatusResponseDescriptor = $convert.base64Decode(
    'ChlHZXRUcmFuc2ZlclN0YXR1c1Jlc3BvbnNlEioKBnN0YXR1cxgBIAEoCzISLmFldGhlci5hcG'
    'kuU3RhdHVzUgZzdGF0dXMSNAoIdHJhbnNmZXIYAiABKAsyGC5hZXRoZXIuYXBpLlRyYW5zZmVy'
    'SW5mb1IIdHJhbnNmZXI=');

@$core.Deprecated('Use cancelTransferRequestDescriptor instead')
const CancelTransferRequest$json = {
  '1': 'CancelTransferRequest',
  '2': [
    {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
  ],
};

/// Descriptor for `CancelTransferRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cancelTransferRequestDescriptor =
    $convert.base64Decode(
        'ChVDYW5jZWxUcmFuc2ZlclJlcXVlc3QSFwoHZmlsZV9pZBgBIAEoCVIGZmlsZUlk');

@$core.Deprecated('Use transferInfoDescriptor instead')
const TransferInfo$json = {
  '1': 'TransferInfo',
  '2': [
    {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
    {'1': 'file_name', '3': 2, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'peer_id', '3': 3, '4': 1, '5': 9, '10': 'peerId'},
    {'1': 'peer_name', '3': 4, '4': 1, '5': 9, '10': 'peerName'},
    {
      '1': 'direction',
      '3': 5,
      '4': 1,
      '5': 14,
      '6': '.aether.api.TransferDirection',
      '10': 'direction'
    },
    {
      '1': 'state',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.aether.api.TransferState',
      '10': 'state'
    },
    {'1': 'total_chunks', '3': 7, '4': 1, '5': 5, '10': 'totalChunks'},
    {'1': 'completed_chunks', '3': 8, '4': 1, '5': 5, '10': 'completedChunks'},
    {'1': 'total_bytes', '3': 9, '4': 1, '5': 3, '10': 'totalBytes'},
    {
      '1': 'transferred_bytes',
      '3': 10,
      '4': 1,
      '5': 3,
      '10': 'transferredBytes'
    },
    {
      '1': 'progress_percentage',
      '3': 11,
      '4': 1,
      '5': 2,
      '10': 'progressPercentage'
    },
    {'1': 'speed_bps', '3': 12, '4': 1, '5': 3, '10': 'speedBps'},
    {
      '1': 'start_time',
      '3': 13,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'startTime'
    },
    {
      '1': 'end_time',
      '3': 14,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'endTime'
    },
    {'1': 'error_message', '3': 15, '4': 1, '5': 9, '10': 'errorMessage'},
  ],
};

/// Descriptor for `TransferInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferInfoDescriptor = $convert.base64Decode(
    'CgxUcmFuc2ZlckluZm8SFwoHZmlsZV9pZBgBIAEoCVIGZmlsZUlkEhsKCWZpbGVfbmFtZRgCIA'
    'EoCVIIZmlsZU5hbWUSFwoHcGVlcl9pZBgDIAEoCVIGcGVlcklkEhsKCXBlZXJfbmFtZRgEIAEo'
    'CVIIcGVlck5hbWUSOwoJZGlyZWN0aW9uGAUgASgOMh0uYWV0aGVyLmFwaS5UcmFuc2ZlckRpcm'
    'VjdGlvblIJZGlyZWN0aW9uEi8KBXN0YXRlGAYgASgOMhkuYWV0aGVyLmFwaS5UcmFuc2ZlclN0'
    'YXRlUgVzdGF0ZRIhCgx0b3RhbF9jaHVua3MYByABKAVSC3RvdGFsQ2h1bmtzEikKEGNvbXBsZX'
    'RlZF9jaHVua3MYCCABKAVSD2NvbXBsZXRlZENodW5rcxIfCgt0b3RhbF9ieXRlcxgJIAEoA1IK'
    'dG90YWxCeXRlcxIrChF0cmFuc2ZlcnJlZF9ieXRlcxgKIAEoA1IQdHJhbnNmZXJyZWRCeXRlcx'
    'IvChNwcm9ncmVzc19wZXJjZW50YWdlGAsgASgCUhJwcm9ncmVzc1BlcmNlbnRhZ2USGwoJc3Bl'
    'ZWRfYnBzGAwgASgDUghzcGVlZEJwcxI5CgpzdGFydF90aW1lGA0gASgLMhouZ29vZ2xlLnByb3'
    'RvYnVmLlRpbWVzdGFtcFIJc3RhcnRUaW1lEjUKCGVuZF90aW1lGA4gASgLMhouZ29vZ2xlLnBy'
    'b3RvYnVmLlRpbWVzdGFtcFIHZW5kVGltZRIjCg1lcnJvcl9tZXNzYWdlGA8gASgJUgxlcnJvck'
    '1lc3NhZ2U=');
