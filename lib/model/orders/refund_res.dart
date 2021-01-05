// ------------------------------------------------------
// author：suxing
// date  ：2021/1/4 下午3:53
// usage ：投诉大师结果
// ------------------------------------------------------

class ComplaintsRes {
  String create_date;
  int amt;
  String audit_date;
  String auditor_icon;
  int auditor_id;
  String auditor_nick;
  String b_audit_date;
  String b_auditor_icon;
  int b_auditor_id;
  String b_auditor_nick;
  String b_type;
  String brief;
  int broker_id;
  String broker_name;
  int create_time_int;
  String detail;
  bool draw_back;
  String icon;
  String id;
  String last_updated;
  String master_icon;
  int master_id;
  String master_nick;
  String nick;
  String order_id;
  int stat; // 0 待审批、1 运营商已审批、4 平台已审批 -1 已驳回
  int uid;
  List<String> images;

  ComplaintsRes({
    this.create_date,
    this.amt,
    this.audit_date,
    this.auditor_icon,
    this.auditor_id,
    this.auditor_nick,
    this.b_audit_date,
    this.b_auditor_icon,
    this.b_auditor_id,
    this.b_auditor_nick,
    this.b_type,
    this.brief,
    this.broker_id,
    this.broker_name,
    this.create_time_int,
    this.detail,
    this.draw_back,
    this.icon,
    this.id,
    this.last_updated,
    this.master_icon,
    this.master_id,
    this.master_nick,
    this.nick,
    this.order_id,
    this.stat,
    this.uid,
    this.images,
  });

  factory ComplaintsRes.fromJson(Map<String, dynamic> json) {
    return ComplaintsRes(
      create_date: json['CreateDate'],
      amt: json['amt'],
      audit_date: json['audit_date'],
      auditor_icon: json['auditor_icon'],
      auditor_id: json['auditor_id'],
      auditor_nick: json['auditor_nick'],
      b_audit_date: json['b_audit_date'],
      b_auditor_icon: json['b_auditor_icon'],
      b_auditor_id: json['b_auditor_id'],
      b_auditor_nick: json['b_auditor_nick'],
      b_type: json['b_type'],
      brief: json['brief'],
      broker_id: json['broker_id'],
      broker_name: json['broker_name'],
      create_time_int: json['create_time_int'],
      detail: json['detail'],
      draw_back: json['draw_back'],
      icon: json['icon'],
      id: json['id'],
      last_updated: json['last_updated'],
      master_icon: json['master_icon'],
      master_id: json['master_id'],
      master_nick: json['master_nick'],
      nick: json['nick'],
      order_id: json['order_id'],
      stat: json['stat'],
      uid: json['uid'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['CreateDate'] = this.create_date;
    data['amt'] = this.amt;
    data['audit_date'] = this.audit_date;
    data['auditor_icon'] = this.auditor_icon;
    data['auditor_id'] = this.auditor_id;
    data['auditor_nick'] = this.auditor_nick;
    data['b_audit_date'] = this.b_audit_date;
    data['b_auditor_icon'] = this.b_auditor_icon;
    data['b_auditor_id'] = this.b_auditor_id;
    data['b_auditor_nick'] = this.b_auditor_nick;
    data['b_type'] = this.b_type;
    data['brief'] = this.brief;
    data['broker_id'] = this.broker_id;
    data['broker_name'] = this.broker_name;
    data['create_time_int'] = this.create_time_int;
    data['detail'] = this.detail;
    data['draw_back'] = this.draw_back;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['last_updated'] = this.last_updated;
    data['master_icon'] = this.master_icon;
    data['master_id'] = this.master_id;
    data['master_nick'] = this.master_nick;
    data['nick'] = this.nick;
    data['order_id'] = this.order_id;
    data['stat'] = this.stat;
    data['uid'] = this.uid;
    if (this.images != null) {
      data['images'] = this.images;
    }
    return data;
  }
}
