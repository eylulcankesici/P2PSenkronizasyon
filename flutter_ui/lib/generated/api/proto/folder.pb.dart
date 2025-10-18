///
//  Generated code. Do not modify.
//  source: api/proto/folder.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $3;
import 'common.pb.dart' as $1;

import 'common.pbenum.dart' as $1;

class Folder extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Folder', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localPath')
    ..e<$1.SyncMode>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'syncMode', $pb.PbFieldType.OE, defaultOrMaker: $1.SyncMode.SYNC_MODE_UNSPECIFIED, valueOf: $1.SyncMode.valueOf, enumValues: $1.SyncMode.values)
    ..aOM<$3.Timestamp>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'lastScanTime', subBuilder: $3.Timestamp.create)
    ..aOB(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isActive')
    ..aOM<$3.Timestamp>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt', subBuilder: $3.Timestamp.create)
    ..aOM<$3.Timestamp>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'updatedAt', subBuilder: $3.Timestamp.create)
    ..hasRequiredFields = false
  ;

  Folder._() : super();
  factory Folder({
    $core.String? id,
    $core.String? localPath,
    $1.SyncMode? syncMode,
    $3.Timestamp? lastScanTime,
    $core.bool? isActive,
    $3.Timestamp? createdAt,
    $3.Timestamp? updatedAt,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (localPath != null) {
      _result.localPath = localPath;
    }
    if (syncMode != null) {
      _result.syncMode = syncMode;
    }
    if (lastScanTime != null) {
      _result.lastScanTime = lastScanTime;
    }
    if (isActive != null) {
      _result.isActive = isActive;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    if (updatedAt != null) {
      _result.updatedAt = updatedAt;
    }
    return _result;
  }
  factory Folder.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Folder.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Folder clone() => Folder()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Folder copyWith(void Function(Folder) updates) => super.copyWith((message) => updates(message as Folder)) as Folder; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Folder create() => Folder._();
  Folder createEmptyInstance() => create();
  static $pb.PbList<Folder> createRepeated() => $pb.PbList<Folder>();
  @$core.pragma('dart2js:noInline')
  static Folder getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Folder>(create);
  static Folder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get localPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set localPath($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLocalPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocalPath() => clearField(2);

  @$pb.TagNumber(3)
  $1.SyncMode get syncMode => $_getN(2);
  @$pb.TagNumber(3)
  set syncMode($1.SyncMode v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSyncMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearSyncMode() => clearField(3);

  @$pb.TagNumber(4)
  $3.Timestamp get lastScanTime => $_getN(3);
  @$pb.TagNumber(4)
  set lastScanTime($3.Timestamp v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasLastScanTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastScanTime() => clearField(4);
  @$pb.TagNumber(4)
  $3.Timestamp ensureLastScanTime() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get isActive => $_getBF(4);
  @$pb.TagNumber(5)
  set isActive($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasIsActive() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsActive() => clearField(5);

  @$pb.TagNumber(6)
  $3.Timestamp get createdAt => $_getN(5);
  @$pb.TagNumber(6)
  set createdAt($3.Timestamp v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => clearField(6);
  @$pb.TagNumber(6)
  $3.Timestamp ensureCreatedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $3.Timestamp get updatedAt => $_getN(6);
  @$pb.TagNumber(7)
  set updatedAt($3.Timestamp v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasUpdatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdatedAt() => clearField(7);
  @$pb.TagNumber(7)
  $3.Timestamp ensureUpdatedAt() => $_ensure(6);
}

class CreateFolderRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CreateFolderRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localPath')
    ..e<$1.SyncMode>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'syncMode', $pb.PbFieldType.OE, defaultOrMaker: $1.SyncMode.SYNC_MODE_UNSPECIFIED, valueOf: $1.SyncMode.valueOf, enumValues: $1.SyncMode.values)
    ..hasRequiredFields = false
  ;

  CreateFolderRequest._() : super();
  factory CreateFolderRequest({
    $core.String? localPath,
    $1.SyncMode? syncMode,
  }) {
    final _result = create();
    if (localPath != null) {
      _result.localPath = localPath;
    }
    if (syncMode != null) {
      _result.syncMode = syncMode;
    }
    return _result;
  }
  factory CreateFolderRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CreateFolderRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CreateFolderRequest clone() => CreateFolderRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CreateFolderRequest copyWith(void Function(CreateFolderRequest) updates) => super.copyWith((message) => updates(message as CreateFolderRequest)) as CreateFolderRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CreateFolderRequest create() => CreateFolderRequest._();
  CreateFolderRequest createEmptyInstance() => create();
  static $pb.PbList<CreateFolderRequest> createRepeated() => $pb.PbList<CreateFolderRequest>();
  @$core.pragma('dart2js:noInline')
  static CreateFolderRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateFolderRequest>(create);
  static CreateFolderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get localPath => $_getSZ(0);
  @$pb.TagNumber(1)
  set localPath($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLocalPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocalPath() => clearField(1);

  @$pb.TagNumber(2)
  $1.SyncMode get syncMode => $_getN(1);
  @$pb.TagNumber(2)
  set syncMode($1.SyncMode v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSyncMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearSyncMode() => clearField(2);
}

class GetFolderRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetFolderRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  GetFolderRequest._() : super();
  factory GetFolderRequest({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory GetFolderRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetFolderRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetFolderRequest clone() => GetFolderRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetFolderRequest copyWith(void Function(GetFolderRequest) updates) => super.copyWith((message) => updates(message as GetFolderRequest)) as GetFolderRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetFolderRequest create() => GetFolderRequest._();
  GetFolderRequest createEmptyInstance() => create();
  static $pb.PbList<GetFolderRequest> createRepeated() => $pb.PbList<GetFolderRequest>();
  @$core.pragma('dart2js:noInline')
  static GetFolderRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetFolderRequest>(create);
  static GetFolderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class ListFoldersRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListFoldersRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOB(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'activeOnly')
    ..aOM<$1.PaginationRequest>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $1.PaginationRequest.create)
    ..hasRequiredFields = false
  ;

  ListFoldersRequest._() : super();
  factory ListFoldersRequest({
    $core.bool? activeOnly,
    $1.PaginationRequest? pagination,
  }) {
    final _result = create();
    if (activeOnly != null) {
      _result.activeOnly = activeOnly;
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory ListFoldersRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListFoldersRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListFoldersRequest clone() => ListFoldersRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListFoldersRequest copyWith(void Function(ListFoldersRequest) updates) => super.copyWith((message) => updates(message as ListFoldersRequest)) as ListFoldersRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListFoldersRequest create() => ListFoldersRequest._();
  ListFoldersRequest createEmptyInstance() => create();
  static $pb.PbList<ListFoldersRequest> createRepeated() => $pb.PbList<ListFoldersRequest>();
  @$core.pragma('dart2js:noInline')
  static ListFoldersRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListFoldersRequest>(create);
  static ListFoldersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get activeOnly => $_getBF(0);
  @$pb.TagNumber(1)
  set activeOnly($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasActiveOnly() => $_has(0);
  @$pb.TagNumber(1)
  void clearActiveOnly() => clearField(1);

  @$pb.TagNumber(2)
  $1.PaginationRequest get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationRequest v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationRequest ensurePagination() => $_ensure(1);
}

class ListFoldersResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListFoldersResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..pc<Folder>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'folders', $pb.PbFieldType.PM, subBuilder: Folder.create)
    ..aOM<$1.PaginationResponse>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $1.PaginationResponse.create)
    ..hasRequiredFields = false
  ;

  ListFoldersResponse._() : super();
  factory ListFoldersResponse({
    $core.Iterable<Folder>? folders,
    $1.PaginationResponse? pagination,
  }) {
    final _result = create();
    if (folders != null) {
      _result.folders.addAll(folders);
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory ListFoldersResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListFoldersResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListFoldersResponse clone() => ListFoldersResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListFoldersResponse copyWith(void Function(ListFoldersResponse) updates) => super.copyWith((message) => updates(message as ListFoldersResponse)) as ListFoldersResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListFoldersResponse create() => ListFoldersResponse._();
  ListFoldersResponse createEmptyInstance() => create();
  static $pb.PbList<ListFoldersResponse> createRepeated() => $pb.PbList<ListFoldersResponse>();
  @$core.pragma('dart2js:noInline')
  static ListFoldersResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListFoldersResponse>(create);
  static ListFoldersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Folder> get folders => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginationResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationResponse v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationResponse ensurePagination() => $_ensure(1);
}

class UpdateFolderRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'UpdateFolderRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'localPath')
    ..e<$1.SyncMode>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'syncMode', $pb.PbFieldType.OE, defaultOrMaker: $1.SyncMode.SYNC_MODE_UNSPECIFIED, valueOf: $1.SyncMode.valueOf, enumValues: $1.SyncMode.values)
    ..hasRequiredFields = false
  ;

  UpdateFolderRequest._() : super();
  factory UpdateFolderRequest({
    $core.String? id,
    $core.String? localPath,
    $1.SyncMode? syncMode,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (localPath != null) {
      _result.localPath = localPath;
    }
    if (syncMode != null) {
      _result.syncMode = syncMode;
    }
    return _result;
  }
  factory UpdateFolderRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UpdateFolderRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UpdateFolderRequest clone() => UpdateFolderRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UpdateFolderRequest copyWith(void Function(UpdateFolderRequest) updates) => super.copyWith((message) => updates(message as UpdateFolderRequest)) as UpdateFolderRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static UpdateFolderRequest create() => UpdateFolderRequest._();
  UpdateFolderRequest createEmptyInstance() => create();
  static $pb.PbList<UpdateFolderRequest> createRepeated() => $pb.PbList<UpdateFolderRequest>();
  @$core.pragma('dart2js:noInline')
  static UpdateFolderRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateFolderRequest>(create);
  static UpdateFolderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get localPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set localPath($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLocalPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocalPath() => clearField(2);

  @$pb.TagNumber(3)
  $1.SyncMode get syncMode => $_getN(2);
  @$pb.TagNumber(3)
  set syncMode($1.SyncMode v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSyncMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearSyncMode() => clearField(3);
}

class DeleteFolderRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'DeleteFolderRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  DeleteFolderRequest._() : super();
  factory DeleteFolderRequest({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory DeleteFolderRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory DeleteFolderRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  DeleteFolderRequest clone() => DeleteFolderRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  DeleteFolderRequest copyWith(void Function(DeleteFolderRequest) updates) => super.copyWith((message) => updates(message as DeleteFolderRequest)) as DeleteFolderRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DeleteFolderRequest create() => DeleteFolderRequest._();
  DeleteFolderRequest createEmptyInstance() => create();
  static $pb.PbList<DeleteFolderRequest> createRepeated() => $pb.PbList<DeleteFolderRequest>();
  @$core.pragma('dart2js:noInline')
  static DeleteFolderRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DeleteFolderRequest>(create);
  static DeleteFolderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class ToggleFolderActiveRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ToggleFolderActiveRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isActive')
    ..hasRequiredFields = false
  ;

  ToggleFolderActiveRequest._() : super();
  factory ToggleFolderActiveRequest({
    $core.String? id,
    $core.bool? isActive,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (isActive != null) {
      _result.isActive = isActive;
    }
    return _result;
  }
  factory ToggleFolderActiveRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ToggleFolderActiveRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ToggleFolderActiveRequest clone() => ToggleFolderActiveRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ToggleFolderActiveRequest copyWith(void Function(ToggleFolderActiveRequest) updates) => super.copyWith((message) => updates(message as ToggleFolderActiveRequest)) as ToggleFolderActiveRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ToggleFolderActiveRequest create() => ToggleFolderActiveRequest._();
  ToggleFolderActiveRequest createEmptyInstance() => create();
  static $pb.PbList<ToggleFolderActiveRequest> createRepeated() => $pb.PbList<ToggleFolderActiveRequest>();
  @$core.pragma('dart2js:noInline')
  static ToggleFolderActiveRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ToggleFolderActiveRequest>(create);
  static ToggleFolderActiveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isActive => $_getBF(1);
  @$pb.TagNumber(2)
  set isActive($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIsActive() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsActive() => clearField(2);
}

class FolderResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'FolderResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', subBuilder: $1.Status.create)
    ..aOM<Folder>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'folder', subBuilder: Folder.create)
    ..hasRequiredFields = false
  ;

  FolderResponse._() : super();
  factory FolderResponse({
    $1.Status? status,
    Folder? folder,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    if (folder != null) {
      _result.folder = folder;
    }
    return _result;
  }
  factory FolderResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FolderResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  FolderResponse clone() => FolderResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  FolderResponse copyWith(void Function(FolderResponse) updates) => super.copyWith((message) => updates(message as FolderResponse)) as FolderResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FolderResponse create() => FolderResponse._();
  FolderResponse createEmptyInstance() => create();
  static $pb.PbList<FolderResponse> createRepeated() => $pb.PbList<FolderResponse>();
  @$core.pragma('dart2js:noInline')
  static FolderResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FolderResponse>(create);
  static FolderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($1.Status v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
  @$pb.TagNumber(1)
  $1.Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  Folder get folder => $_getN(1);
  @$pb.TagNumber(2)
  set folder(Folder v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasFolder() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolder() => clearField(2);
  @$pb.TagNumber(2)
  Folder ensureFolder() => $_ensure(1);
}

class ScanFolderRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ScanFolderRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'folderId')
    ..hasRequiredFields = false
  ;

  ScanFolderRequest._() : super();
  factory ScanFolderRequest({
    $core.String? folderId,
  }) {
    final _result = create();
    if (folderId != null) {
      _result.folderId = folderId;
    }
    return _result;
  }
  factory ScanFolderRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScanFolderRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScanFolderRequest clone() => ScanFolderRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScanFolderRequest copyWith(void Function(ScanFolderRequest) updates) => super.copyWith((message) => updates(message as ScanFolderRequest)) as ScanFolderRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScanFolderRequest create() => ScanFolderRequest._();
  ScanFolderRequest createEmptyInstance() => create();
  static $pb.PbList<ScanFolderRequest> createRepeated() => $pb.PbList<ScanFolderRequest>();
  @$core.pragma('dart2js:noInline')
  static ScanFolderRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScanFolderRequest>(create);
  static ScanFolderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get folderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFolderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderId() => clearField(1);
}

class ScanFolderResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ScanFolderResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'aether.api'), createEmptyInstance: create)
    ..aOM<$1.Status>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'status', subBuilder: $1.Status.create)
    ..a<$core.int>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'filesFound', $pb.PbFieldType.O3)
    ..a<$core.int>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'filesSaved', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  ScanFolderResponse._() : super();
  factory ScanFolderResponse({
    $1.Status? status,
    $core.int? filesFound,
    $core.int? filesSaved,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    if (filesFound != null) {
      _result.filesFound = filesFound;
    }
    if (filesSaved != null) {
      _result.filesSaved = filesSaved;
    }
    return _result;
  }
  factory ScanFolderResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ScanFolderResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ScanFolderResponse clone() => ScanFolderResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ScanFolderResponse copyWith(void Function(ScanFolderResponse) updates) => super.copyWith((message) => updates(message as ScanFolderResponse)) as ScanFolderResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ScanFolderResponse create() => ScanFolderResponse._();
  ScanFolderResponse createEmptyInstance() => create();
  static $pb.PbList<ScanFolderResponse> createRepeated() => $pb.PbList<ScanFolderResponse>();
  @$core.pragma('dart2js:noInline')
  static ScanFolderResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ScanFolderResponse>(create);
  static ScanFolderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($1.Status v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
  @$pb.TagNumber(1)
  $1.Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get filesFound => $_getIZ(1);
  @$pb.TagNumber(2)
  set filesFound($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFilesFound() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilesFound() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get filesSaved => $_getIZ(2);
  @$pb.TagNumber(3)
  set filesSaved($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasFilesSaved() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilesSaved() => clearField(3);
}

