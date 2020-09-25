class MsgNotify {
  String body;
  String code;
  String comment;

  MsgNotify({this.body, this.code, this.comment});

  factory MsgNotify.fromJson(Map<String, dynamic> json) {
    return MsgNotify(
      body: json['body'],
      code: json['code'],
      comment: json['comment'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['body'] = this.body;
    data['code'] = this.code;
    data['comment'] = this.comment;
    return data;
  }
}
