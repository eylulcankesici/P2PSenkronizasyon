// This is a generated file - do not edit.
//
// Generated from api/proto/common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SyncMode extends $pb.ProtobufEnum {
  static const SyncMode SYNC_MODE_UNSPECIFIED =
      SyncMode._(0, _omitEnumNames ? '' : 'SYNC_MODE_UNSPECIFIED');
  static const SyncMode SYNC_MODE_BIDIRECTIONAL =
      SyncMode._(1, _omitEnumNames ? '' : 'SYNC_MODE_BIDIRECTIONAL');
  static const SyncMode SYNC_MODE_SEND_ONLY =
      SyncMode._(2, _omitEnumNames ? '' : 'SYNC_MODE_SEND_ONLY');
  static const SyncMode SYNC_MODE_RECEIVE_ONLY =
      SyncMode._(3, _omitEnumNames ? '' : 'SYNC_MODE_RECEIVE_ONLY');

  static const $core.List<SyncMode> values = <SyncMode>[
    SYNC_MODE_UNSPECIFIED,
    SYNC_MODE_BIDIRECTIONAL,
    SYNC_MODE_SEND_ONLY,
    SYNC_MODE_RECEIVE_ONLY,
  ];

  static final $core.List<SyncMode?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static SyncMode? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SyncMode._(super.value, super.name);
}

class PeerStatus extends $pb.ProtobufEnum {
  static const PeerStatus PEER_STATUS_UNKNOWN =
      PeerStatus._(0, _omitEnumNames ? '' : 'PEER_STATUS_UNKNOWN');
  static const PeerStatus PEER_STATUS_ONLINE =
      PeerStatus._(1, _omitEnumNames ? '' : 'PEER_STATUS_ONLINE');
  static const PeerStatus PEER_STATUS_OFFLINE =
      PeerStatus._(2, _omitEnumNames ? '' : 'PEER_STATUS_OFFLINE');
  static const PeerStatus PEER_STATUS_CONNECTING =
      PeerStatus._(3, _omitEnumNames ? '' : 'PEER_STATUS_CONNECTING');

  static const $core.List<PeerStatus> values = <PeerStatus>[
    PEER_STATUS_UNKNOWN,
    PEER_STATUS_ONLINE,
    PEER_STATUS_OFFLINE,
    PEER_STATUS_CONNECTING,
  ];

  static final $core.List<PeerStatus?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static PeerStatus? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PeerStatus._(super.value, super.name);
}

class UserRole extends $pb.ProtobufEnum {
  static const UserRole USER_ROLE_STANDARD =
      UserRole._(0, _omitEnumNames ? '' : 'USER_ROLE_STANDARD');
  static const UserRole USER_ROLE_ADMIN =
      UserRole._(1, _omitEnumNames ? '' : 'USER_ROLE_ADMIN');

  static const $core.List<UserRole> values = <UserRole>[
    USER_ROLE_STANDARD,
    USER_ROLE_ADMIN,
  ];

  static final $core.List<UserRole?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static UserRole? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const UserRole._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
