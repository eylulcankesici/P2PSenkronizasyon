// This is a generated file - do not edit.
//
// Generated from api/proto/p2p.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class TransferDirection extends $pb.ProtobufEnum {
  static const TransferDirection TRANSFER_DIRECTION_UNSPECIFIED =
      TransferDirection._(
          0, _omitEnumNames ? '' : 'TRANSFER_DIRECTION_UNSPECIFIED');
  static const TransferDirection TRANSFER_DIRECTION_SEND =
      TransferDirection._(1, _omitEnumNames ? '' : 'TRANSFER_DIRECTION_SEND');
  static const TransferDirection TRANSFER_DIRECTION_RECEIVE =
      TransferDirection._(
          2, _omitEnumNames ? '' : 'TRANSFER_DIRECTION_RECEIVE');

  static const $core.List<TransferDirection> values = <TransferDirection>[
    TRANSFER_DIRECTION_UNSPECIFIED,
    TRANSFER_DIRECTION_SEND,
    TRANSFER_DIRECTION_RECEIVE,
  ];

  static final $core.List<TransferDirection?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static TransferDirection? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TransferDirection._(super.value, super.name);
}

class TransferState extends $pb.ProtobufEnum {
  static const TransferState TRANSFER_STATE_UNSPECIFIED =
      TransferState._(0, _omitEnumNames ? '' : 'TRANSFER_STATE_UNSPECIFIED');
  static const TransferState TRANSFER_STATE_ACTIVE =
      TransferState._(1, _omitEnumNames ? '' : 'TRANSFER_STATE_ACTIVE');
  static const TransferState TRANSFER_STATE_COMPLETED =
      TransferState._(2, _omitEnumNames ? '' : 'TRANSFER_STATE_COMPLETED');
  static const TransferState TRANSFER_STATE_FAILED =
      TransferState._(3, _omitEnumNames ? '' : 'TRANSFER_STATE_FAILED');
  static const TransferState TRANSFER_STATE_CANCELLED =
      TransferState._(4, _omitEnumNames ? '' : 'TRANSFER_STATE_CANCELLED');

  static const $core.List<TransferState> values = <TransferState>[
    TRANSFER_STATE_UNSPECIFIED,
    TRANSFER_STATE_ACTIVE,
    TRANSFER_STATE_COMPLETED,
    TRANSFER_STATE_FAILED,
    TRANSFER_STATE_CANCELLED,
  ];

  static final $core.List<TransferState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static TransferState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const TransferState._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
