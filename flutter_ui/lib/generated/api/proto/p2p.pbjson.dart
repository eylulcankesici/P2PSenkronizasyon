//
//  Generated code. Do not modify.
//  source: api/proto/p2p.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use chunkRequestDescriptor instead')
const ChunkRequest$json = {
  '1': 'ChunkRequest',
  '2': [
    {'1': 'chunk_hash', '3': 1, '4': 1, '5': 9, '10': 'chunkHash'},
    {'1': 'file_id', '3': 2, '4': 1, '5': 9, '10': 'fileId'},
    {'1': 'requester_device_id', '3': 3, '4': 1, '5': 9, '10': 'requesterDeviceId'},
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
    {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    {'1': 'chunk_data', '3': 2, '4': 1, '5': 12, '10': 'chunkData'},
    {'1': 'chunk_hash', '3': 3, '4': 1, '5': 9, '10': 'chunkHash'},
    {'1': 'chunk_size', '3': 4, '4': 1, '5': 3, '10': 'chunkSize'},
  ],
};

/// Descriptor for `ChunkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chunkResponseDescriptor = $convert.base64Decode(
    'Cg1DaHVua1Jlc3BvbnNlEioKBnN0YXR1cxgBIAEoCzISLmFldGhlci5hcGkuU3RhdHVzUgZzdG'
    'F0dXMSHQoKY2h1bmtfZGF0YRgCIAEoDFIJY2h1bmtEYXRhEh0KCmNodW5rX2hhc2gYAyABKAlS'
    'CWNodW5rSGFzaBIdCgpjaHVua19zaXplGAQgASgDUgljaHVua1NpemU=');

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
    {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
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
    {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
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
    {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    {'1': 'timestamp', '3': 2, '4': 1, '5': 3, '10': 'timestamp'},
    {'1': 'latency_ms', '3': 3, '4': 1, '5': 3, '10': 'latencyMs'},
  ],
};

/// Descriptor for `PingResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pingResponseDescriptor = $convert.base64Decode(
    'CgxQaW5nUmVzcG9uc2USKgoGc3RhdHVzGAEgASgLMhIuYWV0aGVyLmFwaS5TdGF0dXNSBnN0YX'
    'R1cxIcCgl0aW1lc3RhbXAYAiABKANSCXRpbWVzdGFtcBIdCgpsYXRlbmN5X21zGAMgASgDUgls'
    'YXRlbmN5TXM=');

