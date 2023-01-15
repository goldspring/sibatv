// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LiveInfo _$LiveInfoFromJson(Map<String, dynamic> json) {
  return _LiveInfo.fromJson(json);
}

/// @nodoc
mixin _$LiveInfo {
  String get coverPath => throw _privateConstructorUsedError;
  String get ctime => throw _privateConstructorUsedError;
  String get liveId => throw _privateConstructorUsedError;
  String? get roomId => throw _privateConstructorUsedError;
  int get liveType => throw _privateConstructorUsedError; // 1：直播，2：电台
  String get title => throw _privateConstructorUsedError;
  int get liveMode => throw _privateConstructorUsedError; // 0: 直播/电台 1:录屏
  int get status => throw _privateConstructorUsedError; // 2: live 3: 重播
  UserInfo get userInfo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LiveInfoCopyWith<LiveInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiveInfoCopyWith<$Res> {
  factory $LiveInfoCopyWith(LiveInfo value, $Res Function(LiveInfo) then) =
      _$LiveInfoCopyWithImpl<$Res, LiveInfo>;
  @useResult
  $Res call(
      {String coverPath,
      String ctime,
      String liveId,
      String? roomId,
      int liveType,
      String title,
      int liveMode,
      int status,
      UserInfo userInfo});

  $UserInfoCopyWith<$Res> get userInfo;
}

/// @nodoc
class _$LiveInfoCopyWithImpl<$Res, $Val extends LiveInfo>
    implements $LiveInfoCopyWith<$Res> {
  _$LiveInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coverPath = null,
    Object? ctime = null,
    Object? liveId = null,
    Object? roomId = freezed,
    Object? liveType = null,
    Object? title = null,
    Object? liveMode = null,
    Object? status = null,
    Object? userInfo = null,
  }) {
    return _then(_value.copyWith(
      coverPath: null == coverPath
          ? _value.coverPath
          : coverPath // ignore: cast_nullable_to_non_nullable
              as String,
      ctime: null == ctime
          ? _value.ctime
          : ctime // ignore: cast_nullable_to_non_nullable
              as String,
      liveId: null == liveId
          ? _value.liveId
          : liveId // ignore: cast_nullable_to_non_nullable
              as String,
      roomId: freezed == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String?,
      liveType: null == liveType
          ? _value.liveType
          : liveType // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      liveMode: null == liveMode
          ? _value.liveMode
          : liveMode // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      userInfo: null == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfo,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserInfoCopyWith<$Res> get userInfo {
    return $UserInfoCopyWith<$Res>(_value.userInfo, (value) {
      return _then(_value.copyWith(userInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LiveInfoCopyWith<$Res> implements $LiveInfoCopyWith<$Res> {
  factory _$$_LiveInfoCopyWith(
          _$_LiveInfo value, $Res Function(_$_LiveInfo) then) =
      __$$_LiveInfoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String coverPath,
      String ctime,
      String liveId,
      String? roomId,
      int liveType,
      String title,
      int liveMode,
      int status,
      UserInfo userInfo});

  @override
  $UserInfoCopyWith<$Res> get userInfo;
}

/// @nodoc
class __$$_LiveInfoCopyWithImpl<$Res>
    extends _$LiveInfoCopyWithImpl<$Res, _$_LiveInfo>
    implements _$$_LiveInfoCopyWith<$Res> {
  __$$_LiveInfoCopyWithImpl(
      _$_LiveInfo _value, $Res Function(_$_LiveInfo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? coverPath = null,
    Object? ctime = null,
    Object? liveId = null,
    Object? roomId = freezed,
    Object? liveType = null,
    Object? title = null,
    Object? liveMode = null,
    Object? status = null,
    Object? userInfo = null,
  }) {
    return _then(_$_LiveInfo(
      coverPath: null == coverPath
          ? _value.coverPath
          : coverPath // ignore: cast_nullable_to_non_nullable
              as String,
      ctime: null == ctime
          ? _value.ctime
          : ctime // ignore: cast_nullable_to_non_nullable
              as String,
      liveId: null == liveId
          ? _value.liveId
          : liveId // ignore: cast_nullable_to_non_nullable
              as String,
      roomId: freezed == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String?,
      liveType: null == liveType
          ? _value.liveType
          : liveType // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      liveMode: null == liveMode
          ? _value.liveMode
          : liveMode // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      userInfo: null == userInfo
          ? _value.userInfo
          : userInfo // ignore: cast_nullable_to_non_nullable
              as UserInfo,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_LiveInfo implements _LiveInfo {
  const _$_LiveInfo(
      {required this.coverPath,
      required this.ctime,
      required this.liveId,
      required this.roomId,
      required this.liveType,
      required this.title,
      required this.liveMode,
      required this.status,
      required this.userInfo});

  factory _$_LiveInfo.fromJson(Map<String, dynamic> json) =>
      _$$_LiveInfoFromJson(json);

  @override
  final String coverPath;
  @override
  final String ctime;
  @override
  final String liveId;
  @override
  final String? roomId;
  @override
  final int liveType;
// 1：直播，2：电台
  @override
  final String title;
  @override
  final int liveMode;
// 0: 直播/电台 1:录屏
  @override
  final int status;
// 2: live 3: 重播
  @override
  final UserInfo userInfo;

  @override
  String toString() {
    return 'LiveInfo(coverPath: $coverPath, ctime: $ctime, liveId: $liveId, roomId: $roomId, liveType: $liveType, title: $title, liveMode: $liveMode, status: $status, userInfo: $userInfo)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LiveInfo &&
            (identical(other.coverPath, coverPath) ||
                other.coverPath == coverPath) &&
            (identical(other.ctime, ctime) || other.ctime == ctime) &&
            (identical(other.liveId, liveId) || other.liveId == liveId) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.liveType, liveType) ||
                other.liveType == liveType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.liveMode, liveMode) ||
                other.liveMode == liveMode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.userInfo, userInfo) ||
                other.userInfo == userInfo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, coverPath, ctime, liveId, roomId,
      liveType, title, liveMode, status, userInfo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LiveInfoCopyWith<_$_LiveInfo> get copyWith =>
      __$$_LiveInfoCopyWithImpl<_$_LiveInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LiveInfoToJson(
      this,
    );
  }
}

abstract class _LiveInfo implements LiveInfo {
  const factory _LiveInfo(
      {required final String coverPath,
      required final String ctime,
      required final String liveId,
      required final String? roomId,
      required final int liveType,
      required final String title,
      required final int liveMode,
      required final int status,
      required final UserInfo userInfo}) = _$_LiveInfo;

  factory _LiveInfo.fromJson(Map<String, dynamic> json) = _$_LiveInfo.fromJson;

  @override
  String get coverPath;
  @override
  String get ctime;
  @override
  String get liveId;
  @override
  String? get roomId;
  @override
  int get liveType;
  @override // 1：直播，2：电台
  String get title;
  @override
  int get liveMode;
  @override // 0: 直播/电台 1:录屏
  int get status;
  @override // 2: live 3: 重播
  UserInfo get userInfo;
  @override
  @JsonKey(ignore: true)
  _$$_LiveInfoCopyWith<_$_LiveInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return _UserInfo.fromJson(json);
}

/// @nodoc
mixin _$UserInfo {
  String get avatar => throw _privateConstructorUsedError;
  String get nickname => throw _privateConstructorUsedError;
  String get teamLogo => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserInfoCopyWith<UserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserInfoCopyWith<$Res> {
  factory $UserInfoCopyWith(UserInfo value, $Res Function(UserInfo) then) =
      _$UserInfoCopyWithImpl<$Res, UserInfo>;
  @useResult
  $Res call({String avatar, String nickname, String teamLogo, String userId});
}

/// @nodoc
class _$UserInfoCopyWithImpl<$Res, $Val extends UserInfo>
    implements $UserInfoCopyWith<$Res> {
  _$UserInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avatar = null,
    Object? nickname = null,
    Object? teamLogo = null,
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      teamLogo: null == teamLogo
          ? _value.teamLogo
          : teamLogo // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserInfoCopyWith<$Res> implements $UserInfoCopyWith<$Res> {
  factory _$$_UserInfoCopyWith(
          _$_UserInfo value, $Res Function(_$_UserInfo) then) =
      __$$_UserInfoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String avatar, String nickname, String teamLogo, String userId});
}

/// @nodoc
class __$$_UserInfoCopyWithImpl<$Res>
    extends _$UserInfoCopyWithImpl<$Res, _$_UserInfo>
    implements _$$_UserInfoCopyWith<$Res> {
  __$$_UserInfoCopyWithImpl(
      _$_UserInfo _value, $Res Function(_$_UserInfo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avatar = null,
    Object? nickname = null,
    Object? teamLogo = null,
    Object? userId = null,
  }) {
    return _then(_$_UserInfo(
      avatar: null == avatar
          ? _value.avatar
          : avatar // ignore: cast_nullable_to_non_nullable
              as String,
      nickname: null == nickname
          ? _value.nickname
          : nickname // ignore: cast_nullable_to_non_nullable
              as String,
      teamLogo: null == teamLogo
          ? _value.teamLogo
          : teamLogo // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserInfo implements _UserInfo {
  const _$_UserInfo(
      {required this.avatar,
      required this.nickname,
      required this.teamLogo,
      required this.userId});

  factory _$_UserInfo.fromJson(Map<String, dynamic> json) =>
      _$$_UserInfoFromJson(json);

  @override
  final String avatar;
  @override
  final String nickname;
  @override
  final String teamLogo;
  @override
  final String userId;

  @override
  String toString() {
    return 'UserInfo(avatar: $avatar, nickname: $nickname, teamLogo: $teamLogo, userId: $userId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserInfo &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.nickname, nickname) ||
                other.nickname == nickname) &&
            (identical(other.teamLogo, teamLogo) ||
                other.teamLogo == teamLogo) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, avatar, nickname, teamLogo, userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserInfoCopyWith<_$_UserInfo> get copyWith =>
      __$$_UserInfoCopyWithImpl<_$_UserInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserInfoToJson(
      this,
    );
  }
}

abstract class _UserInfo implements UserInfo {
  const factory _UserInfo(
      {required final String avatar,
      required final String nickname,
      required final String teamLogo,
      required final String userId}) = _$_UserInfo;

  factory _UserInfo.fromJson(Map<String, dynamic> json) = _$_UserInfo.fromJson;

  @override
  String get avatar;
  @override
  String get nickname;
  @override
  String get teamLogo;
  @override
  String get userId;
  @override
  @JsonKey(ignore: true)
  _$$_UserInfoCopyWith<_$_UserInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

LiveData _$LiveDataFromJson(Map<String, dynamic> json) {
  return _LiveData.fromJson(json);
}

/// @nodoc
mixin _$LiveData {
  LiveDataContent get content => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LiveDataCopyWith<LiveData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiveDataCopyWith<$Res> {
  factory $LiveDataCopyWith(LiveData value, $Res Function(LiveData) then) =
      _$LiveDataCopyWithImpl<$Res, LiveData>;
  @useResult
  $Res call(
      {LiveDataContent content, String message, int status, bool success});

  $LiveDataContentCopyWith<$Res> get content;
}

/// @nodoc
class _$LiveDataCopyWithImpl<$Res, $Val extends LiveData>
    implements $LiveDataCopyWith<$Res> {
  _$LiveDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? message = null,
    Object? status = null,
    Object? success = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as LiveDataContent,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LiveDataContentCopyWith<$Res> get content {
    return $LiveDataContentCopyWith<$Res>(_value.content, (value) {
      return _then(_value.copyWith(content: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LiveDataCopyWith<$Res> implements $LiveDataCopyWith<$Res> {
  factory _$$_LiveDataCopyWith(
          _$_LiveData value, $Res Function(_$_LiveData) then) =
      __$$_LiveDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LiveDataContent content, String message, int status, bool success});

  @override
  $LiveDataContentCopyWith<$Res> get content;
}

/// @nodoc
class __$$_LiveDataCopyWithImpl<$Res>
    extends _$LiveDataCopyWithImpl<$Res, _$_LiveData>
    implements _$$_LiveDataCopyWith<$Res> {
  __$$_LiveDataCopyWithImpl(
      _$_LiveData _value, $Res Function(_$_LiveData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? message = null,
    Object? status = null,
    Object? success = null,
  }) {
    return _then(_$_LiveData(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as LiveDataContent,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_LiveData implements _LiveData {
  const _$_LiveData(
      {required this.content,
      required this.message,
      required this.status,
      required this.success});

  factory _$_LiveData.fromJson(Map<String, dynamic> json) =>
      _$$_LiveDataFromJson(json);

  @override
  final LiveDataContent content;
  @override
  final String message;
  @override
  final int status;
  @override
  final bool success;

  @override
  String toString() {
    return 'LiveData(content: $content, message: $message, status: $status, success: $success)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LiveData &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.success, success) || other.success == success));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, content, message, status, success);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LiveDataCopyWith<_$_LiveData> get copyWith =>
      __$$_LiveDataCopyWithImpl<_$_LiveData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LiveDataToJson(
      this,
    );
  }
}

abstract class _LiveData implements LiveData {
  const factory _LiveData(
      {required final LiveDataContent content,
      required final String message,
      required final int status,
      required final bool success}) = _$_LiveData;

  factory _LiveData.fromJson(Map<String, dynamic> json) = _$_LiveData.fromJson;

  @override
  LiveDataContent get content;
  @override
  String get message;
  @override
  int get status;
  @override
  bool get success;
  @override
  @JsonKey(ignore: true)
  _$$_LiveDataCopyWith<_$_LiveData> get copyWith =>
      throw _privateConstructorUsedError;
}

LiveDataContent _$LiveDataContentFromJson(Map<String, dynamic> json) {
  return _LiveDataContent.fromJson(json);
}

/// @nodoc
mixin _$LiveDataContent {
  List<LiveInfo> get liveList => throw _privateConstructorUsedError;
  String get next => throw _privateConstructorUsedError;
  bool get slideUpAndDown => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LiveDataContentCopyWith<LiveDataContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiveDataContentCopyWith<$Res> {
  factory $LiveDataContentCopyWith(
          LiveDataContent value, $Res Function(LiveDataContent) then) =
      _$LiveDataContentCopyWithImpl<$Res, LiveDataContent>;
  @useResult
  $Res call({List<LiveInfo> liveList, String next, bool slideUpAndDown});
}

/// @nodoc
class _$LiveDataContentCopyWithImpl<$Res, $Val extends LiveDataContent>
    implements $LiveDataContentCopyWith<$Res> {
  _$LiveDataContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? liveList = null,
    Object? next = null,
    Object? slideUpAndDown = null,
  }) {
    return _then(_value.copyWith(
      liveList: null == liveList
          ? _value.liveList
          : liveList // ignore: cast_nullable_to_non_nullable
              as List<LiveInfo>,
      next: null == next
          ? _value.next
          : next // ignore: cast_nullable_to_non_nullable
              as String,
      slideUpAndDown: null == slideUpAndDown
          ? _value.slideUpAndDown
          : slideUpAndDown // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LiveDataContentCopyWith<$Res>
    implements $LiveDataContentCopyWith<$Res> {
  factory _$$_LiveDataContentCopyWith(
          _$_LiveDataContent value, $Res Function(_$_LiveDataContent) then) =
      __$$_LiveDataContentCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<LiveInfo> liveList, String next, bool slideUpAndDown});
}

/// @nodoc
class __$$_LiveDataContentCopyWithImpl<$Res>
    extends _$LiveDataContentCopyWithImpl<$Res, _$_LiveDataContent>
    implements _$$_LiveDataContentCopyWith<$Res> {
  __$$_LiveDataContentCopyWithImpl(
      _$_LiveDataContent _value, $Res Function(_$_LiveDataContent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? liveList = null,
    Object? next = null,
    Object? slideUpAndDown = null,
  }) {
    return _then(_$_LiveDataContent(
      liveList: null == liveList
          ? _value._liveList
          : liveList // ignore: cast_nullable_to_non_nullable
              as List<LiveInfo>,
      next: null == next
          ? _value.next
          : next // ignore: cast_nullable_to_non_nullable
              as String,
      slideUpAndDown: null == slideUpAndDown
          ? _value.slideUpAndDown
          : slideUpAndDown // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_LiveDataContent implements _LiveDataContent {
  const _$_LiveDataContent(
      {required final List<LiveInfo> liveList,
      required this.next,
      required this.slideUpAndDown})
      : _liveList = liveList;

  factory _$_LiveDataContent.fromJson(Map<String, dynamic> json) =>
      _$$_LiveDataContentFromJson(json);

  final List<LiveInfo> _liveList;
  @override
  List<LiveInfo> get liveList {
    if (_liveList is EqualUnmodifiableListView) return _liveList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_liveList);
  }

  @override
  final String next;
  @override
  final bool slideUpAndDown;

  @override
  String toString() {
    return 'LiveDataContent(liveList: $liveList, next: $next, slideUpAndDown: $slideUpAndDown)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LiveDataContent &&
            const DeepCollectionEquality().equals(other._liveList, _liveList) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.slideUpAndDown, slideUpAndDown) ||
                other.slideUpAndDown == slideUpAndDown));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_liveList), next, slideUpAndDown);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LiveDataContentCopyWith<_$_LiveDataContent> get copyWith =>
      __$$_LiveDataContentCopyWithImpl<_$_LiveDataContent>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LiveDataContentToJson(
      this,
    );
  }
}

abstract class _LiveDataContent implements LiveDataContent {
  const factory _LiveDataContent(
      {required final List<LiveInfo> liveList,
      required final String next,
      required final bool slideUpAndDown}) = _$_LiveDataContent;

  factory _LiveDataContent.fromJson(Map<String, dynamic> json) =
      _$_LiveDataContent.fromJson;

  @override
  List<LiveInfo> get liveList;
  @override
  String get next;
  @override
  bool get slideUpAndDown;
  @override
  @JsonKey(ignore: true)
  _$$_LiveDataContentCopyWith<_$_LiveDataContent> get copyWith =>
      throw _privateConstructorUsedError;
}

LiveRoomInfo _$LiveRoomInfoFromJson(Map<String, dynamic> json) {
  return _LiveRoomInfo.fromJson(json);
}

/// @nodoc
mixin _$LiveRoomInfo {
  LiveRoomInfoContent get content => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  int get status => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LiveRoomInfoCopyWith<LiveRoomInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiveRoomInfoCopyWith<$Res> {
  factory $LiveRoomInfoCopyWith(
          LiveRoomInfo value, $Res Function(LiveRoomInfo) then) =
      _$LiveRoomInfoCopyWithImpl<$Res, LiveRoomInfo>;
  @useResult
  $Res call(
      {LiveRoomInfoContent content, String message, int status, bool success});

  $LiveRoomInfoContentCopyWith<$Res> get content;
}

/// @nodoc
class _$LiveRoomInfoCopyWithImpl<$Res, $Val extends LiveRoomInfo>
    implements $LiveRoomInfoCopyWith<$Res> {
  _$LiveRoomInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? message = null,
    Object? status = null,
    Object? success = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as LiveRoomInfoContent,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LiveRoomInfoContentCopyWith<$Res> get content {
    return $LiveRoomInfoContentCopyWith<$Res>(_value.content, (value) {
      return _then(_value.copyWith(content: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LiveRoomInfoCopyWith<$Res>
    implements $LiveRoomInfoCopyWith<$Res> {
  factory _$$_LiveRoomInfoCopyWith(
          _$_LiveRoomInfo value, $Res Function(_$_LiveRoomInfo) then) =
      __$$_LiveRoomInfoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LiveRoomInfoContent content, String message, int status, bool success});

  @override
  $LiveRoomInfoContentCopyWith<$Res> get content;
}

/// @nodoc
class __$$_LiveRoomInfoCopyWithImpl<$Res>
    extends _$LiveRoomInfoCopyWithImpl<$Res, _$_LiveRoomInfo>
    implements _$$_LiveRoomInfoCopyWith<$Res> {
  __$$_LiveRoomInfoCopyWithImpl(
      _$_LiveRoomInfo _value, $Res Function(_$_LiveRoomInfo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? message = null,
    Object? status = null,
    Object? success = null,
  }) {
    return _then(_$_LiveRoomInfo(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as LiveRoomInfoContent,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as int,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_LiveRoomInfo implements _LiveRoomInfo {
  const _$_LiveRoomInfo(
      {required this.content,
      required this.message,
      required this.status,
      required this.success});

  factory _$_LiveRoomInfo.fromJson(Map<String, dynamic> json) =>
      _$$_LiveRoomInfoFromJson(json);

  @override
  final LiveRoomInfoContent content;
  @override
  final String message;
  @override
  final int status;
  @override
  final bool success;

  @override
  String toString() {
    return 'LiveRoomInfo(content: $content, message: $message, status: $status, success: $success)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LiveRoomInfo &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.success, success) || other.success == success));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, content, message, status, success);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LiveRoomInfoCopyWith<_$_LiveRoomInfo> get copyWith =>
      __$$_LiveRoomInfoCopyWithImpl<_$_LiveRoomInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LiveRoomInfoToJson(
      this,
    );
  }
}

abstract class _LiveRoomInfo implements LiveRoomInfo {
  const factory _LiveRoomInfo(
      {required final LiveRoomInfoContent content,
      required final String message,
      required final int status,
      required final bool success}) = _$_LiveRoomInfo;

  factory _LiveRoomInfo.fromJson(Map<String, dynamic> json) =
      _$_LiveRoomInfo.fromJson;

  @override
  LiveRoomInfoContent get content;
  @override
  String get message;
  @override
  int get status;
  @override
  bool get success;
  @override
  @JsonKey(ignore: true)
  _$$_LiveRoomInfoCopyWith<_$_LiveRoomInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

LiveRoomInfoContent _$LiveRoomInfoContentFromJson(Map<String, dynamic> json) {
  return _LiveRoomInfoContent.fromJson(json);
}

/// @nodoc
mixin _$LiveRoomInfoContent {
  Carousels? get carousels => throw _privateConstructorUsedError;
  String get liveId => throw _privateConstructorUsedError;
  String get roomId => throw _privateConstructorUsedError;
  String get playStreamPath => throw _privateConstructorUsedError;
  String get systemMsg => throw _privateConstructorUsedError;
  String? get msgFilePath => throw _privateConstructorUsedError;
  User get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LiveRoomInfoContentCopyWith<LiveRoomInfoContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LiveRoomInfoContentCopyWith<$Res> {
  factory $LiveRoomInfoContentCopyWith(
          LiveRoomInfoContent value, $Res Function(LiveRoomInfoContent) then) =
      _$LiveRoomInfoContentCopyWithImpl<$Res, LiveRoomInfoContent>;
  @useResult
  $Res call(
      {Carousels? carousels,
      String liveId,
      String roomId,
      String playStreamPath,
      String systemMsg,
      String? msgFilePath,
      User user});

  $CarouselsCopyWith<$Res>? get carousels;
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$LiveRoomInfoContentCopyWithImpl<$Res, $Val extends LiveRoomInfoContent>
    implements $LiveRoomInfoContentCopyWith<$Res> {
  _$LiveRoomInfoContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? carousels = freezed,
    Object? liveId = null,
    Object? roomId = null,
    Object? playStreamPath = null,
    Object? systemMsg = null,
    Object? msgFilePath = freezed,
    Object? user = null,
  }) {
    return _then(_value.copyWith(
      carousels: freezed == carousels
          ? _value.carousels
          : carousels // ignore: cast_nullable_to_non_nullable
              as Carousels?,
      liveId: null == liveId
          ? _value.liveId
          : liveId // ignore: cast_nullable_to_non_nullable
              as String,
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      playStreamPath: null == playStreamPath
          ? _value.playStreamPath
          : playStreamPath // ignore: cast_nullable_to_non_nullable
              as String,
      systemMsg: null == systemMsg
          ? _value.systemMsg
          : systemMsg // ignore: cast_nullable_to_non_nullable
              as String,
      msgFilePath: freezed == msgFilePath
          ? _value.msgFilePath
          : msgFilePath // ignore: cast_nullable_to_non_nullable
              as String?,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CarouselsCopyWith<$Res>? get carousels {
    if (_value.carousels == null) {
      return null;
    }

    return $CarouselsCopyWith<$Res>(_value.carousels!, (value) {
      return _then(_value.copyWith(carousels: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_LiveRoomInfoContentCopyWith<$Res>
    implements $LiveRoomInfoContentCopyWith<$Res> {
  factory _$$_LiveRoomInfoContentCopyWith(_$_LiveRoomInfoContent value,
          $Res Function(_$_LiveRoomInfoContent) then) =
      __$$_LiveRoomInfoContentCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Carousels? carousels,
      String liveId,
      String roomId,
      String playStreamPath,
      String systemMsg,
      String? msgFilePath,
      User user});

  @override
  $CarouselsCopyWith<$Res>? get carousels;
  @override
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$_LiveRoomInfoContentCopyWithImpl<$Res>
    extends _$LiveRoomInfoContentCopyWithImpl<$Res, _$_LiveRoomInfoContent>
    implements _$$_LiveRoomInfoContentCopyWith<$Res> {
  __$$_LiveRoomInfoContentCopyWithImpl(_$_LiveRoomInfoContent _value,
      $Res Function(_$_LiveRoomInfoContent) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? carousels = freezed,
    Object? liveId = null,
    Object? roomId = null,
    Object? playStreamPath = null,
    Object? systemMsg = null,
    Object? msgFilePath = freezed,
    Object? user = null,
  }) {
    return _then(_$_LiveRoomInfoContent(
      carousels: freezed == carousels
          ? _value.carousels
          : carousels // ignore: cast_nullable_to_non_nullable
              as Carousels?,
      liveId: null == liveId
          ? _value.liveId
          : liveId // ignore: cast_nullable_to_non_nullable
              as String,
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      playStreamPath: null == playStreamPath
          ? _value.playStreamPath
          : playStreamPath // ignore: cast_nullable_to_non_nullable
              as String,
      systemMsg: null == systemMsg
          ? _value.systemMsg
          : systemMsg // ignore: cast_nullable_to_non_nullable
              as String,
      msgFilePath: freezed == msgFilePath
          ? _value.msgFilePath
          : msgFilePath // ignore: cast_nullable_to_non_nullable
              as String?,
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_LiveRoomInfoContent implements _LiveRoomInfoContent {
  const _$_LiveRoomInfoContent(
      {required this.carousels,
      required this.liveId,
      required this.roomId,
      required this.playStreamPath,
      required this.systemMsg,
      required this.msgFilePath,
      required this.user});

  factory _$_LiveRoomInfoContent.fromJson(Map<String, dynamic> json) =>
      _$$_LiveRoomInfoContentFromJson(json);

  @override
  final Carousels? carousels;
  @override
  final String liveId;
  @override
  final String roomId;
  @override
  final String playStreamPath;
  @override
  final String systemMsg;
  @override
  final String? msgFilePath;
  @override
  final User user;

  @override
  String toString() {
    return 'LiveRoomInfoContent(carousels: $carousels, liveId: $liveId, roomId: $roomId, playStreamPath: $playStreamPath, systemMsg: $systemMsg, msgFilePath: $msgFilePath, user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LiveRoomInfoContent &&
            (identical(other.carousels, carousels) ||
                other.carousels == carousels) &&
            (identical(other.liveId, liveId) || other.liveId == liveId) &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.playStreamPath, playStreamPath) ||
                other.playStreamPath == playStreamPath) &&
            (identical(other.systemMsg, systemMsg) ||
                other.systemMsg == systemMsg) &&
            (identical(other.msgFilePath, msgFilePath) ||
                other.msgFilePath == msgFilePath) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, carousels, liveId, roomId,
      playStreamPath, systemMsg, msgFilePath, user);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LiveRoomInfoContentCopyWith<_$_LiveRoomInfoContent> get copyWith =>
      __$$_LiveRoomInfoContentCopyWithImpl<_$_LiveRoomInfoContent>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LiveRoomInfoContentToJson(
      this,
    );
  }
}

abstract class _LiveRoomInfoContent implements LiveRoomInfoContent {
  const factory _LiveRoomInfoContent(
      {required final Carousels? carousels,
      required final String liveId,
      required final String roomId,
      required final String playStreamPath,
      required final String systemMsg,
      required final String? msgFilePath,
      required final User user}) = _$_LiveRoomInfoContent;

  factory _LiveRoomInfoContent.fromJson(Map<String, dynamic> json) =
      _$_LiveRoomInfoContent.fromJson;

  @override
  Carousels? get carousels;
  @override
  String get liveId;
  @override
  String get roomId;
  @override
  String get playStreamPath;
  @override
  String get systemMsg;
  @override
  String? get msgFilePath;
  @override
  User get user;
  @override
  @JsonKey(ignore: true)
  _$$_LiveRoomInfoContentCopyWith<_$_LiveRoomInfoContent> get copyWith =>
      throw _privateConstructorUsedError;
}

Carousels _$CarouselsFromJson(Map<String, dynamic> json) {
  return _Carousels.fromJson(json);
}

/// @nodoc
mixin _$Carousels {
  String get carouselTime => throw _privateConstructorUsedError;
  List<String> get carousels => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CarouselsCopyWith<Carousels> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarouselsCopyWith<$Res> {
  factory $CarouselsCopyWith(Carousels value, $Res Function(Carousels) then) =
      _$CarouselsCopyWithImpl<$Res, Carousels>;
  @useResult
  $Res call({String carouselTime, List<String> carousels});
}

/// @nodoc
class _$CarouselsCopyWithImpl<$Res, $Val extends Carousels>
    implements $CarouselsCopyWith<$Res> {
  _$CarouselsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? carouselTime = null,
    Object? carousels = null,
  }) {
    return _then(_value.copyWith(
      carouselTime: null == carouselTime
          ? _value.carouselTime
          : carouselTime // ignore: cast_nullable_to_non_nullable
              as String,
      carousels: null == carousels
          ? _value.carousels
          : carousels // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CarouselsCopyWith<$Res> implements $CarouselsCopyWith<$Res> {
  factory _$$_CarouselsCopyWith(
          _$_Carousels value, $Res Function(_$_Carousels) then) =
      __$$_CarouselsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String carouselTime, List<String> carousels});
}

/// @nodoc
class __$$_CarouselsCopyWithImpl<$Res>
    extends _$CarouselsCopyWithImpl<$Res, _$_Carousels>
    implements _$$_CarouselsCopyWith<$Res> {
  __$$_CarouselsCopyWithImpl(
      _$_Carousels _value, $Res Function(_$_Carousels) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? carouselTime = null,
    Object? carousels = null,
  }) {
    return _then(_$_Carousels(
      carouselTime: null == carouselTime
          ? _value.carouselTime
          : carouselTime // ignore: cast_nullable_to_non_nullable
              as String,
      carousels: null == carousels
          ? _value._carousels
          : carousels // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Carousels implements _Carousels {
  const _$_Carousels(
      {required this.carouselTime, required final List<String> carousels})
      : _carousels = carousels;

  factory _$_Carousels.fromJson(Map<String, dynamic> json) =>
      _$$_CarouselsFromJson(json);

  @override
  final String carouselTime;
  final List<String> _carousels;
  @override
  List<String> get carousels {
    if (_carousels is EqualUnmodifiableListView) return _carousels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_carousels);
  }

  @override
  String toString() {
    return 'Carousels(carouselTime: $carouselTime, carousels: $carousels)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Carousels &&
            (identical(other.carouselTime, carouselTime) ||
                other.carouselTime == carouselTime) &&
            const DeepCollectionEquality()
                .equals(other._carousels, _carousels));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, carouselTime,
      const DeepCollectionEquality().hash(_carousels));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CarouselsCopyWith<_$_Carousels> get copyWith =>
      __$$_CarouselsCopyWithImpl<_$_Carousels>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CarouselsToJson(
      this,
    );
  }
}

abstract class _Carousels implements Carousels {
  const factory _Carousels(
      {required final String carouselTime,
      required final List<String> carousels}) = _$_Carousels;

  factory _Carousels.fromJson(Map<String, dynamic> json) =
      _$_Carousels.fromJson;

  @override
  String get carouselTime;
  @override
  List<String> get carousels;
  @override
  @JsonKey(ignore: true)
  _$$_CarouselsCopyWith<_$_Carousels> get copyWith =>
      throw _privateConstructorUsedError;
}

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get userAvatar => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({String userAvatar, String userName, String userId, int level});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userAvatar = null,
    Object? userName = null,
    Object? userId = null,
    Object? level = null,
  }) {
    return _then(_value.copyWith(
      userAvatar: null == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$_UserCopyWith(_$_User value, $Res Function(_$_User) then) =
      __$$_UserCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userAvatar, String userName, String userId, int level});
}

/// @nodoc
class __$$_UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res, _$_User>
    implements _$$_UserCopyWith<$Res> {
  __$$_UserCopyWithImpl(_$_User _value, $Res Function(_$_User) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userAvatar = null,
    Object? userName = null,
    Object? userId = null,
    Object? level = null,
  }) {
    return _then(_$_User(
      userAvatar: null == userAvatar
          ? _value.userAvatar
          : userAvatar // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_User implements _User {
  const _$_User(
      {required this.userAvatar,
      required this.userName,
      required this.userId,
      required this.level});

  factory _$_User.fromJson(Map<String, dynamic> json) => _$$_UserFromJson(json);

  @override
  final String userAvatar;
  @override
  final String userName;
  @override
  final String userId;
  @override
  final int level;

  @override
  String toString() {
    return 'User(userAvatar: $userAvatar, userName: $userName, userId: $userId, level: $level)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_User &&
            (identical(other.userAvatar, userAvatar) ||
                other.userAvatar == userAvatar) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.level, level) || other.level == level));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userAvatar, userName, userId, level);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserCopyWith<_$_User> get copyWith =>
      __$$_UserCopyWithImpl<_$_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String userAvatar,
      required final String userName,
      required final String userId,
      required final int level}) = _$_User;

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String get userAvatar;
  @override
  String get userName;
  @override
  String get userId;
  @override
  int get level;
  @override
  @JsonKey(ignore: true)
  _$$_UserCopyWith<_$_User> get copyWith => throw _privateConstructorUsedError;
}
