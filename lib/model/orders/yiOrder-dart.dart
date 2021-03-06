import 'package:yiapp/model/orders/hehun_content.dart';
import 'package:yiapp/model/orders/liuyao_content.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/29 上午11:27
// usage ：大师订单结果
// ------------------------------------------------------

class YiOrder {
  String id; // 订单 id
  // 用户id
  int uid;
  String user_code;
  String nick_ref;
  String icon_ref;
  // 大师id
  int master_id;
  String master_user_code_ref;
  String master_nick_ref;
  String master_icon_ref;
  String comment; // 摘要
  int content_type; // 订单类型	 0 其它，1 六爻，2 四柱，3 合婚
  // 自定义内容
  dynamic content;
  int amt; // 赏金
  String create_date;
  int create_date_int;
  int pay_type; // 支付类型：0 余额付款、1 支付宝 、2 微信
  String trade_no; // 第三方付款单号
  int stat; // 订单状态	0:待付款 1：已付款 3 已处理  4 已退款
  int broker_id;
  String broker_name;
  String diagnose; // 测算结果
  String last_updated;
  num pay_amt;
  int yi_cate_id;
  bool has_exp; // 是否已评价

  YiOrder({
    this.amt,
    this.comment,
    this.content,
    this.create_date,
    this.create_date_int,
    this.icon_ref,
    this.id,
    this.master_icon_ref,
    this.master_id,
    this.master_nick_ref,
    this.master_user_code_ref,
    this.nick_ref,
    this.content_type,
    this.pay_type,
    this.stat,
    this.trade_no,
    this.uid,
    this.user_code,
    this.broker_id,
    this.broker_name,
    this.diagnose,
    this.last_updated,
    this.pay_amt,
    this.yi_cate_id,
    this.has_exp,
  });

  factory YiOrder.fromJson(Map<String, dynamic> json) {
    ////订单类型	 0：四柱 1：六爻 3:合婚   20 其它
    int i = json['content_type'] as int;
    dynamic ct = null;
    if (json['content'] != null) {
      switch (i) {
        case 0:
          ct = SiZhuContent.fromJson(json['content']);
          break;
        case 1:
          ct = LiuYaoContent.fromJson(json['content']);
          break;
        case 3:
          ct = HeHunContent.fromJson(json['content']);
          break;
        default:
          ct = SiZhuContent.fromJson(json['content']);
          break;
      }
    }

    return YiOrder(
      amt: json['amt'],
      comment: json['comment'],
      content: ct,
      create_date: json['create_date'],
      create_date_int: json['create_date_int'],
      icon_ref: json['icon_ref'],
      id: json['id'],
      master_icon_ref: json['master_icon_ref'],
      master_id: json['master_id'],
      master_nick_ref: json['master_nick_ref'],
      master_user_code_ref: json['master_user_code_ref'],
      nick_ref: json['nick_ref'],
      content_type: json['content_type'],
      pay_type: json['pay_type'],
      stat: json['stat'],
      trade_no: json['trade_no'],
      uid: json['uid'],
      user_code: json['user_code'],
      broker_id: json['broker_id'],
      broker_name: json['broker_name'],
      diagnose: json['diagnose'],
      last_updated: json['last_updated'],
      pay_amt: json['pay_amt'],
      yi_cate_id: json['yi_cate_id'],
      has_exp: json["has_exp"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amt'] = this.amt;
    data['comment'] = this.comment;
    data['create_date'] = this.create_date;
    data['create_date_int'] = this.create_date_int;
    data['icon_ref'] = this.icon_ref;
    data['id'] = this.id;
    data['master_icon_ref'] = this.master_icon_ref;
    data['master_id'] = this.master_id;
    data['master_nick_ref'] = this.master_nick_ref;
    data['master_user_code_ref'] = this.master_user_code_ref;
    data['nick_ref'] = this.nick_ref;
    data['content_type'] = this.content_type;
    data['pay_type'] = this.pay_type;
    data['stat'] = this.stat;
    data['trade_no'] = this.trade_no;
    data['uid'] = this.uid;
    data['user_code'] = this.user_code;
    data['broker_id'] = this.broker_id;
    data['broker_name'] = this.broker_name;
    data['diagnose'] = this.diagnose;
    data['pay_amt'] = this.pay_amt;
    data['yi_cate_id'] = this.yi_cate_id;
    data['has_exp'] = this.has_exp;
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    return data;
  }
}
