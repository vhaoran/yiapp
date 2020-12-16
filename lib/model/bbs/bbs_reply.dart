// ------------------------------------------------------
// author：suxing
// date  ：2020/12/16 上午10:06
// usage ：单条回帖的内容
// ------------------------------------------------------

class BBSReply {
  String create_date;
  String icon;
  bool is_master; // 大师还是发贴人
  String nick;
  int uid;
  List<String> text; // 每次发贴的内容

  BBSReply({
    this.create_date,
    this.icon,
    this.is_master,
    this.nick,
    this.uid,
    this.text,
  });

  factory BBSReply.fromJson(Map<String, dynamic> json) {
    return BBSReply(
      create_date: json['create_date'],
      icon: json['icon'],
      is_master: json['is_master'],
      nick: json['nick'],
      uid: json['uid'],
      text: json['text'] != null ? List<String>.from(json['text']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['create_date'] = this.create_date;
    data['icon'] = this.icon;
    data['is_master'] = this.is_master;
    data['nick'] = this.nick;
    data['uid'] = this.uid;
    if (this.text != null) {
      data['text'] = this.text;
    }
    return data;
  }
}
