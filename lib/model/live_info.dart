// This file is "main.dart"
import 'package:freezed_annotation/freezed_annotation.dart';

part 'live_info.freezed.dart';
part 'live_info.g.dart';

@freezed
class LiveInfo with _$LiveInfo {
  @JsonSerializable(explicitToJson: true)
  const factory LiveInfo({
    required String coverPath,
    required String ctime,
    required String liveId,
    required String? roomId,
    required int liveType, // 1：直播，2：电台
    required String title,
    required int liveMode, // 0: 直播/电台 1:录屏
    required int status, // 2: live 3: 重播
    required UserInfo userInfo,
  }) = _LiveInfo;
  factory LiveInfo.fromJson(Map<String, dynamic> json) =>
      _$LiveInfoFromJson(json);
}

@freezed
class UserInfo with _$UserInfo {
  const factory UserInfo({
    required String avatar,
    required String nickname,
    required String teamLogo,
    required String userId,
  }) = _UserInfo;
  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);
}

@freezed
class LiveData with _$LiveData {
  @JsonSerializable(explicitToJson: true)
  const factory LiveData({
    required LiveDataContent content,
    required String message,
    required int status,
    required bool success,
  }) = _LiveData;
  factory LiveData.fromJson(Map<String, dynamic> json) =>
      _$LiveDataFromJson(json);
}

@freezed
class LiveDataContent with _$LiveDataContent {
  @JsonSerializable(explicitToJson: true)
  const factory LiveDataContent({
    required List<LiveInfo> liveList,
    required String next,
    required bool slideUpAndDown,
  }) = _LiveDataContent;
  factory LiveDataContent.fromJson(Map<String, dynamic> json) =>
      _$LiveDataContentFromJson(json);
}

@freezed
class LiveRoomInfo with _$LiveRoomInfo {
  @JsonSerializable(explicitToJson: true)
  const factory LiveRoomInfo({
    required LiveRoomInfoContent content,
    required String message,
    required int status,
    required bool success,
  }) = _LiveRoomInfo;

  factory LiveRoomInfo.fromJson(Map<String, dynamic> json) =>
      _$LiveRoomInfoFromJson(json);
}

@freezed
class LiveRoomInfoContent with _$LiveRoomInfoContent {
  @JsonSerializable(explicitToJson: true)
  const factory LiveRoomInfoContent({
    required Carousels? carousels,
    required String liveId,
    required String roomId,
    required String playStreamPath,
    required String systemMsg,
    required String? msgFilePath,
    required User user,
  }) = _LiveRoomInfoContent;
  factory LiveRoomInfoContent.fromJson(Map<String, dynamic> json) =>
      _$LiveRoomInfoContentFromJson(json);
}

@freezed
class Carousels with _$Carousels {
  const factory Carousels({
    required String carouselTime,
    required List<String> carousels,
  }) = _Carousels;
  factory Carousels.fromJson(Map<String, dynamic> json) =>
      _$CarouselsFromJson(json);
}

@freezed
class User with _$User {
  const factory User({
    required String userAvatar,
    required String userName,
    required String userId,
    required int level,
  }) = _User;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
