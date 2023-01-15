// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_LiveInfo _$$_LiveInfoFromJson(Map<String, dynamic> json) => _$_LiveInfo(
      coverPath: json['coverPath'] as String,
      ctime: json['ctime'] as String,
      liveId: json['liveId'] as String,
      roomId: json['roomId'] as String?,
      liveType: json['liveType'] as int,
      title: json['title'] as String,
      liveMode: json['liveMode'] as int,
      status: json['status'] as int,
      userInfo: UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_LiveInfoToJson(_$_LiveInfo instance) =>
    <String, dynamic>{
      'coverPath': instance.coverPath,
      'ctime': instance.ctime,
      'liveId': instance.liveId,
      'roomId': instance.roomId,
      'liveType': instance.liveType,
      'title': instance.title,
      'liveMode': instance.liveMode,
      'status': instance.status,
      'userInfo': instance.userInfo.toJson(),
    };

_$_UserInfo _$$_UserInfoFromJson(Map<String, dynamic> json) => _$_UserInfo(
      avatar: json['avatar'] as String,
      nickname: json['nickname'] as String,
      teamLogo: json['teamLogo'] as String,
      userId: json['userId'] as String,
    );

Map<String, dynamic> _$$_UserInfoToJson(_$_UserInfo instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'nickname': instance.nickname,
      'teamLogo': instance.teamLogo,
      'userId': instance.userId,
    };

_$_LiveData _$$_LiveDataFromJson(Map<String, dynamic> json) => _$_LiveData(
      content:
          LiveDataContent.fromJson(json['content'] as Map<String, dynamic>),
      message: json['message'] as String,
      status: json['status'] as int,
      success: json['success'] as bool,
    );

Map<String, dynamic> _$$_LiveDataToJson(_$_LiveData instance) =>
    <String, dynamic>{
      'content': instance.content.toJson(),
      'message': instance.message,
      'status': instance.status,
      'success': instance.success,
    };

_$_LiveDataContent _$$_LiveDataContentFromJson(Map<String, dynamic> json) =>
    _$_LiveDataContent(
      liveList: (json['liveList'] as List<dynamic>)
          .map((e) => LiveInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      next: json['next'] as String,
      slideUpAndDown: json['slideUpAndDown'] as bool,
    );

Map<String, dynamic> _$$_LiveDataContentToJson(_$_LiveDataContent instance) =>
    <String, dynamic>{
      'liveList': instance.liveList.map((e) => e.toJson()).toList(),
      'next': instance.next,
      'slideUpAndDown': instance.slideUpAndDown,
    };

_$_LiveRoomInfo _$$_LiveRoomInfoFromJson(Map<String, dynamic> json) =>
    _$_LiveRoomInfo(
      content:
          LiveRoomInfoContent.fromJson(json['content'] as Map<String, dynamic>),
      message: json['message'] as String,
      status: json['status'] as int,
      success: json['success'] as bool,
    );

Map<String, dynamic> _$$_LiveRoomInfoToJson(_$_LiveRoomInfo instance) =>
    <String, dynamic>{
      'content': instance.content.toJson(),
      'message': instance.message,
      'status': instance.status,
      'success': instance.success,
    };

_$_LiveRoomInfoContent _$$_LiveRoomInfoContentFromJson(
        Map<String, dynamic> json) =>
    _$_LiveRoomInfoContent(
      carousels: json['carousels'] == null
          ? null
          : Carousels.fromJson(json['carousels'] as Map<String, dynamic>),
      liveId: json['liveId'] as String,
      roomId: json['roomId'] as String,
      playStreamPath: json['playStreamPath'] as String,
      systemMsg: json['systemMsg'] as String,
      msgFilePath: json['msgFilePath'] as String?,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_LiveRoomInfoContentToJson(
        _$_LiveRoomInfoContent instance) =>
    <String, dynamic>{
      'carousels': instance.carousels?.toJson(),
      'liveId': instance.liveId,
      'roomId': instance.roomId,
      'playStreamPath': instance.playStreamPath,
      'systemMsg': instance.systemMsg,
      'msgFilePath': instance.msgFilePath,
      'user': instance.user.toJson(),
    };

_$_Carousels _$$_CarouselsFromJson(Map<String, dynamic> json) => _$_Carousels(
      carouselTime: json['carouselTime'] as String,
      carousels:
          (json['carousels'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$_CarouselsToJson(_$_Carousels instance) =>
    <String, dynamic>{
      'carouselTime': instance.carouselTime,
      'carousels': instance.carousels,
    };

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      userAvatar: json['userAvatar'] as String,
      userName: json['userName'] as String,
      userId: json['userId'] as String,
      level: json['level'] as int,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'userAvatar': instance.userAvatar,
      'userName': instance.userName,
      'userId': instance.userId,
      'level': instance.level,
    };
