import 'package:json_annotation/json_annotation.dart';
part 'friend.g.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/4/7 12:17
// usage : 用戶好友
//
// ------------------------------------------------------

@JsonSerializable()
class Friend {
  num id;
  num uid;
  String icon_ref;
  bool enable_circle;
  num friend_id;
  String user_code_ref;
  String nick_ref;
  String friend_remark;
  bool no_interrupt;
  bool on_top;
  num source;
  bool strong_notify;
  String update_at;
  String created_at;

  Friend(
      {this.created_at,
      this.enable_circle,
      this.friend_id,
      this.friend_remark,
      this.icon_ref,
      this.id,
      this.nick_ref,
      this.no_interrupt,
      this.on_top,
      this.source,
      this.strong_notify,
      this.uid,
      this.update_at,
      this.user_code_ref});

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

  Map<String, dynamic> toJson() => _$FriendToJson(this);
}
