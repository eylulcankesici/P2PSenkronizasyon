//
//  Generated code. Do not modify.
//  source: api/proto/sync.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class SyncEvent_EventType extends $pb.ProtobufEnum {
  static const SyncEvent_EventType EVENT_TYPE_UNSPECIFIED = SyncEvent_EventType._(0, _omitEnumNames ? '' : 'EVENT_TYPE_UNSPECIFIED');
  static const SyncEvent_EventType EVENT_TYPE_FILE_ADDED = SyncEvent_EventType._(1, _omitEnumNames ? '' : 'EVENT_TYPE_FILE_ADDED');
  static const SyncEvent_EventType EVENT_TYPE_FILE_MODIFIED = SyncEvent_EventType._(2, _omitEnumNames ? '' : 'EVENT_TYPE_FILE_MODIFIED');
  static const SyncEvent_EventType EVENT_TYPE_FILE_DELETED = SyncEvent_EventType._(3, _omitEnumNames ? '' : 'EVENT_TYPE_FILE_DELETED');
  static const SyncEvent_EventType EVENT_TYPE_SYNC_STARTED = SyncEvent_EventType._(4, _omitEnumNames ? '' : 'EVENT_TYPE_SYNC_STARTED');
  static const SyncEvent_EventType EVENT_TYPE_SYNC_COMPLETED = SyncEvent_EventType._(5, _omitEnumNames ? '' : 'EVENT_TYPE_SYNC_COMPLETED');
  static const SyncEvent_EventType EVENT_TYPE_SYNC_FAILED = SyncEvent_EventType._(6, _omitEnumNames ? '' : 'EVENT_TYPE_SYNC_FAILED');

  static const $core.List<SyncEvent_EventType> values = <SyncEvent_EventType> [
    EVENT_TYPE_UNSPECIFIED,
    EVENT_TYPE_FILE_ADDED,
    EVENT_TYPE_FILE_MODIFIED,
    EVENT_TYPE_FILE_DELETED,
    EVENT_TYPE_SYNC_STARTED,
    EVENT_TYPE_SYNC_COMPLETED,
    EVENT_TYPE_SYNC_FAILED,
  ];

  static final $core.Map<$core.int, SyncEvent_EventType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SyncEvent_EventType? valueOf($core.int value) => _byValue[value];

  const SyncEvent_EventType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
