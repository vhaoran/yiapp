import 'bank_card.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/8 下午3:03
// usage ：提现结果
// ------------------------------------------------------

class DrawMoneyRes {
  int amt; // 提现金额
  String audit_date; // 审核通过时间
  String auditor_icon; // 审核人头像
  int auditor_id; // 审核人uid
  String auditor_nick;
  String create_date;
  int create_date_int;
  String id;
  String last_updated;
  String master_icon;
  int master_id;
  String master_nick;
  String reject_reason; // 拒绝原因
  int stat; // 提现状态 0:待审批 1:取消或驳回 4:审批通过
  int tax; // 税金
  BankCard card; // 提现账号

  DrawMoneyRes({
    this.amt,
    this.audit_date,
    this.auditor_icon,
    this.auditor_id,
    this.auditor_nick,
    this.create_date,
    this.create_date_int,
    this.id,
    this.last_updated,
    this.master_icon,
    this.master_id,
    this.master_nick,
    this.reject_reason,
    this.stat,
    this.tax,
    this.card,
  });

  factory DrawMoneyRes.fromJson(Map<String, dynamic> json) {
    return DrawMoneyRes(
      amt: json['amt'],
      audit_date: json['audit_date'],
      auditor_icon: json['auditor_icon'],
      auditor_id: json['auditor_id'],
      auditor_nick: json['auditor_nick'],
      create_date: json['create_date'],
      create_date_int: json['create_date_int'],
      id: json['id'],
      last_updated: json['last_updated'],
      master_icon: json['master_icon'],
      master_id: json['master_id'],
      master_nick: json['master_nick'],
      reject_reason: json['reject_reason'],
      stat: json['stat'],
      tax: json['tax'],
      card: json['card'] != null ? BankCard.fromJson(json['card']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amt'] = this.amt;
    data['audit_date'] = this.audit_date;
    data['auditor_icon'] = this.auditor_icon;
    data['auditor_id'] = this.auditor_id;
    data['auditor_nick'] = this.auditor_nick;
    data['create_date'] = this.create_date;
    data['create_date_int'] = this.create_date_int;
    data['id'] = this.id;
    data['last_updated'] = this.last_updated;
    data['master_icon'] = this.master_icon;
    data['master_id'] = this.master_id;
    data['master_nick'] = this.master_nick;
    data['reject_reason'] = this.reject_reason;
    data['stat'] = this.stat;
    data['tax'] = this.tax;
    if (this.card != null) {
      data['card'] = this.card.toJson();
    }
    return data;
  }
}
