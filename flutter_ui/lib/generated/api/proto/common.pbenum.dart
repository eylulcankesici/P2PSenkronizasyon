///
//  Generated code. Do not modify.
//  source: api/proto/common.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class SyncMode extends $pb.ProtobufEnum {
  static const SyncMode SYNC_MODE_UNSPECIFIED = SyncMode._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SYNC_MODE_UNSPECIFIED');
  static const SyncMode SYNC_MODE_BIDIRECTIONAL = SyncMode._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SYNC_MODE_BIDIRECTIONAL');
  static const SyncMode SYNC_MODE_SEND_ONLY = SyncMode._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SYNC_MODE_SEND_ONLY');
  static const SyncMode SYNC_MODE_RECEIVE_ONLY = SyncMode._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SYNC_MODE_RECEIVE_ONLY');

  static const $core.List<SyncMode> values = <SyncMode> [
    SYNC_MODE_UNSPECIFIED,
    SYNC_MODE_BIDIRECTIONAL,
    SYNC_MODE_SEND_ONLY,
    SYNC_MODE_RECEIVE_ONLY,
  ];

  static final $core.Map<$core.int, SyncMode> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SyncMode? valueOf($core.int value) => _byValue[value];

  const SyncMode._($core.int v, $core.String n) : super(v, n);
}

class PeerStatus extends $pb.ProtobufEnum {
  static const PeerStatus PEER_STATUS_UNKNOWN = PeerStatus._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PEER_STATUS_UNKNOWN');
  static const PeerStatus PEER_STATUS_ONLINE = PeerStatus._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PEER_STATUS_ONLINE');
  static const PeerStatus PEER_STATUS_OFFLINE = PeerStatus._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PEER_STATUS_OFFLINE');
  static const PeerStatus PEER_STATUS_CONNECTING = PeerStatus._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PEER_STATUS_CONNECTING');

  static const $core.List<PeerStatus> values = <PeerStatus> [
    PEER_STATUS_UNKNOWN,
    PEER_STATUS_ONLINE,
    PEER_STATUS_OFFLINE,
    PEER_STATUS_CONNECTING,
  ];

  static final $core.Map<$core.int, PeerStatus> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PeerStatus? valueOf($core.int value) => _byValue[value];

  const PeerStatus._($core.int v, $core.String n) : super(v, n);
}

class UserRole extends $pb.ProtobufEnum {
  static const UserRole USER_ROLE_STANDARD = UserRole._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'USER_ROLE_STANDARD');
  static const UserRole USER_ROLE_ADMIN = UserRole._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'USER_ROLE_ADMIN');

  static const $core.List<UserRole> values = <UserRole> [
    USER_ROLE_STANDARD,
    USER_ROLE_ADMIN,
  ];

  static final $core.Map<$core.int, UserRole> _byValue = $pb.ProtobufEnum.initByValue(values);
  static UserRole? valueOf($core.int value) => _byValue[value];

  const UserRole._($core.int v, $core.String n) : super(v, n);
}

