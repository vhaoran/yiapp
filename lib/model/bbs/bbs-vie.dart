// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/10 17:43
// usage : 闪断贴 数据 结构
//
// ------------------------------------------------------

import 'bbs-Reply.dart';

class BBSVie {
  String id;
  int uid;
  String nick;
  String icon;

  int master_id;
  String master_nick;
  String master_icon;

//帖子主题
  String title;

  //问题描述
  String brief;

  //内容类别 0：四柱 1：六多，由前端自定义
  int content_type;

  ////内容，由前端自定义
  dynamic content;

  //
  List<String> images;

  //悬赏分值
  num score;

  //回复内容
  List<BBSReply> reply;

  //贴子状态,-1：已取消  0：待处理 1:已抢单 2：已打赏
  int stat;

  String create_date;
  int create_data_int;
  String last_updated;

  BBSVie(
      {this.brief,
      this.content,
      this.content_type,
      this.create_data_int,
      this.create_date,
      this.icon,
      this.id,
      this.images,
      this.last_updated,
      this.master_id,
      this.master_icon,
      this.master_nick,
      this.nick,
      this.reply,
      this.score,
      this.stat,
      this.title,
      this.uid});

  factory BBSVie.fromJson(Map<String, dynamic> json) {
    var c = json['content'];

    return BBSVie(
      brief: json['brief'],
      content: c,
      content_type: json['content_type'],
      create_data_int: json['create_data_int'],
      create_date: json['create_date'],
      icon: json['icon'],
      id: json['id'],
      images:
          json['images'] != null ? new List<String>.from(json['images']) : null,
      last_updated: json['last_updated'],
      master_id: json['master_id'],
      master_icon: json['master_icon'],
      master_nick: json['master_nick'],
      nick: json['nick'],
      reply: json['reply'] != null
          ? (json['reply'] as List).map((i) => BBSReply.fromJson(i)).toList()
          : null,
      score: json['score'],
      stat: json['stat'],
      title: json['title'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brief'] = this.brief;
    data['content_type'] = this.content_type;
    data['create_data_int'] = this.create_data_int;
    data['create_date'] = this.create_date;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['last_updated'] = this.last_updated;
    data['master_id'] = this.master_id;
    data['master_icon'] = this.master_icon;
    data['master_nick'] = this.master_nick;
    data['nick'] = this.nick;
    data['score'] = this.score;
    data['stat'] = this.stat;
    data['title'] = this.title;
    data['uid'] = this.uid;
    if (this.content != null) {
      data['content'] = this.content;
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
