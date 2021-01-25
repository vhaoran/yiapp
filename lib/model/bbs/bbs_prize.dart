import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/bbs/prize_master_reply.dart';
import 'package:yiapp/model/orders/hehun_content.dart';
import 'package:yiapp/model/orders/liuyao_content.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';
import 'bbs_reply.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/16 上午10:13
// usage ：悬赏贴数据结构
// ------------------------------------------------------

class BBSPrize {
  num amt;
  String brief;
  int broker_id;
  String broker_name;
  int content_type;
  String create_date;
  int create_date_int;
  String icon;
  String id;
  String last_updated;
  int last_updated_int;
  int level_id;
  String nick;
  int stat;
  String title;
  int uid;
  BBSReply last_reply;
  dynamic content;
  List<String> images;
  List<BBSPrizeReply> master_reply;

  BBSPrize({
    this.amt,
    this.brief,
    this.broker_id,
    this.broker_name,
    this.content_type,
    this.create_date,
    this.create_date_int,
    this.icon,
    this.id,
    this.last_updated,
    this.last_updated_int,
    this.level_id,
    this.nick,
    this.stat,
    this.title,
    this.uid,
    this.last_reply,
    this.content,
    this.images,
    this.master_reply,
  });

  factory BBSPrize.fromJson(Map<String, dynamic> json) {
    int type = json['content_type'] as int;
    var content = null;
    if (json["content"] != null) {
      // 四柱和其它目前算一个类型
      if (type == submit_other || type == submit_sizhu) {
        content = SiZhuContent.fromJson(json["content"]);
      }
      if (type == submit_liuyao) {
        content = LiuYaoContent.fromJson(json["content"]);
      }
      if (type == submit_hehun) {
        content = HeHunContent.fromJson(json["content"]);
      }
    }
    return BBSPrize(
      amt: json['amt'],
      brief: json['brief'],
      broker_id: json['broker_id'],
      broker_name: json['broker_name'],
      content_type: json['content_type'],
      create_date: json['create_date'],
      create_date_int: json['create_date_int'],
      icon: json['icon'],
      id: json['id'],
      last_updated: json['last_updated'],
      last_updated_int: json['last_updated_int'],
      level_id: json['level_id'],
      nick: json['nick'],
      stat: json['stat'],
      title: json['title'],
      uid: json['uid'],
      last_reply: json['last_reply'] != null
          ? BBSReply.fromJson(json['last_reply'])
          : null,
      content: content,
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      master_reply: json['master_reply'] != null
          ? (json['master_reply'] as List)
              .map((e) => BBSPrizeReply.fromJson(e))
              .toList()
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
    data['create_date_int'] = this.create_date_int;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['last_updated'] = this.last_updated;
    data['last_updated_int'] = this.last_updated_int;
    data['level_id'] = this.level_id;
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
    if (this.master_reply != null) {
      data['master_reply'] = this.master_reply.map((v) => v.toJson()).toList();
    }
    return data;
  }

  DateTime toDateTime() {
    return DateTime(
      this.content.year,
      this.content.month,
      this.content.day,
      this.content.hour,
      this.content.minute,
    );
  }
}
