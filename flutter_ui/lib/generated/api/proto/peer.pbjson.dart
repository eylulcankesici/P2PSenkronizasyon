// This is a generated file - do not edit.
//
// Generated from api/proto/peer.proto.

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

@$core.Deprecated('Use peerDescriptor instead')
const Peer$json = {
  '1': 'Peer',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'known_addresses', '3': 3, '4': 3, '5': 9, '10': 'knownAddresses'},
    {'1': 'is_trusted', '3': 4, '4': 1, '5': 8, '10': 'isTrusted'},
    {
      '1': 'last_seen',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastSeen'
    },
    {
      '1': 'status',
      '3': 6,
      '4': 1,
      '5': 14,
      '6': '.aether.api.PeerStatus',
      '10': 'status'
    },
    {'1': 'public_key', '3': 7, '4': 1, '5': 9, '10': 'publicKey'},
    {
      '1': 'created_at',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'createdAt'
    },
    {
      '1': 'updated_at',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'updatedAt'
    },
    {'1': 'public_ip', '3': 10, '4': 1, '5': 9, '10': 'publicIp'},
    {'1': 'nat_type', '3': 11, '4': 1, '5': 9, '10': 'natType'},
    {'1': 'wan_supported', '3': 12, '4': 1, '5': 8, '10': 'wanSupported'},
    {'1': 'ice_candidates', '3': 13, '4': 3, '5': 9, '10': 'iceCandidates'},
  ],
};

/// Descriptor for `Peer`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List peerDescriptor = $convert.base64Decode(
    'CgRQZWVyEhsKCWRldmljZV9pZBgBIAEoCVIIZGV2aWNlSWQSEgoEbmFtZRgCIAEoCVIEbmFtZR'
    'InCg9rbm93bl9hZGRyZXNzZXMYAyADKAlSDmtub3duQWRkcmVzc2VzEh0KCmlzX3RydXN0ZWQY'
    'BCABKAhSCWlzVHJ1c3RlZBI3CglsYXN0X3NlZW4YBSABKAsyGi5nb29nbGUucHJvdG9idWYuVG'
    'ltZXN0YW1wUghsYXN0U2VlbhIuCgZzdGF0dXMYBiABKA4yFi5hZXRoZXIuYXBpLlBlZXJTdGF0'
    'dXNSBnN0YXR1cxIdCgpwdWJsaWNfa2V5GAcgASgJUglwdWJsaWNLZXkSOQoKY3JlYXRlZF9hdB'
    'gIIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVk'
    'X2F0GAkgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0EhsKCXB1Ym'
    'xpY19pcBgKIAEoCVIIcHVibGljSXASGQoIbmF0X3R5cGUYCyABKAlSB25hdFR5cGUSIwoNd2Fu'
    'X3N1cHBvcnRlZBgMIAEoCFIMd2FuU3VwcG9ydGVkEiUKDmljZV9jYW5kaWRhdGVzGA0gAygJUg'
    '1pY2VDYW5kaWRhdGVz');

@$core.Deprecated('Use discoverPeersRequestDescriptor instead')
const DiscoverPeersRequest$json = {
  '1': 'DiscoverPeersRequest',
  '2': [
    {'1': 'lan_only', '3': 1, '4': 1, '5': 8, '10': 'lanOnly'},
    {'1': 'wan_only', '3': 2, '4': 1, '5': 8, '10': 'wanOnly'},
  ],
};

/// Descriptor for `DiscoverPeersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discoverPeersRequestDescriptor = $convert.base64Decode(
    'ChREaXNjb3ZlclBlZXJzUmVxdWVzdBIZCghsYW5fb25seRgBIAEoCFIHbGFuT25seRIZCgh3YW'
    '5fb25seRgCIAEoCFIHd2FuT25seQ==');

@$core.Deprecated('Use discoverPeersResponseDescriptor instead')
const DiscoverPeersResponse$json = {
  '1': 'DiscoverPeersResponse',
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
      '1': 'peers',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.aether.api.Peer',
      '10': 'peers'
    },
  ],
};

/// Descriptor for `DiscoverPeersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List discoverPeersResponseDescriptor = $convert.base64Decode(
    'ChVEaXNjb3ZlclBlZXJzUmVzcG9uc2USKgoGc3RhdHVzGAEgASgLMhIuYWV0aGVyLmFwaS5TdG'
    'F0dXNSBnN0YXR1cxImCgVwZWVycxgCIAMoCzIQLmFldGhlci5hcGkuUGVlclIFcGVlcnM=');

@$core.Deprecated('Use connectToPeerRequestDescriptor instead')
const ConnectToPeerRequest$json = {
  '1': 'ConnectToPeerRequest',
  '2': [
    {'1': 'peer_id', '3': 1, '4': 1, '5': 9, '10': 'peerId'},
    {'1': 'transport_type', '3': 2, '4': 1, '5': 9, '10': 'transportType'},
  ],
};

/// Descriptor for `ConnectToPeerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectToPeerRequestDescriptor = $convert.base64Decode(
    'ChRDb25uZWN0VG9QZWVyUmVxdWVzdBIXCgdwZWVyX2lkGAEgASgJUgZwZWVySWQSJQoOdHJhbn'
    'Nwb3J0X3R5cGUYAiABKAlSDXRyYW5zcG9ydFR5cGU=');

@$core.Deprecated('Use disconnectFromPeerRequestDescriptor instead')
const DisconnectFromPeerRequest$json = {
  '1': 'DisconnectFromPeerRequest',
  '2': [
    {'1': 'peer_id', '3': 1, '4': 1, '5': 9, '10': 'peerId'},
  ],
};

/// Descriptor for `DisconnectFromPeerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List disconnectFromPeerRequestDescriptor =
    $convert.base64Decode(
        'ChlEaXNjb25uZWN0RnJvbVBlZXJSZXF1ZXN0EhcKB3BlZXJfaWQYASABKAlSBnBlZXJJZA==');

@$core.Deprecated('Use listPeersRequestDescriptor instead')
const ListPeersRequest$json = {
  '1': 'ListPeersRequest',
  '2': [
    {'1': 'online_only', '3': 1, '4': 1, '5': 8, '10': 'onlineOnly'},
    {'1': 'trusted_only', '3': 2, '4': 1, '5': 8, '10': 'trustedOnly'},
    {
      '1': 'pagination',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.aether.api.PaginationRequest',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ListPeersRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPeersRequestDescriptor = $convert.base64Decode(
    'ChBMaXN0UGVlcnNSZXF1ZXN0Eh8KC29ubGluZV9vbmx5GAEgASgIUgpvbmxpbmVPbmx5EiEKDH'
    'RydXN0ZWRfb25seRgCIAEoCFILdHJ1c3RlZE9ubHkSPQoKcGFnaW5hdGlvbhgDIAEoCzIdLmFl'
    'dGhlci5hcGkuUGFnaW5hdGlvblJlcXVlc3RSCnBhZ2luYXRpb24=');

@$core.Deprecated('Use listPeersResponseDescriptor instead')
const ListPeersResponse$json = {
  '1': 'ListPeersResponse',
  '2': [
    {
      '1': 'peers',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.aether.api.Peer',
      '10': 'peers'
    },
    {
      '1': 'pagination',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.aether.api.PaginationResponse',
      '10': 'pagination'
    },
  ],
};

/// Descriptor for `ListPeersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List listPeersResponseDescriptor = $convert.base64Decode(
    'ChFMaXN0UGVlcnNSZXNwb25zZRImCgVwZWVycxgBIAMoCzIQLmFldGhlci5hcGkuUGVlclIFcG'
    'VlcnMSPgoKcGFnaW5hdGlvbhgCIAEoCzIeLmFldGhlci5hcGkuUGFnaW5hdGlvblJlc3BvbnNl'
    'UgpwYWdpbmF0aW9u');

@$core.Deprecated('Use getPeerInfoRequestDescriptor instead')
const GetPeerInfoRequest$json = {
  '1': 'GetPeerInfoRequest',
  '2': [
    {'1': 'peer_id', '3': 1, '4': 1, '5': 9, '10': 'peerId'},
  ],
};

/// Descriptor for `GetPeerInfoRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPeerInfoRequestDescriptor =
    $convert.base64Decode(
        'ChJHZXRQZWVySW5mb1JlcXVlc3QSFwoHcGVlcl9pZBgBIAEoCVIGcGVlcklk');

@$core.Deprecated('Use peerInfoResponseDescriptor instead')
const PeerInfoResponse$json = {
  '1': 'PeerInfoResponse',
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
      '1': 'peer',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.aether.api.Peer',
      '10': 'peer'
    },
    {'1': 'shared_folders', '3': 3, '4': 3, '5': 9, '10': 'sharedFolders'},
    {'1': 'shared_files', '3': 4, '4': 1, '5': 5, '10': 'sharedFiles'},
    {'1': 'total_chunks', '3': 5, '4': 1, '5': 5, '10': 'totalChunks'},
    {
      '1': 'last_activity',
      '3': 6,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Timestamp',
      '10': 'lastActivity'
    },
    {'1': 'connection_type', '3': 7, '4': 1, '5': 9, '10': 'connectionType'},
    {'1': 'latency_ms', '3': 8, '4': 1, '5': 3, '10': 'latencyMs'},
    {
      '1': 'wan_info',
      '3': 9,
      '4': 1,
      '5': 11,
      '6': '.aether.api.WANConnectionInfo',
      '10': 'wanInfo'
    },
  ],
};

/// Descriptor for `PeerInfoResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List peerInfoResponseDescriptor = $convert.base64Decode(
    'ChBQZWVySW5mb1Jlc3BvbnNlEioKBnN0YXR1cxgBIAEoCzISLmFldGhlci5hcGkuU3RhdHVzUg'
    'ZzdGF0dXMSJAoEcGVlchgCIAEoCzIQLmFldGhlci5hcGkuUGVlclIEcGVlchIlCg5zaGFyZWRf'
    'Zm9sZGVycxgDIAMoCVINc2hhcmVkRm9sZGVycxIhCgxzaGFyZWRfZmlsZXMYBCABKAVSC3NoYX'
    'JlZEZpbGVzEiEKDHRvdGFsX2NodW5rcxgFIAEoBVILdG90YWxDaHVua3MSPwoNbGFzdF9hY3Rp'
    'dml0eRgGIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSDGxhc3RBY3Rpdml0eRInCg'
    '9jb25uZWN0aW9uX3R5cGUYByABKAlSDmNvbm5lY3Rpb25UeXBlEh0KCmxhdGVuY3lfbXMYCCAB'
    'KANSCWxhdGVuY3lNcxI4Cgh3YW5faW5mbxgJIAEoCzIdLmFldGhlci5hcGkuV0FOQ29ubmVjdG'
    'lvbkluZm9SB3dhbkluZm8=');

@$core.Deprecated('Use wANConnectionInfoDescriptor instead')
const WANConnectionInfo$json = {
  '1': 'WANConnectionInfo',
  '2': [
    {'1': 'public_ip', '3': 1, '4': 1, '5': 9, '10': 'publicIp'},
    {'1': 'nat_type', '3': 2, '4': 1, '5': 9, '10': 'natType'},
    {'1': 'stun_servers', '3': 3, '4': 3, '5': 9, '10': 'stunServers'},
    {'1': 'turn_available', '3': 4, '4': 1, '5': 8, '10': 'turnAvailable'},
    {
      '1': 'connection_establishment_time_ms',
      '3': 5,
      '4': 1,
      '5': 3,
      '10': 'connectionEstablishmentTimeMs'
    },
  ],
};

/// Descriptor for `WANConnectionInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List wANConnectionInfoDescriptor = $convert.base64Decode(
    'ChFXQU5Db25uZWN0aW9uSW5mbxIbCglwdWJsaWNfaXAYASABKAlSCHB1YmxpY0lwEhkKCG5hdF'
    '90eXBlGAIgASgJUgduYXRUeXBlEiEKDHN0dW5fc2VydmVycxgDIAMoCVILc3R1blNlcnZlcnMS'
    'JQoOdHVybl9hdmFpbGFibGUYBCABKAhSDXR1cm5BdmFpbGFibGUSRwogY29ubmVjdGlvbl9lc3'
    'RhYmxpc2htZW50X3RpbWVfbXMYBSABKANSHWNvbm5lY3Rpb25Fc3RhYmxpc2htZW50VGltZU1z');

@$core.Deprecated('Use trustPeerRequestDescriptor instead')
const TrustPeerRequest$json = {
  '1': 'TrustPeerRequest',
  '2': [
    {'1': 'peer_id', '3': 1, '4': 1, '5': 9, '10': 'peerId'},
  ],
};

/// Descriptor for `TrustPeerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trustPeerRequestDescriptor = $convert.base64Decode(
    'ChBUcnVzdFBlZXJSZXF1ZXN0EhcKB3BlZXJfaWQYASABKAlSBnBlZXJJZA==');

@$core.Deprecated('Use untrustPeerRequestDescriptor instead')
const UntrustPeerRequest$json = {
  '1': 'UntrustPeerRequest',
  '2': [
    {'1': 'peer_id', '3': 1, '4': 1, '5': 9, '10': 'peerId'},
  ],
};

/// Descriptor for `UntrustPeerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List untrustPeerRequestDescriptor =
    $convert.base64Decode(
        'ChJVbnRydXN0UGVlclJlcXVlc3QSFwoHcGVlcl9pZBgBIAEoCVIGcGVlcklk');

@$core.Deprecated('Use removePeerRequestDescriptor instead')
const RemovePeerRequest$json = {
  '1': 'RemovePeerRequest',
  '2': [
    {'1': 'peer_id', '3': 1, '4': 1, '5': 9, '10': 'peerId'},
  ],
};

/// Descriptor for `RemovePeerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List removePeerRequestDescriptor = $convert.base64Decode(
    'ChFSZW1vdmVQZWVyUmVxdWVzdBIXCgdwZWVyX2lkGAEgASgJUgZwZWVySWQ=');

@$core.Deprecated('Use getPendingConnectionsRequestDescriptor instead')
const GetPendingConnectionsRequest$json = {
  '1': 'GetPendingConnectionsRequest',
};

/// Descriptor for `GetPendingConnectionsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPendingConnectionsRequestDescriptor =
    $convert.base64Decode('ChxHZXRQZW5kaW5nQ29ubmVjdGlvbnNSZXF1ZXN0');

@$core.Deprecated('Use getPendingConnectionsResponseDescriptor instead')
const GetPendingConnectionsResponse$json = {
  '1': 'GetPendingConnectionsResponse',
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
      '1': 'pending_connections',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.aether.api.PendingConnection',
      '10': 'pendingConnections'
    },
  ],
};

/// Descriptor for `GetPendingConnectionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getPendingConnectionsResponseDescriptor =
    $convert.base64Decode(
        'Ch1HZXRQZW5kaW5nQ29ubmVjdGlvbnNSZXNwb25zZRIqCgZzdGF0dXMYASABKAsyEi5hZXRoZX'
        'IuYXBpLlN0YXR1c1IGc3RhdHVzEk4KE3BlbmRpbmdfY29ubmVjdGlvbnMYAiADKAsyHS5hZXRo'
        'ZXIuYXBpLlBlbmRpbmdDb25uZWN0aW9uUhJwZW5kaW5nQ29ubmVjdGlvbnM=');

@$core.Deprecated('Use pendingConnectionDescriptor instead')
const PendingConnection$json = {
  '1': 'PendingConnection',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'device_name', '3': 2, '4': 1, '5': 9, '10': 'deviceName'},
    {'1': 'timestamp', '3': 3, '4': 1, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `PendingConnection`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pendingConnectionDescriptor = $convert.base64Decode(
    'ChFQZW5kaW5nQ29ubmVjdGlvbhIbCglkZXZpY2VfaWQYASABKAlSCGRldmljZUlkEh8KC2Rldm'
    'ljZV9uYW1lGAIgASgJUgpkZXZpY2VOYW1lEhwKCXRpbWVzdGFtcBgDIAEoA1IJdGltZXN0YW1w');

@$core.Deprecated('Use acceptConnectionRequestDescriptor instead')
const AcceptConnectionRequest$json = {
  '1': 'AcceptConnectionRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `AcceptConnectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List acceptConnectionRequestDescriptor =
    $convert.base64Decode(
        'ChdBY2NlcHRDb25uZWN0aW9uUmVxdWVzdBIbCglkZXZpY2VfaWQYASABKAlSCGRldmljZUlk');

@$core.Deprecated('Use rejectConnectionRequestDescriptor instead')
const RejectConnectionRequest$json = {
  '1': 'RejectConnectionRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'reason', '3': 2, '4': 1, '5': 9, '10': 'reason'},
  ],
};

/// Descriptor for `RejectConnectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rejectConnectionRequestDescriptor =
    $convert.base64Decode(
        'ChdSZWplY3RDb25uZWN0aW9uUmVxdWVzdBIbCglkZXZpY2VfaWQYASABKAlSCGRldmljZUlkEh'
        'YKBnJlYXNvbhgCIAEoCVIGcmVhc29u');

@$core.Deprecated('Use createInvitationRequestDescriptor instead')
const CreateInvitationRequest$json = {
  '1': 'CreateInvitationRequest',
  '2': [
    {'1': 'expiry_hours', '3': 1, '4': 1, '5': 5, '10': 'expiryHours'},
  ],
};

/// Descriptor for `CreateInvitationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createInvitationRequestDescriptor =
    $convert.base64Decode(
        'ChdDcmVhdGVJbnZpdGF0aW9uUmVxdWVzdBIhCgxleHBpcnlfaG91cnMYASABKAVSC2V4cGlyeU'
        'hvdXJz');

@$core.Deprecated('Use createInvitationResponseDescriptor instead')
const CreateInvitationResponse$json = {
  '1': 'CreateInvitationResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.aether.api.Status',
      '10': 'status'
    },
    {'1': 'invitation_code', '3': 2, '4': 1, '5': 9, '10': 'invitationCode'},
    {'1': 'invitation_link', '3': 3, '4': 1, '5': 9, '10': 'invitationLink'},
    {'1': 'qr_code_image', '3': 4, '4': 1, '5': 9, '10': 'qrCodeImage'},
    {'1': 'expires_at', '3': 5, '4': 1, '5': 3, '10': 'expiresAt'},
  ],
};

/// Descriptor for `CreateInvitationResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createInvitationResponseDescriptor = $convert.base64Decode(
    'ChhDcmVhdGVJbnZpdGF0aW9uUmVzcG9uc2USKgoGc3RhdHVzGAEgASgLMhIuYWV0aGVyLmFwaS'
    '5TdGF0dXNSBnN0YXR1cxInCg9pbnZpdGF0aW9uX2NvZGUYAiABKAlSDmludml0YXRpb25Db2Rl'
    'EicKD2ludml0YXRpb25fbGluaxgDIAEoCVIOaW52aXRhdGlvbkxpbmsSIgoNcXJfY29kZV9pbW'
    'FnZRgEIAEoCVILcXJDb2RlSW1hZ2USHQoKZXhwaXJlc19hdBgFIAEoA1IJZXhwaXJlc0F0');

@$core.Deprecated('Use addPeerByInvitationRequestDescriptor instead')
const AddPeerByInvitationRequest$json = {
  '1': 'AddPeerByInvitationRequest',
  '2': [
    {'1': 'invitation_code', '3': 1, '4': 1, '5': 9, '10': 'invitationCode'},
  ],
};

/// Descriptor for `AddPeerByInvitationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addPeerByInvitationRequestDescriptor =
    $convert.base64Decode(
        'ChpBZGRQZWVyQnlJbnZpdGF0aW9uUmVxdWVzdBInCg9pbnZpdGF0aW9uX2NvZGUYASABKAlSDm'
        'ludml0YXRpb25Db2Rl');

@$core.Deprecated('Use addWANPeerRequestDescriptor instead')
const AddWANPeerRequest$json = {
  '1': 'AddWANPeerRequest',
  '2': [
    {'1': 'peer_id', '3': 1, '4': 1, '5': 9, '10': 'peerId'},
    {'1': 'peer_name', '3': 2, '4': 1, '5': 9, '10': 'peerName'},
    {'1': 'public_ip', '3': 3, '4': 1, '5': 9, '10': 'publicIp'},
    {'1': 'ice_candidates', '3': 4, '4': 3, '5': 9, '10': 'iceCandidates'},
  ],
};

/// Descriptor for `AddWANPeerRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addWANPeerRequestDescriptor = $convert.base64Decode(
    'ChFBZGRXQU5QZWVyUmVxdWVzdBIXCgdwZWVyX2lkGAEgASgJUgZwZWVySWQSGwoJcGVlcl9uYW'
    '1lGAIgASgJUghwZWVyTmFtZRIbCglwdWJsaWNfaXAYAyABKAlSCHB1YmxpY0lwEiUKDmljZV9j'
    'YW5kaWRhdGVzGAQgAygJUg1pY2VDYW5kaWRhdGVz');

@$core.Deprecated('Use exchangeSDPRequestDescriptor instead')
const ExchangeSDPRequest$json = {
  '1': 'ExchangeSDPRequest',
  '2': [
    {'1': 'peer_id', '3': 1, '4': 1, '5': 9, '10': 'peerId'},
    {'1': 'sdp_type', '3': 2, '4': 1, '5': 9, '10': 'sdpType'},
    {'1': 'sdp', '3': 3, '4': 1, '5': 9, '10': 'sdp'},
  ],
};

/// Descriptor for `ExchangeSDPRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exchangeSDPRequestDescriptor = $convert.base64Decode(
    'ChJFeGNoYW5nZVNEUFJlcXVlc3QSFwoHcGVlcl9pZBgBIAEoCVIGcGVlcklkEhkKCHNkcF90eX'
    'BlGAIgASgJUgdzZHBUeXBlEhAKA3NkcBgDIAEoCVIDc2Rw');

@$core.Deprecated('Use exchangeSDPResponseDescriptor instead')
const ExchangeSDPResponse$json = {
  '1': 'ExchangeSDPResponse',
  '2': [
    {
      '1': 'status',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.aether.api.Status',
      '10': 'status'
    },
    {'1': 'sdp_type', '3': 2, '4': 1, '5': 9, '10': 'sdpType'},
    {'1': 'sdp', '3': 3, '4': 1, '5': 9, '10': 'sdp'},
  ],
};

/// Descriptor for `ExchangeSDPResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List exchangeSDPResponseDescriptor = $convert.base64Decode(
    'ChNFeGNoYW5nZVNEUFJlc3BvbnNlEioKBnN0YXR1cxgBIAEoCzISLmFldGhlci5hcGkuU3RhdH'
    'VzUgZzdGF0dXMSGQoIc2RwX3R5cGUYAiABKAlSB3NkcFR5cGUSEAoDc2RwGAMgASgJUgNzZHA=');

@$core.Deprecated('Use connectionRequestDescriptor instead')
const ConnectionRequest$json = {
  '1': 'ConnectionRequest',
  '2': [
    {'1': 'device_id', '3': 1, '4': 1, '5': 9, '10': 'deviceId'},
    {'1': 'device_name', '3': 2, '4': 1, '5': 9, '10': 'deviceName'},
    {'1': 'timestamp', '3': 3, '4': 1, '5': 3, '10': 'timestamp'},
  ],
};

/// Descriptor for `ConnectionRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionRequestDescriptor = $convert.base64Decode(
    'ChFDb25uZWN0aW9uUmVxdWVzdBIbCglkZXZpY2VfaWQYASABKAlSCGRldmljZUlkEh8KC2Rldm'
    'ljZV9uYW1lGAIgASgJUgpkZXZpY2VOYW1lEhwKCXRpbWVzdGFtcBgDIAEoA1IJdGltZXN0YW1w');

@$core.Deprecated('Use connectionResponseDescriptor instead')
const ConnectionResponse$json = {
  '1': 'ConnectionResponse',
  '2': [
    {'1': 'accepted', '3': 1, '4': 1, '5': 8, '10': 'accepted'},
    {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    {'1': 'device_id', '3': 3, '4': 1, '5': 9, '10': 'deviceId'},
  ],
};

/// Descriptor for `ConnectionResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List connectionResponseDescriptor = $convert.base64Decode(
    'ChJDb25uZWN0aW9uUmVzcG9uc2USGgoIYWNjZXB0ZWQYASABKAhSCGFjY2VwdGVkEhgKB21lc3'
    'NhZ2UYAiABKAlSB21lc3NhZ2USGwoJZGV2aWNlX2lkGAMgASgJUghkZXZpY2VJZA==');
