///
//  Generated code. Do not modify.
//  source: api/proto/sync.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
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
    const {'1': 'changes_detected', '3': 3, '4': 1, '5': 5, '10': 'changesDetected'},
  ],
};

/// Descriptor for `ScanFolderResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List scanFolderResponseDescriptor = $convert.base64Decode('ChJTY2FuRm9sZGVyUmVzcG9uc2USKgoGc3RhdHVzGAEgASgLMhIuYWV0aGVyLmFwaS5TdGF0dXNSBnN0YXR1cxIfCgtmaWxlc19mb3VuZBgCIAEoBVIKZmlsZXNGb3VuZBIpChBjaGFuZ2VzX2RldGVjdGVkGAMgASgFUg9jaGFuZ2VzRGV0ZWN0ZWQ=');
@$core.Deprecated('Use syncFileRequestDescriptor instead')
const SyncFileRequest$json = const {
  '1': 'SyncFileRequest',
  '2': const [
    const {'1': 'file_id', '3': 1, '4': 1, '5': 9, '10': 'fileId'},
    const {'1': 'target_peer_ids', '3': 2, '4': 3, '5': 9, '10': 'targetPeerIds'},
  ],
};

/// Descriptor for `SyncFileRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncFileRequestDescriptor = $convert.base64Decode('Cg9TeW5jRmlsZVJlcXVlc3QSFwoHZmlsZV9pZBgBIAEoCVIGZmlsZUlkEiYKD3RhcmdldF9wZWVyX2lkcxgCIAMoCVINdGFyZ2V0UGVlcklkcw==');
@$core.Deprecated('Use syncFileResponseDescriptor instead')
const SyncFileResponse$json = const {
  '1': 'SyncFileResponse',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    const {'1': 'progress', '3': 2, '4': 1, '5': 11, '6': '.aether.api.SyncProgress', '10': 'progress'},
  ],
};

/// Descriptor for `SyncFileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncFileResponseDescriptor = $convert.base64Decode('ChBTeW5jRmlsZVJlc3BvbnNlEioKBnN0YXR1cxgBIAEoCzISLmFldGhlci5hcGkuU3RhdHVzUgZzdGF0dXMSNAoIcHJvZ3Jlc3MYAiABKAsyGC5hZXRoZXIuYXBpLlN5bmNQcm9ncmVzc1IIcHJvZ3Jlc3M=');
@$core.Deprecated('Use getSyncStatusRequestDescriptor instead')
const GetSyncStatusRequest$json = const {
  '1': 'GetSyncStatusRequest',
  '2': const [
    const {'1': 'folder_id', '3': 1, '4': 1, '5': 9, '10': 'folderId'},
  ],
};

/// Descriptor for `GetSyncStatusRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSyncStatusRequestDescriptor = $convert.base64Decode('ChRHZXRTeW5jU3RhdHVzUmVxdWVzdBIbCglmb2xkZXJfaWQYASABKAlSCGZvbGRlcklk');
@$core.Deprecated('Use syncStatusResponseDescriptor instead')
const SyncStatusResponse$json = const {
  '1': 'SyncStatusResponse',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    const {'1': 'sync_status', '3': 2, '4': 1, '5': 11, '6': '.aether.api.SyncStatus', '10': 'syncStatus'},
  ],
};

/// Descriptor for `SyncStatusResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncStatusResponseDescriptor = $convert.base64Decode('ChJTeW5jU3RhdHVzUmVzcG9uc2USKgoGc3RhdHVzGAEgASgLMhIuYWV0aGVyLmFwaS5TdGF0dXNSBnN0YXR1cxI3CgtzeW5jX3N0YXR1cxgCIAEoCzIWLmFldGhlci5hcGkuU3luY1N0YXR1c1IKc3luY1N0YXR1cw==');
@$core.Deprecated('Use syncStatusDescriptor instead')
const SyncStatus$json = const {
  '1': 'SyncStatus',
  '2': const [
    const {'1': 'folder_id', '3': 1, '4': 1, '5': 9, '10': 'folderId'},
    const {'1': 'total_files', '3': 2, '4': 1, '5': 5, '10': 'totalFiles'},
    const {'1': 'synced_files', '3': 3, '4': 1, '5': 5, '10': 'syncedFiles'},
    const {'1': 'pending_files', '3': 4, '4': 1, '5': 5, '10': 'pendingFiles'},
    const {'1': 'total_size', '3': 5, '4': 1, '5': 3, '10': 'totalSize'},
    const {'1': 'synced_size', '3': 6, '4': 1, '5': 3, '10': 'syncedSize'},
    const {'1': 'last_sync_time', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lastSyncTime'},
    const {'1': 'is_syncing', '3': 8, '4': 1, '5': 8, '10': 'isSyncing'},
    const {'1': 'current_operation', '3': 9, '4': 1, '5': 9, '10': 'currentOperation'},
  ],
};

/// Descriptor for `SyncStatus`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncStatusDescriptor = $convert.base64Decode('CgpTeW5jU3RhdHVzEhsKCWZvbGRlcl9pZBgBIAEoCVIIZm9sZGVySWQSHwoLdG90YWxfZmlsZXMYAiABKAVSCnRvdGFsRmlsZXMSIQoMc3luY2VkX2ZpbGVzGAMgASgFUgtzeW5jZWRGaWxlcxIjCg1wZW5kaW5nX2ZpbGVzGAQgASgFUgxwZW5kaW5nRmlsZXMSHQoKdG90YWxfc2l6ZRgFIAEoA1IJdG90YWxTaXplEh8KC3N5bmNlZF9zaXplGAYgASgDUgpzeW5jZWRTaXplEkAKDmxhc3Rfc3luY190aW1lGAcgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIMbGFzdFN5bmNUaW1lEh0KCmlzX3N5bmNpbmcYCCABKAhSCWlzU3luY2luZxIrChFjdXJyZW50X29wZXJhdGlvbhgJIAEoCVIQY3VycmVudE9wZXJhdGlvbg==');
@$core.Deprecated('Use syncProgressDescriptor instead')
const SyncProgress$json = const {
  '1': 'SyncProgress',
  '2': const [
    const {'1': 'bytes_transferred', '3': 1, '4': 1, '5': 3, '10': 'bytesTransferred'},
    const {'1': 'total_bytes', '3': 2, '4': 1, '5': 3, '10': 'totalBytes'},
    const {'1': 'percentage', '3': 3, '4': 1, '5': 2, '10': 'percentage'},
    const {'1': 'speed_bps', '3': 4, '4': 1, '5': 3, '10': 'speedBps'},
    const {'1': 'eta_seconds', '3': 5, '4': 1, '5': 3, '10': 'etaSeconds'},
  ],
};

/// Descriptor for `SyncProgress`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncProgressDescriptor = $convert.base64Decode('CgxTeW5jUHJvZ3Jlc3MSKwoRYnl0ZXNfdHJhbnNmZXJyZWQYASABKANSEGJ5dGVzVHJhbnNmZXJyZWQSHwoLdG90YWxfYnl0ZXMYAiABKANSCnRvdGFsQnl0ZXMSHgoKcGVyY2VudGFnZRgDIAEoAlIKcGVyY2VudGFnZRIbCglzcGVlZF9icHMYBCABKANSCHNwZWVkQnBzEh8KC2V0YV9zZWNvbmRzGAUgASgDUgpldGFTZWNvbmRz');
@$core.Deprecated('Use pauseSyncRequestDescriptor instead')
const PauseSyncRequest$json = const {
  '1': 'PauseSyncRequest',
  '2': const [
    const {'1': 'folder_id', '3': 1, '4': 1, '5': 9, '10': 'folderId'},
  ],
};

/// Descriptor for `PauseSyncRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pauseSyncRequestDescriptor = $convert.base64Decode('ChBQYXVzZVN5bmNSZXF1ZXN0EhsKCWZvbGRlcl9pZBgBIAEoCVIIZm9sZGVySWQ=');
@$core.Deprecated('Use resumeSyncRequestDescriptor instead')
const ResumeSyncRequest$json = const {
  '1': 'ResumeSyncRequest',
  '2': const [
    const {'1': 'folder_id', '3': 1, '4': 1, '5': 9, '10': 'folderId'},
  ],
};

/// Descriptor for `ResumeSyncRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List resumeSyncRequestDescriptor = $convert.base64Decode('ChFSZXN1bWVTeW5jUmVxdWVzdBIbCglmb2xkZXJfaWQYASABKAlSCGZvbGRlcklk');
@$core.Deprecated('Use watchSyncEventsRequestDescriptor instead')
const WatchSyncEventsRequest$json = const {
  '1': 'WatchSyncEventsRequest',
  '2': const [
    const {'1': 'folder_id', '3': 1, '4': 1, '5': 9, '10': 'folderId'},
  ],
};

/// Descriptor for `WatchSyncEventsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List watchSyncEventsRequestDescriptor = $convert.base64Decode('ChZXYXRjaFN5bmNFdmVudHNSZXF1ZXN0EhsKCWZvbGRlcl9pZBgBIAEoCVIIZm9sZGVySWQ=');
@$core.Deprecated('Use syncEventDescriptor instead')
const SyncEvent$json = const {
  '1': 'SyncEvent',
  '2': const [
    const {'1': 'event_type', '3': 1, '4': 1, '5': 14, '6': '.aether.api.SyncEvent.EventType', '10': 'eventType'},
    const {'1': 'file_id', '3': 2, '4': 1, '5': 9, '10': 'fileId'},
    const {'1': 'file_path', '3': 3, '4': 1, '5': 9, '10': 'filePath'},
    const {'1': 'timestamp', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
    const {'1': 'message', '3': 5, '4': 1, '5': 9, '10': 'message'},
  ],
  '4': const [SyncEvent_EventType$json],
};

@$core.Deprecated('Use syncEventDescriptor instead')
const SyncEvent_EventType$json = const {
  '1': 'EventType',
  '2': const [
    const {'1': 'EVENT_TYPE_UNSPECIFIED', '2': 0},
    const {'1': 'EVENT_TYPE_FILE_ADDED', '2': 1},
    const {'1': 'EVENT_TYPE_FILE_MODIFIED', '2': 2},
    const {'1': 'EVENT_TYPE_FILE_DELETED', '2': 3},
    const {'1': 'EVENT_TYPE_SYNC_STARTED', '2': 4},
    const {'1': 'EVENT_TYPE_SYNC_COMPLETED', '2': 5},
    const {'1': 'EVENT_TYPE_SYNC_FAILED', '2': 6},
  ],
};

/// Descriptor for `SyncEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncEventDescriptor = $convert.base64Decode('CglTeW5jRXZlbnQSPgoKZXZlbnRfdHlwZRgBIAEoDjIfLmFldGhlci5hcGkuU3luY0V2ZW50LkV2ZW50VHlwZVIJZXZlbnRUeXBlEhcKB2ZpbGVfaWQYAiABKAlSBmZpbGVJZBIbCglmaWxlX3BhdGgYAyABKAlSCGZpbGVQYXRoEjgKCXRpbWVzdGFtcBgEIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXRpbWVzdGFtcBIYCgdtZXNzYWdlGAUgASgJUgdtZXNzYWdlItUBCglFdmVudFR5cGUSGgoWRVZFTlRfVFlQRV9VTlNQRUNJRklFRBAAEhkKFUVWRU5UX1RZUEVfRklMRV9BRERFRBABEhwKGEVWRU5UX1RZUEVfRklMRV9NT0RJRklFRBACEhsKF0VWRU5UX1RZUEVfRklMRV9ERUxFVEVEEAMSGwoXRVZFTlRfVFlQRV9TWU5DX1NUQVJURUQQBBIdChlFVkVOVF9UWVBFX1NZTkNfQ09NUExFVEVEEAUSGgoWRVZFTlRfVFlQRV9TWU5DX0ZBSUxFRBAG');
