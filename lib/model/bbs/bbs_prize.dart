import 'package:yiapp/model/bbs/bbs_content.dart';
import 'package:yiapp/model/bbs/prize_master_reply.dart';
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
  PostContentRes content;
  List<String> images;
  List<BBSPrizeReply> master_reply;
  // TODO 这里还有一个 List rewards; 暂时不知道用法

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
    // TODO 根据不同的 content-type,来决定解析 content 为不同的数据结构
    var content = null;
    int i = json['content_type'] as int;
    print(">>>iiiiii:$i");
    if (i == 0) {}
    if (i == 1) {}
    if (i == 2) {}
    // 当前暂未设置其它分类，先直接解析
    content = json["content"] != null
        ? PostContentRes.fromJson(json['content'])
        : null;
    print(">>>content:$content");
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
}
