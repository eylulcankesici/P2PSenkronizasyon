//
//  Generated code. Do not modify.
//  source: api/proto/file.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use fileDescriptor instead')
const File$json = {
  '1': 'File',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'folder_id', '3': 2, '4': 1, '5': 9, '10': 'folderId'},
    {'1': 'relative_path', '3': 3, '4': 1, '5': 9, '10': 'relativePath'},
    {'1': 'size', '3': 4, '4': 1, '5': 3, '10': 'size'},
    {'1': 'mod_time', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'modTime'},
    {'1': 'global_hash', '3': 6, '4': 1, '5': 9, '10': 'globalHash'},
    {'1': 'chunk_count', '3': 7, '4': 1, '5': 5, '10': 'chunkCount'},
    {'1': 'is_deleted', '3': 8, '4': 1, '5': 8, '10': 'isDeleted'},
    {'1': 'created_at', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 10, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

/// Descriptor for `File`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileDescriptor = $convert.base64Decode(
    'CgRGaWxlEg4KAmlkGAEgASgJUgJpZBIbCglmb2xkZXJfaWQYAiABKAlSCGZvbGRlcklkEiMKDX'
    'JlbGF0aXZlX3BhdGgYAyABKAlSDHJlbGF0aXZlUGF0aBISCgRzaXplGAQgASgDUgRzaXplEjUK'
    'CG1vZF90aW1lGAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHbW9kVGltZRIfCg'
    'tnbG9iYWxfaGFzaBgGIAEoCVIKZ2xvYmFsSGFzaBIfCgtjaHVua19jb3VudBgHIAEoBVIKY2h1'
    'bmtDb3VudBIdCgppc19kZWxldGVkGAggASgIUglpc0RlbGV0ZWQSOQoKY3JlYXRlZF9hdBgJIA'
    'EoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0'
    'GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');

@$core.Deprecated('Use chunkDescriptor instead')
const Chunk$json = {
  '1': 'Chunk',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'file_id', '3': 2, '4': 1, '5': 9, '10': 'fileId'},
    {'1': 'offset', '3': 3, '4': 1, '5': 3, '10': 'offset'},
    {'1': 'length', '3': 4, '4': 1, '5': 3, '10': 'length'},
    {'1': 'device_availability', '3': 5, '4': 3, '5': 9, '10': 'deviceAvailability'},
  ],
};

/// Descriptor for `Chunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chunkDescriptor = $convert.base64Decode(
    'CgVDaHVuaxIOCgJpZBgBIAEoCVICaWQSFwoHZmlsZV9pZBgCIAEoCVIGZmlsZUlkEhYKBm9mZn'
    'NldBgDIAEoA1IGb2Zmc2V0EhYKBmxlbmd0aBgEIAEoA1IGbGVuZ3RoEi8KE2RldmljZV9hdmFp'
    'bGFiaWxpdHkYBSADKAlSEmRldmljZUF2YWlsYWJpbGl0eQ==');

@$core.Deprecated('Use fileVersionDescriptor instead')
const FileVersion$json = {
  '1': 'FileVersion',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'file_id', '3': 2, '4': 1, '5': 9, '10': 'fileId'},
    {'1': 'version_number', '3': 3, '4': 1, '5': 5, '10': 'versionNumber'},
    {'1': 'backup_path', '3': 4, '4': 1, '5': 9, '10': 'backupPath'},
    {'1': 'original_path', '3': 5, '4': 1, '5': 9, '10': 'originalPath'},
    {'1': 'size', '3': 6, '4': 1, '5': 3, '10': 'size'},
    {'1': 'hash', '3': 7, '4': 1, '5': 9, '10': 'hash'},
    {'1': 'created_at', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'created_by_peer_id', '3': 9, '4': 1, '5': 9, '10': 'createdByPeerId'},
  ],
};

/// Descriptor for `FileVersion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileVersionDescriptor = $convert.base64Decode(
    'CgtGaWxlVmVyc2lvbhIOCgJpZBgBIAEoCVICaWQSFwoHZmlsZV9pZBgCIAEoCVIGZmlsZUlkEi'
    'UKDnZlcnNpb25fbnVtYmVyGAMgASgFUg12ZXJzaW9uTnVtYmVyEh8KC2JhY2t1cF9wYXRoGAQg'
    'ASgJUgpiYWNrdXBQYXRoEiMKDW9yaWdpbmFsX3BhdGgYBSABKAlSDG9yaWdpbmFsUGF0aBISCg'
    'RzaXplGAYgASgDUgRzaXplEhIKBGhhc2gYByABKAlSBGhhc2gSOQoKY3JlYXRlZF9hdBgIIAEo'
    'CzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBIrChJjcmVhdGVkX2J5X3'
    'BlZXJfaWQYCSABKAlSD2NyZWF0ZWRCeVBlZXJJZA==');

@$core.Deprecated('Use getFileRequestDescriptor instead')
const GetFileRequest$json = {
  '1': 'GetFileRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFileRequestDescriptor = $convert.base64Decode(
    'Cg5HZXRGaWxlUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');

@$core.Deprecated('Use listFilesRequestDescriptor instead')
const ListFilesRequest$json = {
  '1': 'ListFilesRequest',
  '2': [
    {'1': 'folder_id', '3': 1, '4': 1, '5': 9, '10': 'folderId'},
    {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.aether.api.PaginationRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `ListFilesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFilesRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0RmlsZXNSZXF1ZXN0EhsKCWZvbGRlcl9pZBgBIAEoCVIIZm9sZGVySWQSPQoKcGFnaW'
    '5hdGlvbhgCIAEoCzIdLmFldGhlci5hcGkuUGFnaW5hdGlvblJlcXVlc3RSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use listFilesResponseDescriptor instead')
const ListFilesResponse$json = {
  '1': 'ListFilesResponse',
  '2': [
    {'1': 'files', '3': 1, '4': 3, '5': 11, '6': '.aether.api.File', '10': 'files'},
    {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.aether.api.PaginationResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `ListFilesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFilesResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0RmlsZXNSZXNwb25zZRImCgVmaWxlcxgBIAMoCzIQLmFldGhlci5hcGkuRmlsZVIFZm'
    'lsZXMSPgoKcGFnaW5hdGlvbhgCIAEoCzIeLmFldGhlci5hcGkuUGFnaW5hdGlvblJlc3BvbnNl'
    'UgpwYWdpbmF0aW9u');

@$core.Deprecated('Use getFileInfoRequestDescriptor instead')
const GetFileInfoRequest$json = {
  '1': 'GetFileInfoRequest',
  '2': [
    {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
  ],
};

/// Descriptor for `GetFileInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFileInfoRequestDescriptor = $convert.base64Decode(
    'ChJHZXRGaWxlSW5mb1JlcXVlc3QSFwoHZmlsZV9pZBgBIAEoCVIGZmlsZUlk');

@$core.Deprecated('Use fileInfoResponseDescriptor instead')
const FileInfoResponse$json = {
  '1': 'FileInfoResponse',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    {'1': 'file', '3': 2, '4': 1, '5': 11, '6': '.aether.api.File', '10': 'file'},
    {'1': 'chunks', '3': 3, '4': 3, '5': 11, '6': '.aether.api.Chunk', '10': 'chunks'},
    {'1': 'available_peers', '3': 4, '4': 3, '5': 9, '10': 'availablePeers'},
    {'1': 'version_count', '3': 5, '4': 1, '5': 5, '10': 'versionCount'},
    {'1': 'sync_percentage', '3': 6, '4': 1, '5': 2, '10': 'syncPercentage'},
    {'1': 'last_sync_time', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lastSyncTime'},
  ],
};

/// Descriptor for `FileInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileInfoResponseDescriptor = $convert.base64Decode(
    'ChBGaWxlSW5mb1Jlc3BvbnNlEioKBnN0YXR1cxgBIAEoCzISLmFldGhlci5hcGkuU3RhdHVzUg'
    'ZzdGF0dXMSJAoEZmlsZRgCIAEoCzIQLmFldGhlci5hcGkuRmlsZVIEZmlsZRIpCgZjaHVua3MY'
    'AyADKAsyES5hZXRoZXIuYXBpLkNodW5rUgZjaHVua3MSJwoPYXZhaWxhYmxlX3BlZXJzGAQgAy'
    'gJUg5hdmFpbGFibGVQZWVycxIjCg12ZXJzaW9uX2NvdW50GAUgASgFUgx2ZXJzaW9uQ291bnQS'
    'JwoPc3luY19wZXJjZW50YWdlGAYgASgCUg5zeW5jUGVyY2VudGFnZRJACg5sYXN0X3N5bmNfdG'
    'ltZRgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDGxhc3RTeW5jVGltZQ==');

@$core.Deprecated('Use deleteFileRequestDescriptor instead')
const DeleteFileRequest$json = {
  '1': 'DeleteFileRequest',
  '2': [
    {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
  ],
};

/// Descriptor for `DeleteFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteFileRequestDescriptor = $convert.base64Decode(
    'ChFEZWxldGVGaWxlUmVxdWVzdBIXCgdmaWxlX2lkGAEgASgJUgZmaWxlSWQ=');

@$core.Deprecated('Use getFileVersionsRequestDescriptor instead')
const GetFileVersionsRequest$json = {
  '1': 'GetFileVersionsRequest',
  '2': [
    {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
  ],
};

/// Descriptor for `GetFileVersionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFileVersionsRequestDescriptor = $convert.base64Decode(
    'ChZHZXRGaWxlVmVyc2lvbnNSZXF1ZXN0EhcKB2ZpbGVfaWQYASABKAlSBmZpbGVJZA==');

@$core.Deprecated('Use fileVersionsResponseDescriptor instead')
const FileVersionsResponse$json = {
  '1': 'FileVersionsResponse',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    {'1': 'versions', '3': 2, '4': 3, '5': 11, '6': '.aether.api.FileVersion', '10': 'versions'},
  ],
};

/// Descriptor for `FileVersionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileVersionsResponseDescriptor = $convert.base64Decode(
    'ChRGaWxlVmVyc2lvbnNSZXNwb25zZRIqCgZzdGF0dXMYASABKAsyEi5hZXRoZXIuYXBpLlN0YX'
    'R1c1IGc3RhdHVzEjMKCHZlcnNpb25zGAIgAygLMhcuYWV0aGVyLmFwaS5GaWxlVmVyc2lvblII'
    'dmVyc2lvbnM=');

@$core.Deprecated('Use restoreFileRequestDescriptor instead')
const RestoreFileRequest$json = {
  '1': 'RestoreFileRequest',
  '2': [
    {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
    {'1': 'version_id', '3': 2, '4': 1, '5': 9, '10': 'versionId'},
  ],
};

/// Descriptor for `RestoreFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restoreFileRequestDescriptor = $convert.base64Decode(
    'ChJSZXN0b3JlRmlsZVJlcXVlc3QSFwoHZmlsZV9pZBgBIAEoCVIGZmlsZUlkEh0KCnZlcnNpb2'
    '5faWQYAiABKAlSCXZlcnNpb25JZA==');

@$core.Deprecated('Use fileResponseDescriptor instead')
const FileResponse$json = {
  '1': 'FileResponse',
  '2': [
    {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    {'1': 'file', '3': 2, '4': 1, '5': 11, '6': '.aether.api.File', '10': 'file'},
  ],
};

/// Descriptor for `FileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileResponseDescriptor = $convert.base64Decode(
    'CgxGaWxlUmVzcG9uc2USKgoGc3RhdHVzGAEgASgLMhIuYWV0aGVyLmFwaS5TdGF0dXNSBnN0YX'
    'R1cxIkCgRmaWxlGAIgASgLMhAuYWV0aGVyLmFwaS5GaWxlUgRmaWxl');

