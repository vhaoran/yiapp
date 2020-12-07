import 'package:yiapp/model/orders/productOrder-addr.dart';
import 'package:yiapp/model/orders/productOrder-item.dart';

class ProductOrder {
  ProductOrderAddr addr;
  String create_date;
  num amt;
  String bill_no;
  int broker_id;
  String broker_name;
  String contact;
  int create_time_int;
  String deliver;
  String delivery_time;
  String icon;
  String id;
  List<ProductOrderItem> items;
  String last_updated;
  String nick;
  int pay_type;
  int stat;
  int uid;

  ProductOrder({
    this.addr,
    this.create_date,
    this.amt,
    this.bill_no,
    this.broker_id,
    this.broker_name,
    this.contact,
    this.create_time_int,
    this.deliver,
    this.delivery_time,
    this.icon,
    this.id,
    this.items,
    this.last_updated,
    this.nick,
    this.pay_type,
    this.stat,
    this.uid,
  });

  factory ProductOrder.fromJson(Map<String, dynamic> json) {
    return ProductOrder(
      addr:
          json['Addr'] != null ? ProductOrderAddr.fromJson(json['Addr']) : null,
      create_date: json['CreateDate'],
      amt: json['amt'],
      bill_no: json['bill_no'],
      broker_id: json['broker_id'],
      broker_name: json['broker_name'],
      contact: json['contact'],
      create_time_int: json['create_time_int'],
      deliver: json['deliver'],
      delivery_time: json['delivery_time'],
      icon: json['icon'],
      id: json['id'],
      items: json['items'] != null
          ? (json['items'] as List)
              .map((i) => ProductOrderItem.fromJson(i))
              .toList()
          : null,
      last_updated: json['last_updated'],
      nick: json['nick'],
      pay_type: json['pay_type'],
      stat: json['stat'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CreateDate'] = this.create_date;
    data['amt'] = this.amt;

    data['bill_no'] = this.bill_no;
    data['broker_id'] = this.broker_id;
    data['broker_name'] = this.broker_name;

    data['contact'] = this.contact;
    data['create_time_int'] = this.create_time_int;
    data['deliver'] = this.deliver;
    data['delivery_time'] = this.delivery_time;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['last_updated'] = this.last_updated;
    data['nick'] = this.nick;
    data['pay_type'] = this.pay_type;
    data['stat'] = this.stat;
    data['uid'] = this.uid;
    if (this.addr != null) {
      data['Addr'] = this.addr.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
