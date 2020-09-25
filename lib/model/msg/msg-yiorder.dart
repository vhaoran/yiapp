class MsgYiOrder {
  //消息的id
  String id;

  //大师订单的id
  String id_of_yi_order;

  //是否已经确认收 到
  bool ack;

  //消息类型 0:文本 1：语音
  int content_type;

  //消息类型 0:文本 1：语音时表示为一个路径
  String content;

  int from; //用户id-from
  String from_icon; //用户头像
  String from_nick; //用户眤称

  int to; //用户id-from-to
  String to_icon;
  String to_nick;

  String create_date;

  //用于排序 time.unixNano
  int create_date_int;

  MsgYiOrder(
      {this.ack,
      this.content,
      this.content_type,
      this.create_date,
      this.create_date_int,
      this.from,
      this.from_icon,
      this.from_nick,
      this.id,
      this.id_of_yi_order,
      this.to,
      this.to_icon,
      this.to_nick});

  factory MsgYiOrder.fromJson(Map<String, dynamic> json) {
    return MsgYiOrder(
      ack: json['ack'],
      content: json['content'],
      content_type: json['content_type'],
      create_date: json['create_date'],
      create_date_int: json['create_date_int'],
      from: json['from'],
      from_icon: json['from_icon'],
      from_nick: json['from_nick'],
      id: json['id'],
      id_of_yi_order: json['id_of_yi_order'],
      to: json['to'],
      to_icon: json['to_icon'],
      to_nick: json['to_nick'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ack'] = this.ack;
    data['content'] = this.content;
    data['content_type'] = this.content_type;
    data['create_date'] = this.create_date;
    data['create_date_int'] = this.create_date_int;
    data['from'] = this.from;
    data['from_icon'] = this.from_icon;
    data['from_nick'] = this.from_nick;
    data['id'] = this.id;
    data['id_of_yi_order'] = this.id_of_yi_order;
    data['to'] = this.to;
    data['to_icon'] = this.to_icon;
    data['to_nick'] = this.to_nick;
    return data;
  }
}
