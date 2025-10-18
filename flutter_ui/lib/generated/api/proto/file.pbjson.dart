///
//  Generated code. Do not modify.
//  source: api/proto/file.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use fileDescriptor instead')
const File$json = const {
  '1': 'File',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'folder_id', '3': 2, '4': 1, '5': 9, '10': 'folderId'},
    const {'1': 'relative_path', '3': 3, '4': 1, '5': 9, '10': 'relativePath'},
    const {'1': 'size', '3': 4, '4': 1, '5': 3, '10': 'size'},
    const {'1': 'mod_time', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'modTime'},
    const {'1': 'global_hash', '3': 6, '4': 1, '5': 9, '10': 'globalHash'},
    const {'1': 'chunk_count', '3': 7, '4': 1, '5': 5, '10': 'chunkCount'},
    const {'1': 'is_deleted', '3': 8, '4': 1, '5': 8, '10': 'isDeleted'},
    const {'1': 'created_at', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    const {'1': 'updated_at', '3': 10, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

/// Descriptor for `File`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileDescriptor = $convert.base64Decode('CgRGaWxlEg4KAmlkGAEgASgJUgJpZBIbCglmb2xkZXJfaWQYAiABKAlSCGZvbGRlcklkEiMKDXJlbGF0aXZlX3BhdGgYAyABKAlSDHJlbGF0aXZlUGF0aBISCgRzaXplGAQgASgDUgRzaXplEjUKCG1vZF90aW1lGAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIHbW9kVGltZRIfCgtnbG9iYWxfaGFzaBgGIAEoCVIKZ2xvYmFsSGFzaBIfCgtjaHVua19jb3VudBgHIAEoBVIKY2h1bmtDb3VudBIdCgppc19kZWxldGVkGAggASgIUglpc0RlbGV0ZWQSOQoKY3JlYXRlZF9hdBgJIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAogASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');
@$core.Deprecated('Use chunkDescriptor instead')
const Chunk$json = const {
  '1': 'Chunk',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'file_id', '3': 2, '4': 1, '5': 9, '10': 'fileId'},
    const {'1': 'offset', '3': 3, '4': 1, '5': 3, '10': 'offset'},
    const {'1': 'length', '3': 4, '4': 1, '5': 3, '10': 'length'},
    const {'1': 'device_availability', '3': 5, '4': 3, '5': 9, '10': 'deviceAvailability'},
  ],
};

/// Descriptor for `Chunk`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List chunkDescriptor = $convert.base64Decode('CgVDaHVuaxIOCgJpZBgBIAEoCVICaWQSFwoHZmlsZV9pZBgCIAEoCVIGZmlsZUlkEhYKBm9mZnNldBgDIAEoA1IGb2Zmc2V0EhYKBmxlbmd0aBgEIAEoA1IGbGVuZ3RoEi8KE2RldmljZV9hdmFpbGFiaWxpdHkYBSADKAlSEmRldmljZUF2YWlsYWJpbGl0eQ==');
@$core.Deprecated('Use fileVersionDescriptor instead')
const FileVersion$json = const {
  '1': 'FileVersion',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'file_id', '3': 2, '4': 1, '5': 9, '10': 'fileId'},
    const {'1': 'version_number', '3': 3, '4': 1, '5': 5, '10': 'versionNumber'},
    const {'1': 'backup_path', '3': 4, '4': 1, '5': 9, '10': 'backupPath'},
    const {'1': 'original_path', '3': 5, '4': 1, '5': 9, '10': 'originalPath'},
    const {'1': 'size', '3': 6, '4': 1, '5': 3, '10': 'size'},
    const {'1': 'hash', '3': 7, '4': 1, '5': 9, '10': 'hash'},
    const {'1': 'created_at', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    const {'1': 'created_by_peer_id', '3': 9, '4': 1, '5': 9, '10': 'createdByPeerId'},
  ],
};

/// Descriptor for `FileVersion`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileVersionDescriptor = $convert.base64Decode('CgtGaWxlVmVyc2lvbhIOCgJpZBgBIAEoCVICaWQSFwoHZmlsZV9pZBgCIAEoCVIGZmlsZUlkEiUKDnZlcnNpb25fbnVtYmVyGAMgASgFUg12ZXJzaW9uTnVtYmVyEh8KC2JhY2t1cF9wYXRoGAQgASgJUgpiYWNrdXBQYXRoEiMKDW9yaWdpbmFsX3BhdGgYBSABKAlSDG9yaWdpbmFsUGF0aBISCgRzaXplGAYgASgDUgRzaXplEhIKBGhhc2gYByABKAlSBGhhc2gSOQoKY3JlYXRlZF9hdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBIrChJjcmVhdGVkX2J5X3BlZXJfaWQYCSABKAlSD2NyZWF0ZWRCeVBlZXJJZA==');
@$core.Deprecated('Use getFileRequestDescriptor instead')
const GetFileRequest$json = const {
  '1': 'GetFileRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFileRequestDescriptor = $convert.base64Decode('Cg5HZXRGaWxlUmVxdWVzdBIOCgJpZBgBIAEoCVICaWQ=');
@$core.Deprecated('Use listFilesRequestDescriptor instead')
const ListFilesRequest$json = const {
  '1': 'ListFilesRequest',
  '2': const [
    const {'1': 'folder_id', '3': 1, '4': 1, '5': 9, '10': 'folderId'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.aether.api.PaginationRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `ListFilesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFilesRequestDescriptor = $convert.base64Decode('ChBMaXN0RmlsZXNSZXF1ZXN0EhsKCWZvbGRlcl9pZBgBIAEoCVIIZm9sZGVySWQSPQoKcGFnaW5hdGlvbhgCIAEoCzIdLmFldGhlci5hcGkuUGFnaW5hdGlvblJlcXVlc3RSCnBhZ2luYXRpb24=');
@$core.Deprecated('Use listFilesResponseDescriptor instead')
const ListFilesResponse$json = const {
  '1': 'ListFilesResponse',
  '2': const [
    const {'1': 'files', '3': 1, '4': 3, '5': 11, '6': '.aether.api.File', '10': 'files'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.aether.api.PaginationResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `ListFilesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFilesResponseDescriptor = $convert.base64Decode('ChFMaXN0RmlsZXNSZXNwb25zZRImCgVmaWxlcxgBIAMoCzIQLmFldGhlci5hcGkuRmlsZVIFZmlsZXMSPgoKcGFnaW5hdGlvbhgCIAEoCzIeLmFldGhlci5hcGkuUGFnaW5hdGlvblJlc3BvbnNlUgpwYWdpbmF0aW9u');
@$core.Deprecated('Use getFileInfoRequestDescriptor instead')
const GetFileInfoRequest$json = const {
  '1': 'GetFileInfoRequest',
  '2': const [
    const {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
  ],
};

/// Descriptor for `GetFileInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFileInfoRequestDescriptor = $convert.base64Decode('ChJHZXRGaWxlSW5mb1JlcXVlc3QSFwoHZmlsZV9pZBgBIAEoCVIGZmlsZUlk');
@$core.Deprecated('Use fileInfoResponseDescriptor instead')
const FileInfoResponse$json = const {
  '1': 'FileInfoResponse',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    const {'1': 'file', '3': 2, '4': 1, '5': 11, '6': '.aether.api.File', '10': 'file'},
    const {'1': 'chunks', '3': 3, '4': 3, '5': 11, '6': '.aether.api.Chunk', '10': 'chunks'},
    const {'1': 'available_peers', '3': 4, '4': 3, '5': 9, '10': 'availablePeers'},
    const {'1': 'version_count', '3': 5, '4': 1, '5': 5, '10': 'versionCount'},
    const {'1': 'sync_percentage', '3': 6, '4': 1, '5': 2, '10': 'syncPercentage'},
    const {'1': 'last_sync_time', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lastSyncTime'},
  ],
};

/// Descriptor for `FileInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileInfoResponseDescriptor = $convert.base64Decode('ChBGaWxlSW5mb1Jlc3BvbnNlEioKBnN0YXR1cxgBIAEoCzISLmFldGhlci5hcGkuU3RhdHVzUgZzdGF0dXMSJAoEZmlsZRgCIAEoCzIQLmFldGhlci5hcGkuRmlsZVIEZmlsZRIpCgZjaHVua3MYAyADKAsyES5hZXRoZXIuYXBpLkNodW5rUgZjaHVua3MSJwoPYXZhaWxhYmxlX3BlZXJzGAQgAygJUg5hdmFpbGFibGVQZWVycxIjCg12ZXJzaW9uX2NvdW50GAUgASgFUgx2ZXJzaW9uQ291bnQSJwoPc3luY19wZXJjZW50YWdlGAYgASgCUg5zeW5jUGVyY2VudGFnZRJACg5sYXN0X3N5bmNfdGltZRgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDGxhc3RTeW5jVGltZQ==');
@$core.Deprecated('Use deleteFileRequestDescriptor instead')
const DeleteFileRequest$json = const {
  '1': 'DeleteFileRequest',
  '2': const [
    const {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
  ],
};

/// Descriptor for `DeleteFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteFileRequestDescriptor = $convert.base64Decode('ChFEZWxldGVGaWxlUmVxdWVzdBIXCgdmaWxlX2lkGAEgASgJUgZmaWxlSWQ=');
@$core.Deprecated('Use getFileVersionsRequestDescriptor instead')
const GetFileVersionsRequest$json = const {
  '1': 'GetFileVersionsRequest',
  '2': const [
    const {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
  ],
};

/// Descriptor for `GetFileVersionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFileVersionsRequestDescriptor = $convert.base64Decode('ChZHZXRGaWxlVmVyc2lvbnNSZXF1ZXN0EhcKB2ZpbGVfaWQYASABKAlSBmZpbGVJZA==');
@$core.Deprecated('Use fileVersionsResponseDescriptor instead')
const FileVersionsResponse$json = const {
  '1': 'FileVersionsResponse',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    const {'1': 'versions', '3': 2, '4': 3, '5': 11, '6': '.aether.api.FileVersion', '10': 'versions'},
  ],
};

/// Descriptor for `FileVersionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileVersionsResponseDescriptor = $convert.base64Decode('ChRGaWxlVmVyc2lvbnNSZXNwb25zZRIqCgZzdGF0dXMYASABKAsyEi5hZXRoZXIuYXBpLlN0YXR1c1IGc3RhdHVzEjMKCHZlcnNpb25zGAIgAygLMhcuYWV0aGVyLmFwaS5GaWxlVmVyc2lvblIIdmVyc2lvbnM=');
@$core.Deprecated('Use restoreFileRequestDescriptor instead')
const RestoreFileRequest$json = const {
  '1': 'RestoreFileRequest',
  '2': const [
    const {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
    const {'1': 'version_id', '3': 2, '4': 1, '5': 9, '10': 'versionId'},
  ],
};

/// Descriptor for `RestoreFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restoreFileRequestDescriptor = $convert.base64Decode('ChJSZXN0b3JlRmlsZVJlcXVlc3QSFwoHZmlsZV9pZBgBIAEoCVIGZmlsZUlkEh0KCnZlcnNpb25faWQYAiABKAlSCXZlcnNpb25JZA==');
@$core.Deprecated('Use fileResponseDescriptor instead')
const FileResponse$json = const {
  '1': 'FileResponse',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    const {'1': 'file', '3': 2, '4': 1, '5': 11, '6': '.aether.api.File', '10': 'file'},
  ],
};

/// Descriptor for `FileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileResponseDescriptor = $convert.base64Decode('CgxGaWxlUmVzcG9uc2USKgoGc3RhdHVzGAEgASgLMhIuYWV0aGVyLmFwaS5TdGF0dXNSBnN0YXR1cxIkCgRmaWxlGAIgASgLMhAuYWV0aGVyLmFwaS5GaWxlUgRmaWxl');
