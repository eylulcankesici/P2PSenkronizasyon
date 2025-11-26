// This is a generated file - do not edit.
//
// Generated from api/proto/sync.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SyncEvent_EventType extends $pb.ProtobufEnum {
  static const SyncEvent_EventType EVENT_TYPE_UNSPECIFIED =
      SyncEvent_EventType._(0, _omitEnumNames ? '' : 'EVENT_TYPE_UNSPECIFIED');
  static const SyncEvent_EventType EVENT_TYPE_FILE_ADDED =
      SyncEvent_EventType._(1, _omitEnumNames ? '' : 'EVENT_TYPE_FILE_ADDED');
  static const SyncEvent_EventType EVENT_TYPE_FILE_MODIFIED =
      SyncEvent_EventType._(
          2, _omitEnumNames ? '' : 'EVENT_TYPE_FILE_MODIFIED');
  static const SyncEvent_EventType EVENT_TYPE_FILE_DELETED =
      SyncEvent_EventType._(3, _omitEnumNames ? '' : 'EVENT_TYPE_FILE_DELETED');
  static const SyncEvent_EventType EVENT_TYPE_SYNC_STARTED =
      SyncEvent_EventType._(4, _omitEnumNames ? '' : 'EVENT_TYPE_SYNC_STARTED');
  static const SyncEvent_EventType EVENT_TYPE_SYNC_COMPLETED =
      SyncEvent_EventType._(
          5, _omitEnumNames ? '' : 'EVENT_TYPE_SYNC_COMPLETED');
  static const SyncEvent_EventType EVENT_TYPE_SYNC_FAILED =
      SyncEvent_EventType._(6, _omitEnumNames ? '' : 'EVENT_TYPE_SYNC_FAILED');

  static const $core.List<SyncEvent_EventType> values = <SyncEvent_EventType>[
    EVENT_TYPE_UNSPECIFIED,
    EVENT_TYPE_FILE_ADDED,
    EVENT_TYPE_FILE_MODIFIED,
    EVENT_TYPE_FILE_DELETED,
    EVENT_TYPE_SYNC_STARTED,
    EVENT_TYPE_SYNC_COMPLETED,
    EVENT_TYPE_SYNC_FAILED,
  ];

  static final $core.List<SyncEvent_EventType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static SyncEvent_EventType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const SyncEvent_EventType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
