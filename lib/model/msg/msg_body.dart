import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MsgBody {
  String id;
  int msg_type;

  int from_uid;
  String from_user_code;
  String from_icon;
  String from_nick;

  int to_uid;
  String to_user_code;
  String to_nick;
  String to_icon;

  int to_gid;
  String to_gicon;
  String to_gname;

  int body_type;
  dynamic body;
  int not_read_count;
  int on_top;
  int no_disturb;

  int created;
  String created_at;

  T getBody<T>({T tranFn(e)}) {
    if (tranFn == null) {
      return this.body as T;
    }
    return tranFn(this.body);
  }

  factory MsgBody.fromJsonStr(String jsonStr) {
    if (jsonStr == null || jsonStr.length <= 0) {
      return null;
    }

    try {
      var m = jsonDecode(jsonStr);
      MsgBody bean = MsgBody.fromJson(m);
      return bean;
    } catch (e) {
      print("***error:" + e.toString());
      return null;
    }
  }

  MsgBody(
      {this.body,
      this.body_type,
      this.created,
      this.created_at,
      this.from_icon,
      this.from_nick,
      this.from_uid,
      this.from_user_code,
      this.id,
      this.msg_type,
      this.to_gicon,
      this.to_gid,
      this.to_gname,
      this.to_icon,
      this.to_nick,
      this.to_uid,
      this.not_read_count,
      this.on_top,
      this.to_user_code});

  factory MsgBody.fromJson(Map<String, dynamic> json) {
    return MsgBody(
        body: json['body'],
        body_type: json['body_type'] as num,
        created: json['created'] as int,
        created_at: json['created_at'] as String,
        from_icon: json['from_icon'] as String,
        from_nick: json['from_nick'] as String,
        from_uid: json['from_uid'] as int,
        from_user_code: json['from_user_code'] as String,
        id: json['id'] as String,
        msg_type: json['msg_type'] as int,
        to_gicon: json['to_gicon'] as String,
        to_gid: json['to_gid'] as int,
        to_gname: json['to_gname'] as String,
        to_icon: json['to_icon'] as String,
        to_nick: json['to_nick'] as String,
        to_uid: json['to_uid'] as int,
        not_read_count: json['not_read_count'] as int,
        on_top: json['on_top'] as int,
        to_user_code: json['to_user_code'] as String);
  }

  Map<String, dynamic> toJson() {
    var instance = this;
    return <String, dynamic>{
      'body': instance.body,
      'body_type': instance.body_type,
      'created': instance.created,
      'created_at': instance.created_at,
      'from_icon': instance.from_icon,
      'from_nick': instance.from_nick,
      'from_uid': instance.from_uid,
      'from_user_code': instance.from_user_code,
      'id': instance.id,
      'msg_type': instance.msg_type,
      'to_gicon': instance.to_gicon,
      'to_gid': instance.to_gid,
      'to_gname': instance.to_gname,
      'to_icon': instance.to_icon,
      'to_nick': instance.to_nick,
      'to_uid': instance.to_uid,
      'not_read_count': instance.not_read_count,
      'on_top': instance.on_top,
      'to_user_code': instance.to_user_code
    };
  }
}
