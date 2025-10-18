///
//  Generated code. Do not modify.
//  source: api/proto/sync.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class SyncEvent_EventType extends $pb.ProtobufEnum {
  static const SyncEvent_EventType EVENT_TYPE_UNSPECIFIED = SyncEvent_EventType._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EVENT_TYPE_UNSPECIFIED');
  static const SyncEvent_EventType EVENT_TYPE_FILE_ADDED = SyncEvent_EventType._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EVENT_TYPE_FILE_ADDED');
  static const SyncEvent_EventType EVENT_TYPE_FILE_MODIFIED = SyncEvent_EventType._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EVENT_TYPE_FILE_MODIFIED');
  static const SyncEvent_EventType EVENT_TYPE_FILE_DELETED = SyncEvent_EventType._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EVENT_TYPE_FILE_DELETED');
  static const SyncEvent_EventType EVENT_TYPE_SYNC_STARTED = SyncEvent_EventType._(4, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EVENT_TYPE_SYNC_STARTED');
  static const SyncEvent_EventType EVENT_TYPE_SYNC_COMPLETED = SyncEvent_EventType._(5, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EVENT_TYPE_SYNC_COMPLETED');
  static const SyncEvent_EventType EVENT_TYPE_SYNC_FAILED = SyncEvent_EventType._(6, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'EVENT_TYPE_SYNC_FAILED');

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

