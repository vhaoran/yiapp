import 'package:yiapp/model/bbs/bbs_content.dart';
import 'bbs-Reply.dart';

class BBSPrize {
  num amt;
  String brief;
  int broker_id;
  String broker_name;
  PostContentRes content;
  int content_type;
  String create_date;
  int create_data_int;
  String icon;
  String id;
  List<String> images;
  String last_updated;
  int level_id;
  String nick;
  List<BBSReply> reply;
  int stat;
  String title;
  int uid;
  // TODO 这里还有一个 List rewards; 暂时不知道用法
  BBSPrize({
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
    this.nick,
    this.reply,
    this.stat,
    this.title,
    this.uid,
  });

  factory BBSPrize.fromJson(Map<String, dynamic> json) {
    // todo
    //-----------以此处根据不同的content-type-------------------------------------
    // 来决定解析content为不同的数据结构
    var c = null;
    int i = json['content_type'] as int;
//    c = json["content"];
    c = json["content"] != null
        ? PostContentRes.fromJson(json['content'])
        : null;

    if (i == 0) {}
    if (i == 1) {}
    if (i == 2) {}

    return BBSPrize(
      amt: json['amt'],
      brief: json['brief'],
      broker_id: json['broker_id'],
      broker_name: json['broker_name'],
      content_type: json['content_type'],
      create_date: json['create_date'],
      create_data_int: json['create_data_int'],
      icon: json['icon'],
      id: json['id'],
      last_updated: json['last_updated'],
      level_id: json['level_id'],
      nick: json['nick'],
      stat: json['stat'],
      title: json['title'],
      uid: json['uid'],
      content: c,
      images:
          json['images'] != null ? new List<String>.from(json['images']) : null,
      reply: json['reply'] != null
          ? (json['reply'] as List).map((i) => BBSReply.fromJson(i)).toList()
          : null,
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
    data['nick'] = this.nick;
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
