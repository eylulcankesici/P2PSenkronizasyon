// This is a generated file - do not edit.
//
// Generated from api/proto/chunk.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use chunkInfoDescriptor instead')
const ChunkInfo$json = {
  '1': 'ChunkInfo',
  '2': [
    {'1': 'hash', '3': 1, '4': 1, '5': 9, '10': 'hash'},
    {'1': 'size', '3': 2, '4': 1, '5': 3, '10': 'size'},
    {
      '1': 'creation_time',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'creationTime'
    },
    {'1': 'is_local', '3': 4, '4': 1, '5': 8, '10': 'isLocal'},
    {'1': 'reference_count', '3': 5, '4': 1, '5': 5, '10': 'referenceCount'},
  ],
};

/// Descriptor for `ChunkInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chunkInfoDescriptor = $convert.base64Decode(
    'CglDaHVua0luZm8SEgoEaGFzaBgBIAEoCVIEaGFzaBISCgRzaXplGAIgASgDUgRzaXplEj8KDW'
    'NyZWF0aW9uX3RpbWUYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgxjcmVhdGlv'
    'blRpbWUSGQoIaXNfbG9jYWwYBCABKAhSB2lzTG9jYWwSJwoPcmVmZXJlbmNlX2NvdW50GAUgAS'
    'gFUg5yZWZlcmVuY2VDb3VudA==');

@$core.Deprecated('Use fileChunkInfoDescriptor instead')
const FileChunkInfo$json = {
  '1': 'FileChunkInfo',
  '2': [
    {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
    {'1': 'chunk_hash', '3': 2, '4': 1, '5': 9, '10': 'chunkHash'},
    {'1': 'chunk_index', '3': 3, '4': 1, '5': 5, '10': 'chunkIndex'},
  ],
};

/// Descriptor for `FileChunkInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileChunkInfoDescriptor = $convert.base64Decode(
    'Cg1GaWxlQ2h1bmtJbmZvEhcKB2ZpbGVfaWQYASABKAlSBmZpbGVJZBIdCgpjaHVua19oYXNoGA'
    'IgASgJUgljaHVua0hhc2gSHwoLY2h1bmtfaW5kZXgYAyABKAVSCmNodW5rSW5kZXg=');

@$core.Deprecated('Use chunkFileRequestDescriptor instead')
const ChunkFileRequest$json = {
  '1': 'ChunkFileRequest',
  '2': [
    {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
    {'1': 'file_path', '3': 2, '4': 1, '5': 9, '10': 'filePath'},
    {'1': 'folder_id', '3': 3, '4': 1, '5': 9, '10': 'folderId'},
  ],
};

/// Descriptor for `ChunkFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chunkFileRequestDescriptor = $convert.base64Decode(
    'ChBDaHVua0ZpbGVSZXF1ZXN0EhcKB2ZpbGVfaWQYASABKAlSBmZpbGVJZBIbCglmaWxlX3BhdG'
    'gYAiABKAlSCGZpbGVQYXRoEhsKCWZvbGRlcl9pZBgDIAEoCVIIZm9sZGVySWQ=');

@$core.Deprecated('Use chunkFileResponseDescriptor instead')
const ChunkFileResponse$json = {
  '1': 'ChunkFileResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.aether.api.Status',
      '10': 'status'
    },
    {'1': 'global_hash', '3': 2, '4': 1, '5': 9, '10': 'globalHash'},
    {'1': 'chunk_count', '3': 3, '4': 1, '5': 5, '10': 'chunkCount'},
    {'1': 'total_size', '3': 4, '4': 1, '5': 3, '10': 'totalSize'},
    {
      '1': 'chunks',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.aether.api.ChunkInfo',
      '10': 'chunks'
    },
  ],
};

/// Descriptor for `ChunkFileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chunkFileResponseDescriptor = $convert.base64Decode(
    'ChFDaHVua0ZpbGVSZXNwb25zZRIqCgZzdGF0dXMYASABKAsyEi5hZXRoZXIuYXBpLlN0YXR1c1'
    'IGc3RhdHVzEh8KC2dsb2JhbF9oYXNoGAIgASgJUgpnbG9iYWxIYXNoEh8KC2NodW5rX2NvdW50'
    'GAMgASgFUgpjaHVua0NvdW50Eh0KCnRvdGFsX3NpemUYBCABKANSCXRvdGFsU2l6ZRItCgZjaH'
    'Vua3MYBSADKAsyFS5hZXRoZXIuYXBpLkNodW5rSW5mb1IGY2h1bmtz');

@$core.Deprecated('Use getFileChunksRequestDescriptor instead')
const GetFileChunksRequest$json = {
  '1': 'GetFileChunksRequest',
  '2': [
    {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
  ],
};

/// Descriptor for `GetFileChunksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFileChunksRequestDescriptor =
    $convert.base64Decode(
        'ChRHZXRGaWxlQ2h1bmtzUmVxdWVzdBIXCgdmaWxlX2lkGAEgASgJUgZmaWxlSWQ=');

@$core.Deprecated('Use getFileChunksResponseDescriptor instead')
const GetFileChunksResponse$json = {
  '1': 'GetFileChunksResponse',
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
      '1': 'chunks',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.aether.api.ChunkInfo',
      '10': 'chunks'
    },
    {
      '1': 'file_chunks',
      '3': 3,
      '4': 3,
      '5': 11,
      '6': '.aether.api.FileChunkInfo',
      '10': 'fileChunks'
    },
  ],
};

/// Descriptor for `GetFileChunksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFileChunksResponseDescriptor = $convert.base64Decode(
    'ChVHZXRGaWxlQ2h1bmtzUmVzcG9uc2USKgoGc3RhdHVzGAEgASgLMhIuYWV0aGVyLmFwaS5TdG'
    'F0dXNSBnN0YXR1cxItCgZjaHVua3MYAiADKAsyFS5hZXRoZXIuYXBpLkNodW5rSW5mb1IGY2h1'
    'bmtzEjoKC2ZpbGVfY2h1bmtzGAMgAygLMhkuYWV0aGVyLmFwaS5GaWxlQ2h1bmtJbmZvUgpmaW'
    'xlQ2h1bmtz');

@$core.Deprecated('Use downloadChunkRequestDescriptor instead')
const DownloadChunkRequest$json = {
  '1': 'DownloadChunkRequest',
  '2': [
    {'1': 'chunk_hash', '3': 1, '4': 1, '5': 9, '10': 'chunkHash'},
  ],
};

/// Descriptor for `DownloadChunkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List downloadChunkRequestDescriptor = $convert.base64Decode(
    'ChREb3dubG9hZENodW5rUmVxdWVzdBIdCgpjaHVua19oYXNoGAEgASgJUgljaHVua0hhc2g=');

@$core.Deprecated('Use chunkDataResponseDescriptor instead')
const ChunkDataResponse$json = {
  '1': 'ChunkDataResponse',
  '2': [
    {'1': 'data', '3': 1, '4': 1, '5': 12, '10': 'data'},
    {'1': 'offset', '3': 2, '4': 1, '5': 5, '10': 'offset'},
    {'1': 'total_size', '3': 3, '4': 1, '5': 5, '10': 'totalSize'},
  ],
};

/// Descriptor for `ChunkDataResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chunkDataResponseDescriptor = $convert.base64Decode(
    'ChFDaHVua0RhdGFSZXNwb25zZRISCgRkYXRhGAEgASgMUgRkYXRhEhYKBm9mZnNldBgCIAEoBV'
    'IGb2Zmc2V0Eh0KCnRvdGFsX3NpemUYAyABKAVSCXRvdGFsU2l6ZQ==');

@$core.Deprecated('Use uploadChunkRequestDescriptor instead')
const UploadChunkRequest$json = {
  '1': 'UploadChunkRequest',
  '2': [
    {'1': 'chunk_hash', '3': 1, '4': 1, '5': 9, '10': 'chunkHash'},
    {'1': 'data', '3': 2, '4': 1, '5': 12, '10': 'data'},
    {'1': 'offset', '3': 3, '4': 1, '5': 5, '10': 'offset'},
    {'1': 'total_size', '3': 4, '4': 1, '5': 3, '10': 'totalSize'},
  ],
};

/// Descriptor for `UploadChunkRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadChunkRequestDescriptor = $convert.base64Decode(
    'ChJVcGxvYWRDaHVua1JlcXVlc3QSHQoKY2h1bmtfaGFzaBgBIAEoCVIJY2h1bmtIYXNoEhIKBG'
    'RhdGEYAiABKAxSBGRhdGESFgoGb2Zmc2V0GAMgASgFUgZvZmZzZXQSHQoKdG90YWxfc2l6ZRgE'
    'IAEoA1IJdG90YWxTaXpl');

@$core.Deprecated('Use uploadChunkResponseDescriptor instead')
const UploadChunkResponse$json = {
  '1': 'UploadChunkResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.aether.api.Status',
      '10': 'status'
    },
    {'1': 'chunk_hash', '3': 2, '4': 1, '5': 9, '10': 'chunkHash'},
    {'1': 'was_duplicate', '3': 3, '4': 1, '5': 8, '10': 'wasDuplicate'},
  ],
};

/// Descriptor for `UploadChunkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List uploadChunkResponseDescriptor = $convert.base64Decode(
    'ChNVcGxvYWRDaHVua1Jlc3BvbnNlEioKBnN0YXR1cxgBIAEoCzISLmFldGhlci5hcGkuU3RhdH'
    'VzUgZzdGF0dXMSHQoKY2h1bmtfaGFzaBgCIAEoCVIJY2h1bmtIYXNoEiMKDXdhc19kdXBsaWNh'
    'dGUYAyABKAhSDHdhc0R1cGxpY2F0ZQ==');

@$core.Deprecated('Use verifyFileIntegrityRequestDescriptor instead')
const VerifyFileIntegrityRequest$json = {
  '1': 'VerifyFileIntegrityRequest',
  '2': [
    {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
    {
      '1': 'expected_global_hash',
      '3': 2,
      '4': 1,
      '5': 9,
      '10': 'expectedGlobalHash'
    },
  ],
};

/// Descriptor for `VerifyFileIntegrityRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyFileIntegrityRequestDescriptor =
    $convert.base64Decode(
        'ChpWZXJpZnlGaWxlSW50ZWdyaXR5UmVxdWVzdBIXCgdmaWxlX2lkGAEgASgJUgZmaWxlSWQSMA'
        'oUZXhwZWN0ZWRfZ2xvYmFsX2hhc2gYAiABKAlSEmV4cGVjdGVkR2xvYmFsSGFzaA==');

@$core.Deprecated('Use verifyFileIntegrityResponseDescriptor instead')
const VerifyFileIntegrityResponse$json = {
  '1': 'VerifyFileIntegrityResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.aether.api.Status',
      '10': 'status'
    },
    {'1': 'is_valid', '3': 2, '4': 1, '5': 8, '10': 'isValid'},
    {
      '1': 'actual_global_hash',
      '3': 3,
      '4': 1,
      '5': 9,
      '10': 'actualGlobalHash'
    },
    {'1': 'corrupted_chunks', '3': 4, '4': 3, '5': 9, '10': 'corruptedChunks'},
  ],
};

/// Descriptor for `VerifyFileIntegrityResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verifyFileIntegrityResponseDescriptor = $convert.base64Decode(
    'ChtWZXJpZnlGaWxlSW50ZWdyaXR5UmVzcG9uc2USKgoGc3RhdHVzGAEgASgLMhIuYWV0aGVyLm'
    'FwaS5TdGF0dXNSBnN0YXR1cxIZCghpc192YWxpZBgCIAEoCFIHaXNWYWxpZBIsChJhY3R1YWxf'
    'Z2xvYmFsX2hhc2gYAyABKAlSEGFjdHVhbEdsb2JhbEhhc2gSKQoQY29ycnVwdGVkX2NodW5rcx'
    'gEIAMoCVIPY29ycnVwdGVkQ2h1bmtz');

@$core.Deprecated('Use getDeduplicationStatsRequestDescriptor instead')
const GetDeduplicationStatsRequest$json = {
  '1': 'GetDeduplicationStatsRequest',
};

/// Descriptor for `GetDeduplicationStatsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDeduplicationStatsRequestDescriptor =
    $convert.base64Decode('ChxHZXREZWR1cGxpY2F0aW9uU3RhdHNSZXF1ZXN0');

@$core.Deprecated('Use getDeduplicationStatsResponseDescriptor instead')
const GetDeduplicationStatsResponse$json = {
  '1': 'GetDeduplicationStatsResponse',
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
      '1': 'total_chunk_references',
      '3': 2,
      '4': 1,
      '5': 3,
      '10': 'totalChunkReferences'
    },
    {'1': 'unique_chunks', '3': 3, '4': 1, '5': 3, '10': 'uniqueChunks'},
    {'1': 'savings_bytes', '3': 4, '4': 1, '5': 3, '10': 'savingsBytes'},
    {
      '1': 'deduplication_ratio',
      '3': 5,
      '4': 1,
      '5': 2,
      '10': 'deduplicationRatio'
    },
    {'1': 'disk_usage_bytes', '3': 6, '4': 1, '5': 3, '10': 'diskUsageBytes'},
  ],
};

/// Descriptor for `GetDeduplicationStatsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getDeduplicationStatsResponseDescriptor = $convert.base64Decode(
    'Ch1HZXREZWR1cGxpY2F0aW9uU3RhdHNSZXNwb25zZRIqCgZzdGF0dXMYASABKAsyEi5hZXRoZX'
    'IuYXBpLlN0YXR1c1IGc3RhdHVzEjQKFnRvdGFsX2NodW5rX3JlZmVyZW5jZXMYAiABKANSFHRv'
    'dGFsQ2h1bmtSZWZlcmVuY2VzEiMKDXVuaXF1ZV9jaHVua3MYAyABKANSDHVuaXF1ZUNodW5rcx'
    'IjCg1zYXZpbmdzX2J5dGVzGAQgASgDUgxzYXZpbmdzQnl0ZXMSLwoTZGVkdXBsaWNhdGlvbl9y'
    'YXRpbxgFIAEoAlISZGVkdXBsaWNhdGlvblJhdGlvEigKEGRpc2tfdXNhZ2VfYnl0ZXMYBiABKA'
    'NSDmRpc2tVc2FnZUJ5dGVz');

@$core.Deprecated('Use cleanOrphanChunksRequestDescriptor instead')
const CleanOrphanChunksRequest$json = {
  '1': 'CleanOrphanChunksRequest',
};

/// Descriptor for `CleanOrphanChunksRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cleanOrphanChunksRequestDescriptor =
    $convert.base64Decode('ChhDbGVhbk9ycGhhbkNodW5rc1JlcXVlc3Q=');

@$core.Deprecated('Use cleanOrphanChunksResponseDescriptor instead')
const CleanOrphanChunksResponse$json = {
  '1': 'CleanOrphanChunksResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.aether.api.Status',
      '10': 'status'
    },
    {'1': 'deleted_chunks', '3': 2, '4': 1, '5': 5, '10': 'deletedChunks'},
    {'1': 'freed_bytes', '3': 3, '4': 1, '5': 3, '10': 'freedBytes'},
  ],
};

/// Descriptor for `CleanOrphanChunksResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List cleanOrphanChunksResponseDescriptor = $convert.base64Decode(
    'ChlDbGVhbk9ycGhhbkNodW5rc1Jlc3BvbnNlEioKBnN0YXR1cxgBIAEoCzISLmFldGhlci5hcG'
    'kuU3RhdHVzUgZzdGF0dXMSJQoOZGVsZXRlZF9jaHVua3MYAiABKAVSDWRlbGV0ZWRDaHVua3MS'
    'HwoLZnJlZWRfYnl0ZXMYAyABKANSCmZyZWVkQnl0ZXM=');
