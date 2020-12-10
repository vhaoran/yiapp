// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/10 17:43
// usage : 闪断贴 数据 结构
//
// ------------------------------------------------------

import 'bbs-Reply.dart';
import 'bbs_content.dart';

class BBSVie {
  //悬赏分值
  num amt;
  //问题描述
  String brief;
  int broker_id;
  String broker_name;
  //内容，由前端自定义
  PostContentRes content;
  //内容类别 0：四柱 1：六多，由前端自定义
  int content_type;
  String create_date;
  int create_data_int;
  String icon;
  String id;
  List<String> images;
  String last_updated;
  int level_id;
  String master_icon;
  int master_id;
  String master_nick;
  String nick;
  //回复内容
  List<BBSReply> reply;
  //帖子主题
  int stat;
  String title;
  //贴子状态,-1：已取消  0：待处理 1:已抢单 2：已打赏
  int uid;

  BBSVie({
    this.amt,
    this.brief,
    this.broker_id,
    this.broker_name,
    this.content,
    this.content_type,
    this.create_date,
    this.create_data_int,
    this.icon,
    this.id,
    this.images,
    this.last_updated,
    this.level_id,
    this.master_icon,
    this.master_id,
    this.master_nick,
    this.nick,
    this.reply,
    this.stat,
    this.title,
    this.uid,
  });

  factory BBSVie.fromJson(Map<String, dynamic> json) {
    var c = PostContentRes.fromJson(json['content']);
    return BBSVie(
      amt: json['amt'],
      brief: json['brief'],
      broker_id: json['broker_id'],
      broker_name: json['broker_name'],
      content: c,
      content_type: json['content_type'],
      create_date: json['create_date'],
      create_data_int: json['create_data_int'],
      icon: json['icon'],
      id: json['id'],
      images:
          json['images'] != null ? new List<String>.from(json['images']) : null,
      last_updated: json['last_updated'],
      level_id: json['level_id'],
      master_icon: json['master_icon'],
      master_id: json['master_id'],
      master_nick: json['master_nick'],
      nick: json['nick'],
      reply: json['reply'] != null
          ? (json['reply'] as List).map((i) => BBSReply.fromJson(i)).toList()
          : null,
      stat: json['stat'],
      title: json['title'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amt'] = this.amt;
    data['brief'] = this.brief;
    data['broker_id'] = this.broker_id;
    data['broker_name'] = this.broker_name;
    data['content_type'] = this.content_type;
    data['create_date'] = this.create_date;
    data['create_data_int'] = this.create_data_int;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['last_updated'] = this.last_updated;
    data['level_id'] = this.level_id;
    data['master_icon'] = this.master_icon;
    data['master_id'] = this.master_id;
    data['master_nick'] = this.master_nick;
    data['nick'] = this.nick;
    data['stat'] = this.stat;
    data['title'] = this.title;
    data['uid'] = this.uid;
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images;
    }
    if (this.reply != null) {
      data['reply'] = this.reply.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
