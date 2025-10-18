///
//  Generated code. Do not modify.
//  source: api/proto/peer.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,deprecated_member_use_from_same_package,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use peerDescriptor instead')
const Peer$json = const {
  '1': 'Peer',
  '2': const [
    const {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'known_addresses', '3': 3, '4': 3, '5': 9, '10': 'knownAddresses'},
    const {'1': 'is_trusted', '3': 4, '4': 1, '5': 8, '10': 'isTrusted'},
    const {'1': 'last_seen', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lastSeen'},
    const {'1': 'status', '3': 6, '4': 1, '5': 14, '6': '.aether.api.PeerStatus', '10': 'status'},
    const {'1': 'public_key', '3': 7, '4': 1, '5': 9, '10': 'publicKey'},
    const {'1': 'created_at', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    const {'1': 'updated_at', '3': 9, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
  ],
};

/// Descriptor for `Peer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List peerDescriptor = $convert.base64Decode('CgRQZWVyEhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aWNlSWQSEgoEbmFtZRgCIAEoCVIEbmFtZRInCg9rbm93bl9hZGRyZXNzZXMYAyADKAlSDmtub3duQWRkcmVzc2VzEh0KCmlzX3RydXN0ZWQYBCABKAhSCWlzVHJ1c3RlZBI3CglsYXN0X3NlZW4YBSABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghsYXN0U2VlbhIuCgZzdGF0dXMYBiABKA4yFi5hZXRoZXIuYXBpLlBlZXJTdGF0dXNSBnN0YXR1cxIdCgpwdWJsaWNfa2V5GAcgASgJUglwdWJsaWNLZXkSOQoKY3JlYXRlZF9hdBgIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0');
@$core.Deprecated('Use discoverPeersRequestDescriptor instead')
const DiscoverPeersRequest$json = const {
  '1': 'DiscoverPeersRequest',
  '2': const [
    const {'1': 'lan_only', '3': 1, '4': 1, '5': 8, '10': 'lanOnly'},
  ],
};

/// Descriptor for `DiscoverPeersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discoverPeersRequestDescriptor = $convert.base64Decode('ChREaXNjb3ZlclBlZXJzUmVxdWVzdBIZCghsYW5fb25seRgBIAEoCFIHbGFuT25seQ==');
@$core.Deprecated('Use discoverPeersResponseDescriptor instead')
const DiscoverPeersResponse$json = const {
  '1': 'DiscoverPeersResponse',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    const {'1': 'peers', '3': 2, '4': 3, '5': 11, '6': '.aether.api.Peer', '10': 'peers'},
  ],
};

/// Descriptor for `DiscoverPeersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discoverPeersResponseDescriptor = $convert.base64Decode('ChVEaXNjb3ZlclBlZXJzUmVzcG9uc2USKgoGc3RhdHVzGAEgASgLMhIuYWV0aGVyLmFwaS5TdGF0dXNSBnN0YXR1cxImCgVwZWVycxgCIAMoCzIQLmFldGhlci5hcGkuUGVlclIFcGVlcnM=');
@$core.Deprecated('Use connectToPeerRequestDescriptor instead')
const ConnectToPeerRequest$json = const {
  '1': 'ConnectToPeerRequest',
  '2': const [
    const {'1': 'peer_id', '3': 1, '4': 1, '5': 9, '10': 'peerId'},
  ],
};

/// Descriptor for `ConnectToPeerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectToPeerRequestDescriptor = $convert.base64Decode('ChRDb25uZWN0VG9QZWVyUmVxdWVzdBIXCgdwZWVyX2lkGAEgASgJUgZwZWVySWQ=');
@$core.Deprecated('Use disconnectFromPeerRequestDescriptor instead')
const DisconnectFromPeerRequest$json = const {
  '1': 'DisconnectFromPeerRequest',
  '2': const [
    const {'1': 'peer_id', '3': 1, '4': 1, '5': 9, '10': 'peerId'},
  ],
};

/// Descriptor for `DisconnectFromPeerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disconnectFromPeerRequestDescriptor = $convert.base64Decode('ChlEaXNjb25uZWN0RnJvbVBlZXJSZXF1ZXN0EhcKB3BlZXJfaWQYASABKAlSBnBlZXJJZA==');
@$core.Deprecated('Use listPeersRequestDescriptor instead')
const ListPeersRequest$json = const {
  '1': 'ListPeersRequest',
  '2': const [
    const {'1': 'online_only', '3': 1, '4': 1, '5': 8, '10': 'onlineOnly'},
    const {'1': 'trusted_only', '3': 2, '4': 1, '5': 8, '10': 'trustedOnly'},
    const {'1': 'pagination', '3': 3, '4': 1, '5': 11, '6': '.aether.api.PaginationRequest', '10': 'pagination'},
  ],
};

/// Descriptor for `ListPeersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPeersRequestDescriptor = $convert.base64Decode('ChBMaXN0UGVlcnNSZXF1ZXN0Eh8KC29ubGluZV9vbmx5GAEgASgIUgpvbmxpbmVPbmx5EiEKDHRydXN0ZWRfb25seRgCIAEoCFILdHJ1c3RlZE9ubHkSPQoKcGFnaW5hdGlvbhgDIAEoCzIdLmFldGhlci5hcGkuUGFnaW5hdGlvblJlcXVlc3RSCnBhZ2luYXRpb24=');
@$core.Deprecated('Use listPeersResponseDescriptor instead')
const ListPeersResponse$json = const {
  '1': 'ListPeersResponse',
  '2': const [
    const {'1': 'peers', '3': 1, '4': 3, '5': 11, '6': '.aether.api.Peer', '10': 'peers'},
    const {'1': 'pagination', '3': 2, '4': 1, '5': 11, '6': '.aether.api.PaginationResponse', '10': 'pagination'},
  ],
};

/// Descriptor for `ListPeersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPeersResponseDescriptor = $convert.base64Decode('ChFMaXN0UGVlcnNSZXNwb25zZRImCgVwZWVycxgBIAMoCzIQLmFldGhlci5hcGkuUGVlclIFcGVlcnMSPgoKcGFnaW5hdGlvbhgCIAEoCzIeLmFldGhlci5hcGkuUGFnaW5hdGlvblJlc3BvbnNlUgpwYWdpbmF0aW9u');
@$core.Deprecated('Use getPeerInfoRequestDescriptor instead')
const GetPeerInfoRequest$json = const {
  '1': 'GetPeerInfoRequest',
  '2': const [
    const {'1': 'peer_id', '3': 1, '4': 1, '5': 9, '10': 'peerId'},
  ],
};

/// Descriptor for `GetPeerInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPeerInfoRequestDescriptor = $convert.base64Decode('ChJHZXRQZWVySW5mb1JlcXVlc3QSFwoHcGVlcl9pZBgBIAEoCVIGcGVlcklk');
@$core.Deprecated('Use peerInfoResponseDescriptor instead')
const PeerInfoResponse$json = const {
  '1': 'PeerInfoResponse',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 11, '6': '.aether.api.Status', '10': 'status'},
    const {'1': 'peer', '3': 2, '4': 1, '5': 11, '6': '.aether.api.Peer', '10': 'peer'},
    const {'1': 'shared_folders', '3': 3, '4': 3, '5': 9, '10': 'sharedFolders'},
    const {'1': 'shared_files', '3': 4, '4': 1, '5': 5, '10': 'sharedFiles'},
    const {'1': 'total_chunks', '3': 5, '4': 1, '5': 5, '10': 'totalChunks'},
    const {'1': 'last_activity', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'lastActivity'},
    const {'1': 'connection_type', '3': 7, '4': 1, '5': 9, '10': 'connectionType'},
    const {'1': 'latency_ms', '3': 8, '4': 1, '5': 3, '10': 'latencyMs'},
  ],
};

/// Descriptor for `PeerInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List peerInfoResponseDescriptor = $convert.base64Decode('ChBQZWVySW5mb1Jlc3BvbnNlEioKBnN0YXR1cxgBIAEoCzISLmFldGhlci5hcGkuU3RhdHVzUgZzdGF0dXMSJAoEcGVlchgCIAEoCzIQLmFldGhlci5hcGkuUGVlclIEcGVlchIlCg5zaGFyZWRfZm9sZGVycxgDIAMoCVINc2hhcmVkRm9sZGVycxIhCgxzaGFyZWRfZmlsZXMYBCABKAVSC3NoYXJlZEZpbGVzEiEKDHRvdGFsX2NodW5rcxgFIAEoBVILdG90YWxDaHVua3MSPwoNbGFzdF9hY3Rpdml0eRgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDGxhc3RBY3Rpdml0eRInCg9jb25uZWN0aW9uX3R5cGUYByABKAlSDmNvbm5lY3Rpb25UeXBlEh0KCmxhdGVuY3lfbXMYCCABKANSCWxhdGVuY3lNcw==');
@$core.Deprecated('Use trustPeerRequestDescriptor instead')
const TrustPeerRequest$json = const {
  '1': 'TrustPeerRequest',
  '2': const [
    const {'1': 'peer_id', '3': 1, '4': 1, '5': 9, '10': 'peerId'},
  ],
};

/// Descriptor for `TrustPeerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trustPeerRequestDescriptor = $convert.base64Decode('ChBUcnVzdFBlZXJSZXF1ZXN0EhcKB3BlZXJfaWQYASABKAlSBnBlZXJJZA==');
@$core.Deprecated('Use untrustPeerRequestDescriptor instead')
const UntrustPeerRequest$json = const {
  '1': 'UntrustPeerRequest',
  '2': const [
    const {'1': 'peer_id', '3': 1, '4': 1, '5': 9, '10': 'peerId'},
  ],
};

/// Descriptor for `UntrustPeerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List untrustPeerRequestDescriptor = $convert.base64Decode('ChJVbnRydXN0UGVlclJlcXVlc3QSFwoHcGVlcl9pZBgBIAEoCVIGcGVlcklk');
@$core.Deprecated('Use removePeerRequestDescriptor instead')
const RemovePeerRequest$json = const {
  '1': 'RemovePeerRequest',
  '2': const [
    const {'1': 'peer_id', '3': 1, '4': 1, '5': 9, '10': 'peerId'},
  ],
};

/// Descriptor for `RemovePeerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removePeerRequestDescriptor = $convert.base64Decode('ChFSZW1vdmVQZWVyUmVxdWVzdBIXCgdwZWVyX2lkGAEgASgJUgZwZWVySWQ=');
