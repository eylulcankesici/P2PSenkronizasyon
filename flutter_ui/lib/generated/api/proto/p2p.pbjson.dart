///
//  Generated code. Do not modify.
//  source: api/proto/p2p.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use chunkRequestDescriptor instead')
const ChunkRequest$json = const {
  '1': 'ChunkRequest',
  '2': const [
    const {'1': 'chunk_hash', '3': 1, '4': 1, '5': 9, '10': 'chunkHash'},
    const {'1': 'file_id', '3': 2, '4': 1, '5': 9, '10': 'fileId'},
    const {'1': 'requester_device_id', '3': 3, '4': 1, '5': 9, '10': 'requesterDeviceId'},
  ],
};

/// Descriptor for `ChunkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chunkRequestDescriptor = $convert.base64Decode('CgxDaHVua1JlcXVlc3QSHQoKY2h1bmtfaGFzaBgBIAEoCVIJY2h1bmtIYXNoEhcKB2ZpbGVfaWQYAiABKAlSBmZpbGVJZBIuChNyZXF1ZXN0ZXJfZGV2aWNlX2lkGAMgASgJUhFyZXF1ZXN0ZXJEZXZpY2VJZA==');
@$core.Deprecated('Use chunkResponseDescriptor instead')
const ChunkResponse$json = const {
  '1': 'ChunkResponse',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    const {'1': 'chunk_data', '3': 2, '4': 1, '5': 12, '10': 'chunkData'},
    const {'1': 'chunk_hash', '3': 3, '4': 1, '5': 9, '10': 'chunkHash'},
    const {'1': 'chunk_size', '3': 4, '4': 1, '5': 3, '10': 'chunkSize'},
  ],
};

/// Descriptor for `ChunkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chunkResponseDescriptor = $convert.base64Decode('Cg1DaHVua1Jlc3BvbnNlEioKBnN0YXR1cxgBIAEoCzISLmFldGhlci5hcGkuU3RhdHVzUgZzdGF0dXMSHQoKY2h1bmtfZGF0YRgCIAEoDFIJY2h1bmtEYXRhEh0KCmNodW5rX2hhc2gYAyABKAlSCWNodW5rSGFzaBIdCgpjaHVua19zaXplGAQgASgDUgljaHVua1NpemU=');
@$core.Deprecated('Use chunkDataDescriptor instead')
const ChunkData$json = const {
  '1': 'ChunkData',
  '2': const [
    const {'1': 'chunk_hash', '3': 1, '4': 1, '5': 9, '10': 'chunkHash'},
    const {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
    const {'1': 'offset', '3': 3, '4': 1, '5': 3, '10': 'offset'},
    const {'1': 'total_size', '3': 4, '4': 1, '5': 3, '10': 'totalSize'},
    const {'1': 'is_final', '3': 5, '4': 1, '5': 8, '10': 'isFinal'},
  ],
};

/// Descriptor for `ChunkData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chunkDataDescriptor = $convert.base64Decode('CglDaHVua0RhdGESHQoKY2h1bmtfaGFzaBgBIAEoCVIJY2h1bmtIYXNoEhIKBGRhdGEYAiABKAxSBGRhdGESFgoGb2Zmc2V0GAMgASgDUgZvZmZzZXQSHQoKdG90YWxfc2l6ZRgEIAEoA1IJdG90YWxTaXplEhkKCGlzX2ZpbmFsGAUgASgIUgdpc0ZpbmFs');
@$core.Deprecated('Use transferStatusDescriptor instead')
const TransferStatus$json = const {
  '1': 'TransferStatus',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    const {'1': 'bytes_received', '3': 2, '4': 1, '5': 3, '10': 'bytesReceived'},
    const {'1': 'received_hash', '3': 3, '4': 1, '5': 9, '10': 'receivedHash'},
  ],
};

/// Descriptor for `TransferStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List transferStatusDescriptor = $convert.base64Decode('Cg5UcmFuc2ZlclN0YXR1cxIqCgZzdGF0dXMYASABKAsyEi5hZXRoZXIuYXBpLlN0YXR1c1IGc3RhdHVzEiUKDmJ5dGVzX3JlY2VpdmVkGAIgASgDUg1ieXRlc1JlY2VpdmVkEiMKDXJlY2VpdmVkX2hhc2gYAyABKAlSDHJlY2VpdmVkSGFzaA==');
@$core.Deprecated('Use fileMetadataRequestDescriptor instead')
const FileMetadataRequest$json = const {
  '1': 'FileMetadataRequest',
  '2': const [
    const {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
    const {'1': 'sender_device_id', '3': 2, '4': 1, '5': 9, '10': 'senderDeviceId'},
  ],
};

/// Descriptor for `FileMetadataRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileMetadataRequestDescriptor = $convert.base64Decode('ChNGaWxlTWV0YWRhdGFSZXF1ZXN0EhcKB2ZpbGVfaWQYASABKAlSBmZpbGVJZBIoChBzZW5kZXJfZGV2aWNlX2lkGAIgASgJUg5zZW5kZXJEZXZpY2VJZA==');
@$core.Deprecated('Use fileMetadataResponseDescriptor instead')
const FileMetadataResponse$json = const {
  '1': 'FileMetadataResponse',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    const {'1': 'file_id', '3': 2, '4': 1, '5': 9, '10': 'fileId'},
    const {'1': 'relative_path', '3': 3, '4': 1, '5': 9, '10': 'relativePath'},
    const {'1': 'size', '3': 4, '4': 1, '5': 3, '10': 'size'},
    const {'1': 'global_hash', '3': 5, '4': 1, '5': 9, '10': 'globalHash'},
    const {'1': 'chunk_hashes', '3': 6, '4': 3, '5': 9, '10': 'chunkHashes'},
  ],
};

/// Descriptor for `FileMetadataResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileMetadataResponseDescriptor = $convert.base64Decode('ChRGaWxlTWV0YWRhdGFSZXNwb25zZRIqCgZzdGF0dXMYASABKAsyEi5hZXRoZXIuYXBpLlN0YXR1c1IGc3RhdHVzEhcKB2ZpbGVfaWQYAiABKAlSBmZpbGVJZBIjCg1yZWxhdGl2ZV9wYXRoGAMgASgJUgxyZWxhdGl2ZVBhdGgSEgoEc2l6ZRgEIAEoA1IEc2l6ZRIfCgtnbG9iYWxfaGFzaBgFIAEoCVIKZ2xvYmFsSGFzaBIhCgxjaHVua19oYXNoZXMYBiADKAlSC2NodW5rSGFzaGVz');
@$core.Deprecated('Use pingRequestDescriptor instead')
const PingRequest$json = const {
  '1': 'PingRequest',
  '2': const [
    const {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'timestamp', '3': 2, '4': 1, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `PingRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingRequestDescriptor = $convert.base64Decode('CgtQaW5nUmVxdWVzdBIbCglkZXZpY2VfaWQYASABKAlSCGRldmljZUlkEhwKCXRpbWVzdGFtcBgCIAEoA1IJdGltZXN0YW1w');
@$core.Deprecated('Use pingResponseDescriptor instead')
const PingResponse$json = const {
  '1': 'PingResponse',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    const {'1': 'timestamp', '3': 2, '4': 1, '5': 3, '10': 'timestamp'},
    const {'1': 'latency_ms', '3': 3, '4': 1, '5': 3, '10': 'latencyMs'},
  ],
};

/// Descriptor for `PingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingResponseDescriptor = $convert.base64Decode('CgxQaW5nUmVzcG9uc2USKgoGc3RhdHVzGAEgASgLMhIuYWV0aGVyLmFwaS5TdGF0dXNSBnN0YXR1cxIcCgl0aW1lc3RhbXAYAiABKANSCXRpbWVzdGFtcBIdCgpsYXRlbmN5X21zGAMgASgDUglsYXRlbmN5TXM=');
