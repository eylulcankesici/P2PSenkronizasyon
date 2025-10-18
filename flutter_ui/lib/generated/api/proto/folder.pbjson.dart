///
//  Generated code. Do not modify.
//  source: api/proto/folder.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use folderDescriptor instead')
const Folder$json = const {
  '1': 'Folder',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'local_path', '3': 2, '4': 1, '5': 9, '10': 'localPath'},
    const {'1': 'sync_mode', '3': 3, '4': 1, '5': 14, '6': '.aether.api.SyncMode', '10': 'syncMode'},
    const {'1': 'last_scan_time', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lastScanTime'},
    const {'1': 'is_active', '3': 5, '4': 1, '5': 8, '10': 'isActive'},
    const {'1': 'created_at', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    const {'1': 'updated_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

/// Descriptor for `Folder`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List folderDescriptor = $convert.base64Decode('CgZGb2xkZXISDgoCaWQYASABKAlSAmlkEh0KCmxvY2FsX3BhdGgYAiABKAlSCWxvY2FsUGF0aBIxCglzeW5jX21vZGUYAyABKA4yFC5hZXRoZXIuYXBpLlN5bmNNb2RlUghzeW5jTW9kZRJACg5sYXN0X3NjYW5fdGltZRgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDGxhc3RTY2FuVGltZRIbCglpc19hY3RpdmUYBSABKAhSCGlzQWN0aXZlEjkKCmNyZWF0ZWRfYXQYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgljcmVhdGVkQXQSOQoKdXBkYXRlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXVwZGF0ZWRBdA==');
@$core.Deprecated('Use createFolderRequestDescriptor instead')
const CreateFolderRequest$json = const {
  '1': 'CreateFolderRequest',
  '2': const [
    const {'1': 'local_path', '3': 1, '4': 1, '5': 9, '10': 'localPath'},
    const {'1': 'sync_mode', '3': 2, '4': 1, '5': 14, '6': '.aether.api.SyncMode', '10': 'syncMode'},
  ],
};

/// Descriptor for `CreateFolderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createFolderRequestDescriptor = $convert.base64Decode('ChNDcmVhdGVGb2xkZXJSZXF1ZXN0Eh0KCmxvY2FsX3BhdGgYASABKAlSCWxvY2FsUGF0aBIxCglzeW5jX21vZGUYAiABKA4yFC5hZXRoZXIuYXBpLlN5bmNNb2RlUghzeW5jTW9kZQ==');
@$core.Deprecated('Use getFolderRequestDescriptor instead')
const GetFolderRequest$json = const {
  '1': 'GetFolderRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `GetFolderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getFolderRequestDescriptor = $convert.base64Decode('ChBHZXRGb2xkZXJSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');
@$core.Deprecated('Use listFoldersRequestDescriptor instead')
const ListFoldersRequest$json = const {
  '1': 'ListFoldersRequest',
  '2': const [
    const {'1': 'active_only', '3': 1, '4': 1, '5': 8, '10': 'activeOnly'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.aether.api.PaginationRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `ListFoldersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFoldersRequestDescriptor = $convert.base64Decode('ChJMaXN0Rm9sZGVyc1JlcXVlc3QSHwoLYWN0aXZlX29ubHkYASABKAhSCmFjdGl2ZU9ubHkSPQoKcGFnaW5hdGlvbhgCIAEoCzIdLmFldGhlci5hcGkuUGFnaW5hdGlvblJlcXVlc3RSCnBhZ2luYXRpb24=');
@$core.Deprecated('Use listFoldersResponseDescriptor instead')
const ListFoldersResponse$json = const {
  '1': 'ListFoldersResponse',
  '2': const [
    const {'1': 'folders', '3': 1, '4': 3, '5': 11, '6': '.aether.api.Folder', '10': 'folders'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.aether.api.PaginationResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `ListFoldersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listFoldersResponseDescriptor = $convert.base64Decode('ChNMaXN0Rm9sZGVyc1Jlc3BvbnNlEiwKB2ZvbGRlcnMYASADKAsyEi5hZXRoZXIuYXBpLkZvbGRlclIHZm9sZGVycxI+CgpwYWdpbmF0aW9uGAIgASgLMh4uYWV0aGVyLmFwaS5QYWdpbmF0aW9uUmVzcG9uc2VSCnBhZ2luYXRpb24=');
@$core.Deprecated('Use updateFolderRequestDescriptor instead')
const UpdateFolderRequest$json = const {
  '1': 'UpdateFolderRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'local_path', '3': 2, '4': 1, '5': 9, '10': 'localPath'},
    const {'1': 'sync_mode', '3': 3, '4': 1, '5': 14, '6': '.aether.api.SyncMode', '10': 'syncMode'},
  ],
};

/// Descriptor for `UpdateFolderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateFolderRequestDescriptor = $convert.base64Decode('ChNVcGRhdGVGb2xkZXJSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZBIdCgpsb2NhbF9wYXRoGAIgASgJUglsb2NhbFBhdGgSMQoJc3luY19tb2RlGAMgASgOMhQuYWV0aGVyLmFwaS5TeW5jTW9kZVIIc3luY01vZGU=');
@$core.Deprecated('Use deleteFolderRequestDescriptor instead')
const DeleteFolderRequest$json = const {
  '1': 'DeleteFolderRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `DeleteFolderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteFolderRequestDescriptor = $convert.base64Decode('ChNEZWxldGVGb2xkZXJSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZA==');
@$core.Deprecated('Use toggleFolderActiveRequestDescriptor instead')
const ToggleFolderActiveRequest$json = const {
  '1': 'ToggleFolderActiveRequest',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'is_active', '3': 2, '4': 1, '5': 8, '10': 'isActive'},
  ],
};

/// Descriptor for `ToggleFolderActiveRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List toggleFolderActiveRequestDescriptor = $convert.base64Decode('ChlUb2dnbGVGb2xkZXJBY3RpdmVSZXF1ZXN0Eg4KAmlkGAEgASgJUgJpZBIbCglpc19hY3RpdmUYAiABKAhSCGlzQWN0aXZl');
@$core.Deprecated('Use folderResponseDescriptor instead')
const FolderResponse$json = const {
  '1': 'FolderResponse',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    const {'1': 'folder', '3': 2, '4': 1, '5': 11, '6': '.aether.api.Folder', '10': 'folder'},
  ],
};

/// Descriptor for `FolderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List folderResponseDescriptor = $convert.base64Decode('Cg5Gb2xkZXJSZXNwb25zZRIqCgZzdGF0dXMYASABKAsyEi5hZXRoZXIuYXBpLlN0YXR1c1IGc3RhdHVzEioKBmZvbGRlchgCIAEoCzISLmFldGhlci5hcGkuRm9sZGVyUgZmb2xkZXI=');
@$core.Deprecated('Use scanFolderRequestDescriptor instead')
const ScanFolderRequest$json = const {
  '1': 'ScanFolderRequest',
  '2': const [
    const {'1': 'folder_id', '3': 1, '4': 1, '5': 9, '10': 'folderId'},
  ],
};

/// Descriptor for `ScanFolderRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scanFolderRequestDescriptor = $convert.base64Decode('ChFTY2FuRm9sZGVyUmVxdWVzdBIbCglmb2xkZXJfaWQYASABKAlSCGZvbGRlcklk');
@$core.Deprecated('Use scanFolderResponseDescriptor instead')
const ScanFolderResponse$json = const {
  '1': 'ScanFolderResponse',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    const {'1': 'files_found', '3': 2, '4': 1, '5': 5, '10': 'filesFound'},
    const {'1': 'files_saved', '3': 3, '4': 1, '5': 5, '10': 'filesSaved'},
  ],
};

/// Descriptor for `ScanFolderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scanFolderResponseDescriptor = $convert.base64Decode('ChJTY2FuRm9sZGVyUmVzcG9uc2USKgoGc3RhdHVzGAEgASgLMhIuYWV0aGVyLmFwaS5TdGF0dXNSBnN0YXR1cxIfCgtmaWxlc19mb3VuZBgCIAEoBVIKZmlsZXNGb3VuZBIfCgtmaWxlc19zYXZlZBgDIAEoBVIKZmlsZXNTYXZlZA==');
