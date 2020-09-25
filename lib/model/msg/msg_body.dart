import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

class MsgBody {
  dynamic content;
  String content_type;

  MsgBody({this.content, this.content_type});

  factory MsgBody.fromJson(Map<String, dynamic> json) {
    return MsgBody(
      content: json['content'],
      content_type: json['content_type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content_type'] = this.content_type;
    data['content'] = this.content;
    return data;
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
//------------------------------------------------
}
