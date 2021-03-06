import 'msg-notify.dart';

class MsgNotifyHis {
  String id;

  //这是一个整型值（用unixNano）来计数
  int create_date_int;
  String create_date;
  int to;
  bool ack;
  MsgNotify content;

  MsgNotifyHis(
      {this.ack,
      this.content,
      this.create_date_int,
      this.create_date,
      this.id,
      this.to});

  factory MsgNotifyHis.fromJson(Map<String, dynamic> json) {
    return MsgNotifyHis(
      ack: json['ack'],
      content:
          json['content'] != null ? MsgNotify.fromJson(json['content']) : null,
      create_date_int: json['create_date_int'],
      create_date: json['create_date'],
      id: json['id'],
      to: json['to'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ack'] = this.ack;
    data['create_date_int'] = this.create_date_int;
    data['create_date'] = this.create_date;
    data['id'] = this.id;
    data['to'] = this.to;
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    return data;
  }
}
