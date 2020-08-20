// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friend _$FriendFromJson(Map<String, dynamic> json) {
  return Friend(
      created_at: json['created_at'] as String,
      enable_circle: json['enable_circle'] as bool,
      friend_id: json['friend_id'] as num,
      friend_remark: json['friend_remark'] as String,
      icon_ref: json['icon_ref'] as String,
      id: json['id'] as num,
      nick_ref: json['nick_ref'] as String,
      no_interrupt: json['no_interrupt'] as bool,
      on_top: json['on_top'] as bool,
      source: json['source'] as num,
      strong_notify: json['strong_notify'] as bool,
      uid: json['uid'] as num,
      update_at: json['update_at'] as String,
      user_code_ref: json['user_code_ref'] as String);
}

Map<String, dynamic> _$FriendToJson(Friend instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'icon_ref': instance.icon_ref,
      'enable_circle': instance.enable_circle,
      'friend_id': instance.friend_id,
      'user_code_ref': instance.user_code_ref,
      'nick_ref': instance.nick_ref,
      'friend_remark': instance.friend_remark,
      'no_interrupt': instance.no_interrupt,
      'on_top': instance.on_top,
      'source': instance.source,
      'strong_notify': instance.strong_notify,
      'update_at': instance.update_at,
      'created_at': instance.created_at
    };
