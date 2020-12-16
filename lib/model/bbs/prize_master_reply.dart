import 'package:yiapp/model/bbs/bbs_reply.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/16 上午10:38
// usage ：悬赏帖大师回复内容 master_reply
// ------------------------------------------------------

class PrizeMasterReply {
  String master_icon;
  int master_id;
  String master_nick;
  BBSReply last_reply;
  List<BBSReply> reply;

  PrizeMasterReply({
    this.master_icon,
    this.master_id,
    this.master_nick,
    this.last_reply,
    this.reply,
  });

  factory PrizeMasterReply.fromJson(Map<String, dynamic> json) {
    return PrizeMasterReply(
      master_icon: json['master_icon'],
      master_id: json['master_id'],
      master_nick: json['master_nick'],
      last_reply: json['last_reply'] != null
          ? BBSReply.fromJson(json['last_reply'])
          : null,
      reply: json['reply'] != null
          ? (json['reply'] as List).map((i) => BBSReply.fromJson(i)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['master_icon'] = this.master_icon;
    data['master_id'] = this.master_id;
    data['master_nick'] = this.master_nick;
    if (this.last_reply != null) {
      data['last_reply'] = this.last_reply.toJson();
    }
    if (this.reply != null) {
      data['reply'] = this.reply.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
