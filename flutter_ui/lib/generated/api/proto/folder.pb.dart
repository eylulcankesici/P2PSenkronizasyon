// This is a generated file - do not edit.
//
// Generated from api/proto/folder.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart'
    as $2;

import 'common.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class Folder extends $pb.GeneratedMessage {
  factory Folder({
    $core.String? id,
    $core.String? localPath,
    $1.SyncMode? syncMode,
    $2.Timestamp? lastScanTime,
    $core.bool? isActive,
    $2.Timestamp? createdAt,
    $2.Timestamp? updatedAt,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (localPath != null) result.localPath = localPath;
    if (syncMode != null) result.syncMode = syncMode;
    if (lastScanTime != null) result.lastScanTime = lastScanTime;
    if (isActive != null) result.isActive = isActive;
    if (createdAt != null) result.createdAt = createdAt;
    if (updatedAt != null) result.updatedAt = updatedAt;
    return result;
  }

  Folder._();

  factory Folder.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Folder.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Folder',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'localPath')
    ..aE<$1.SyncMode>(3, _omitFieldNames ? '' : 'syncMode',
        enumValues: $1.SyncMode.values)
    ..aOM<$2.Timestamp>(4, _omitFieldNames ? '' : 'lastScanTime',
        subBuilder: $2.Timestamp.create)
    ..aOB(5, _omitFieldNames ? '' : 'isActive')
    ..aOM<$2.Timestamp>(6, _omitFieldNames ? '' : 'createdAt',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(7, _omitFieldNames ? '' : 'updatedAt',
        subBuilder: $2.Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Folder clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Folder copyWith(void Function(Folder) updates) =>
      super.copyWith((message) => updates(message as Folder)) as Folder;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Folder create() => Folder._();
  @$core.override
  Folder createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Folder getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Folder>(create);
  static Folder? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get localPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set localPath($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocalPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocalPath() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.SyncMode get syncMode => $_getN(2);
  @$pb.TagNumber(3)
  set syncMode($1.SyncMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSyncMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearSyncMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.Timestamp get lastScanTime => $_getN(3);
  @$pb.TagNumber(4)
  set lastScanTime($2.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLastScanTime() => $_has(3);
  @$pb.TagNumber(4)
  void clearLastScanTime() => $_clearField(4);
  @$pb.TagNumber(4)
  $2.Timestamp ensureLastScanTime() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get isActive => $_getBF(4);
  @$pb.TagNumber(5)
  set isActive($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsActive() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsActive() => $_clearField(5);

  @$pb.TagNumber(6)
  $2.Timestamp get createdAt => $_getN(5);
  @$pb.TagNumber(6)
  set createdAt($2.Timestamp value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasCreatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearCreatedAt() => $_clearField(6);
  @$pb.TagNumber(6)
  $2.Timestamp ensureCreatedAt() => $_ensure(5);

  @$pb.TagNumber(7)
  $2.Timestamp get updatedAt => $_getN(6);
  @$pb.TagNumber(7)
  set updatedAt($2.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasUpdatedAt() => $_has(6);
  @$pb.TagNumber(7)
  void clearUpdatedAt() => $_clearField(7);
  @$pb.TagNumber(7)
  $2.Timestamp ensureUpdatedAt() => $_ensure(6);
}

class CreateFolderRequest extends $pb.GeneratedMessage {
  factory CreateFolderRequest({
    $core.String? localPath,
    $1.SyncMode? syncMode,
  }) {
    final result = create();
    if (localPath != null) result.localPath = localPath;
    if (syncMode != null) result.syncMode = syncMode;
    return result;
  }

  CreateFolderRequest._();

  factory CreateFolderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateFolderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateFolderRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'localPath')
    ..aE<$1.SyncMode>(2, _omitFieldNames ? '' : 'syncMode',
        enumValues: $1.SyncMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFolderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFolderRequest copyWith(void Function(CreateFolderRequest) updates) =>
      super.copyWith((message) => updates(message as CreateFolderRequest))
          as CreateFolderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateFolderRequest create() => CreateFolderRequest._();
  @$core.override
  CreateFolderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateFolderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateFolderRequest>(create);
  static CreateFolderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get localPath => $_getSZ(0);
  @$pb.TagNumber(1)
  set localPath($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLocalPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocalPath() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.SyncMode get syncMode => $_getN(1);
  @$pb.TagNumber(2)
  set syncMode($1.SyncMode value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSyncMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearSyncMode() => $_clearField(2);
}

class GetFolderRequest extends $pb.GeneratedMessage {
  factory GetFolderRequest({
    $core.String? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  GetFolderRequest._();

  factory GetFolderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetFolderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetFolderRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFolderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetFolderRequest copyWith(void Function(GetFolderRequest) updates) =>
      super.copyWith((message) => updates(message as GetFolderRequest))
          as GetFolderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetFolderRequest create() => GetFolderRequest._();
  @$core.override
  GetFolderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetFolderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetFolderRequest>(create);
  static GetFolderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class ListFoldersRequest extends $pb.GeneratedMessage {
  factory ListFoldersRequest({
    $core.bool? activeOnly,
    $1.PaginationRequest? pagination,
  }) {
    final result = create();
    if (activeOnly != null) result.activeOnly = activeOnly;
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListFoldersRequest._();

  factory ListFoldersRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFoldersRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFoldersRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'activeOnly')
    ..aOM<$1.PaginationRequest>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationRequest.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFoldersRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFoldersRequest copyWith(void Function(ListFoldersRequest) updates) =>
      super.copyWith((message) => updates(message as ListFoldersRequest))
          as ListFoldersRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFoldersRequest create() => ListFoldersRequest._();
  @$core.override
  ListFoldersRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFoldersRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFoldersRequest>(create);
  static ListFoldersRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get activeOnly => $_getBF(0);
  @$pb.TagNumber(1)
  set activeOnly($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasActiveOnly() => $_has(0);
  @$pb.TagNumber(1)
  void clearActiveOnly() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.PaginationRequest get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationRequest value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationRequest ensurePagination() => $_ensure(1);
}

class ListFoldersResponse extends $pb.GeneratedMessage {
  factory ListFoldersResponse({
    $core.Iterable<Folder>? folders,
    $1.PaginationResponse? pagination,
  }) {
    final result = create();
    if (folders != null) result.folders.addAll(folders);
    if (pagination != null) result.pagination = pagination;
    return result;
  }

  ListFoldersResponse._();

  factory ListFoldersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ListFoldersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ListFoldersResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..pPM<Folder>(1, _omitFieldNames ? '' : 'folders',
        subBuilder: Folder.create)
    ..aOM<$1.PaginationResponse>(2, _omitFieldNames ? '' : 'pagination',
        subBuilder: $1.PaginationResponse.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFoldersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ListFoldersResponse copyWith(void Function(ListFoldersResponse) updates) =>
      super.copyWith((message) => updates(message as ListFoldersResponse))
          as ListFoldersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ListFoldersResponse create() => ListFoldersResponse._();
  @$core.override
  ListFoldersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ListFoldersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ListFoldersResponse>(create);
  static ListFoldersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Folder> get folders => $_getList(0);

  @$pb.TagNumber(2)
  $1.PaginationResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($1.PaginationResponse value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.PaginationResponse ensurePagination() => $_ensure(1);
}

class UpdateFolderRequest extends $pb.GeneratedMessage {
  factory UpdateFolderRequest({
    $core.String? id,
    $core.String? localPath,
    $1.SyncMode? syncMode,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (localPath != null) result.localPath = localPath;
    if (syncMode != null) result.syncMode = syncMode;
    return result;
  }

  UpdateFolderRequest._();

  factory UpdateFolderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateFolderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateFolderRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'localPath')
    ..aE<$1.SyncMode>(3, _omitFieldNames ? '' : 'syncMode',
        enumValues: $1.SyncMode.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateFolderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateFolderRequest copyWith(void Function(UpdateFolderRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateFolderRequest))
          as UpdateFolderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateFolderRequest create() => UpdateFolderRequest._();
  @$core.override
  UpdateFolderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateFolderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateFolderRequest>(create);
  static UpdateFolderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get localPath => $_getSZ(1);
  @$pb.TagNumber(2)
  set localPath($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLocalPath() => $_has(1);
  @$pb.TagNumber(2)
  void clearLocalPath() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.SyncMode get syncMode => $_getN(2);
  @$pb.TagNumber(3)
  set syncMode($1.SyncMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasSyncMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearSyncMode() => $_clearField(3);
}

class DeleteFolderRequest extends $pb.GeneratedMessage {
  factory DeleteFolderRequest({
    $core.String? id,
    $core.bool? deletePhysically,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (deletePhysically != null) result.deletePhysically = deletePhysically;
    return result;
  }

  DeleteFolderRequest._();

  factory DeleteFolderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteFolderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteFolderRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOB(2, _omitFieldNames ? '' : 'deletePhysically')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteFolderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteFolderRequest copyWith(void Function(DeleteFolderRequest) updates) =>
      super.copyWith((message) => updates(message as DeleteFolderRequest))
          as DeleteFolderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteFolderRequest create() => DeleteFolderRequest._();
  @$core.override
  DeleteFolderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteFolderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteFolderRequest>(create);
  static DeleteFolderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get deletePhysically => $_getBF(1);
  @$pb.TagNumber(2)
  set deletePhysically($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDeletePhysically() => $_has(1);
  @$pb.TagNumber(2)
  void clearDeletePhysically() => $_clearField(2);
}

class ToggleFolderActiveRequest extends $pb.GeneratedMessage {
  factory ToggleFolderActiveRequest({
    $core.String? id,
    $core.bool? isActive,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (isActive != null) result.isActive = isActive;
    return result;
  }

  ToggleFolderActiveRequest._();

  factory ToggleFolderActiveRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ToggleFolderActiveRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToggleFolderActiveRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOB(2, _omitFieldNames ? '' : 'isActive')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleFolderActiveRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToggleFolderActiveRequest copyWith(
          void Function(ToggleFolderActiveRequest) updates) =>
      super.copyWith((message) => updates(message as ToggleFolderActiveRequest))
          as ToggleFolderActiveRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToggleFolderActiveRequest create() => ToggleFolderActiveRequest._();
  @$core.override
  ToggleFolderActiveRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ToggleFolderActiveRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToggleFolderActiveRequest>(create);
  static ToggleFolderActiveRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isActive => $_getBF(1);
  @$pb.TagNumber(2)
  set isActive($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsActive() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsActive() => $_clearField(2);
}

class FolderResponse extends $pb.GeneratedMessage {
  factory FolderResponse({
    $1.Status? status,
    Folder? folder,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (folder != null) result.folder = folder;
    return result;
  }

  FolderResponse._();

  factory FolderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FolderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FolderResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..aOM<Folder>(2, _omitFieldNames ? '' : 'folder', subBuilder: Folder.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FolderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FolderResponse copyWith(void Function(FolderResponse) updates) =>
      super.copyWith((message) => updates(message as FolderResponse))
          as FolderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FolderResponse create() => FolderResponse._();
  @$core.override
  FolderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FolderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FolderResponse>(create);
  static FolderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($1.Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  Folder get folder => $_getN(1);
  @$pb.TagNumber(2)
  set folder(Folder value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFolder() => $_has(1);
  @$pb.TagNumber(2)
  void clearFolder() => $_clearField(2);
  @$pb.TagNumber(2)
  Folder ensureFolder() => $_ensure(1);
}

class ScanFolderRequest extends $pb.GeneratedMessage {
  factory ScanFolderRequest({
    $core.String? folderId,
  }) {
    final result = create();
    if (folderId != null) result.folderId = folderId;
    return result;
  }

  ScanFolderRequest._();

  factory ScanFolderRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScanFolderRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScanFolderRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'folderId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanFolderRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanFolderRequest copyWith(void Function(ScanFolderRequest) updates) =>
      super.copyWith((message) => updates(message as ScanFolderRequest))
          as ScanFolderRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScanFolderRequest create() => ScanFolderRequest._();
  @$core.override
  ScanFolderRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScanFolderRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScanFolderRequest>(create);
  static ScanFolderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get folderId => $_getSZ(0);
  @$pb.TagNumber(1)
  set folderId($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFolderId() => $_has(0);
  @$pb.TagNumber(1)
  void clearFolderId() => $_clearField(1);
}

class ScanFolderResponse extends $pb.GeneratedMessage {
  factory ScanFolderResponse({
    $1.Status? status,
    $core.int? filesFound,
    $core.int? filesSaved,
  }) {
    final result = create();
    if (status != null) result.status = status;
    if (filesFound != null) result.filesFound = filesFound;
    if (filesSaved != null) result.filesSaved = filesSaved;
    return result;
  }

  ScanFolderResponse._();

  factory ScanFolderResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ScanFolderResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ScanFolderResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'aether.api'),
      createEmptyInstance: create)
    ..aOM<$1.Status>(1, _omitFieldNames ? '' : 'status',
        subBuilder: $1.Status.create)
    ..aI(2, _omitFieldNames ? '' : 'filesFound')
    ..aI(3, _omitFieldNames ? '' : 'filesSaved')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanFolderResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ScanFolderResponse copyWith(void Function(ScanFolderResponse) updates) =>
      super.copyWith((message) => updates(message as ScanFolderResponse))
          as ScanFolderResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ScanFolderResponse create() => ScanFolderResponse._();
  @$core.override
  ScanFolderResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ScanFolderResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ScanFolderResponse>(create);
  static ScanFolderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $1.Status get status => $_getN(0);
  @$pb.TagNumber(1)
  set status($1.Status value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.Status ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get filesFound => $_getIZ(1);
  @$pb.TagNumber(2)
  set filesFound($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasFilesFound() => $_has(1);
  @$pb.TagNumber(2)
  void clearFilesFound() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get filesSaved => $_getIZ(2);
  @$pb.TagNumber(3)
  set filesSaved($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFilesSaved() => $_has(2);
  @$pb.TagNumber(3)
  void clearFilesSaved() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
