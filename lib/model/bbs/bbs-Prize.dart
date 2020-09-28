import 'package:yiapp/model/bbs/bbs_content.dart';

import 'bbs-Reply.dart';

class BBSPrize {
  String id;
  int uid;
  String nick;
  String icon;
  String title;
  String brief;
  int content_type;
  RewardContent content;
  List<String> images;

  int score;
  List<BBSReply> reply;

  int stat;

  String create_date;
  int create_data_int;
  String last_updated;

  BBSPrize(
      {this.brief,
      this.content,
      this.content_type,
      this.create_data_int,
      this.create_date,
      this.icon,
      this.id,
      this.images,
      this.last_updated,
      this.nick,
      this.reply,
      this.score,
      this.stat,
      this.title,
      this.uid});

  factory BBSPrize.fromJson(Map<String, dynamic> json) {
    // todo
    //-----------以此处根据不同的content-type-------------------------------------
    // 来决定解析content为不同的数据结构
    var c = null;
    int i = json['content_type'] as int;
//    c = json["content"];
    c = json["content"] != null ? RewardContent.fromJson(json['content']) : null;

    if (i == 0) {}
    if (i == 1) {}
    if (i == 2) {}

    return BBSPrize(
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
    data['nick'] = this.nick;
    data['score'] = this.score;
    data['stat'] = this.stat;
    data['title'] = this.title;
    data['uid'] = this.uid;
    if (this.content != null) {
//      data['content'] = this.content as Map<String, dynamic>;
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
