import 'bbs_reply.dart';
import 'bbs_content.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/18 上午10:55
// usage ：闪断贴数据结构
// ------------------------------------------------------

class BBSVie {
  num amt;
  String brief;
  int broker_id;
  String broker_name;
  int content_type;
  String create_date;
  int create_data_int;
  String icon;
  String id;
  String last_updated;
  int last_updated_int;
  int level_id;
  String master_icon;
  int master_id;
  String master_nick;
  String nick;
  int stat;
  String title;
  int uid;
  BBSReply last_reply;
  PostContentRes content;
  List<String> images;
  List<BBSReply> reply;

  BBSVie({
    this.amt,
    this.brief,
    this.broker_id,
    this.broker_name,
    this.content_type,
    this.create_date,
    this.create_data_int,
    this.icon,
    this.id,
    this.last_updated,
    this.last_updated_int,
    this.level_id,
    this.master_icon,
    this.master_id,
    this.master_nick,
    this.nick,
    this.stat,
    this.title,
    this.uid,
    this.last_reply,
    this.content,
    this.images,
    this.reply,
  });

  factory BBSVie.fromJson(Map<String, dynamic> json) {
    return BBSVie(
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
      last_updated_int: json['last_updated_int'],
      level_id: json['level_id'],
      master_icon: json['master_icon'],
      master_id: json['master_id'],
      master_nick: json['master_nick'],
      nick: json['nick'],
      stat: json['stat'],
      title: json['title'],
      uid: json['uid'],
      last_reply: json['last_reply'] != null
          ? BBSReply.fromJson(json['last_reply'])
          : null,
      content: PostContentRes.fromJson(json['content']),
      images:
          json['images'] != null ? new List<String>.from(json['images']) : null,
      reply: json['reply'] != null
          ? (json['reply'] as List).map((i) => BBSReply.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    data['last_updated_int'] = this.last_updated_int;
    data['level_id'] = this.level_id;
    data['master_icon'] = this.master_icon;
    data['master_id'] = this.master_id;
    data['master_nick'] = this.master_nick;
    data['nick'] = this.nick;
    data['stat'] = this.stat;
    data['title'] = this.title;
    data['uid'] = this.uid;
    if (this.last_reply != null) {
      data['last_reply'] = this.last_reply.toJson();
    }
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

  DateTime toDateTime() {
    return DateTime(
      this.content.year,
      this.content.month,
      this.content.day,
      this.content.hour,
      this.content?.minutes ?? 00, // 六爻没有分
    );
  }
}
