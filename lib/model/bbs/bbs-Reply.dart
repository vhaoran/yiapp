class BBSReply {
  //uid
  int uid;
  String nick;
  String icon;

  //发贴人是大师还是发贴人
  bool is_master;

  //每次发贴的内容
  List<String> text;
  String create_date;

  BBSReply(
      {this.create_date,
      this.icon,
      this.is_master,
      this.nick,
      this.text,
      this.uid});

  factory BBSReply.fromJson(Map<String, dynamic> json) {
    return BBSReply(
      create_date: json['create_date'],
      icon: json['icon'],
      is_master: json['is_master'],
      nick: json['nick'],
      text: json['text'] != null ? new List<String>.from(json['text']) : null,
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
