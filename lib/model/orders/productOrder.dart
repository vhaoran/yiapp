import 'package:yiapp/model/orders/productOrder-addr.dart';
import 'package:yiapp/model/orders/productOrder-item.dart';

class ProductOrder {
  ProductOrderAddr addr;
  String bill_no;
  String contact;
  String createDate;
  int create_time_int;
  String deliver;
  String delivery_time;
  String id;
  List<ProductOrderItem> items;
  int pay_type;
  int stat;
  int total_amt;
  int uid;

  ProductOrder(
      {this.addr,
      this.bill_no,
      this.contact,
      this.createDate,
      this.create_time_int,
      this.deliver,
      this.delivery_time,
      this.id,
      this.items,
      this.pay_type,
      this.stat,
      this.total_amt,
      this.uid});

  factory ProductOrder.fromJson(Map<String, dynamic> json) {
    return ProductOrder(
      addr:
          json['Addr'] != null ? ProductOrderAddr.fromJson(json['Addr']) : null,
      bill_no: json['bill_no'],
      contact: json['contact'],
      createDate: json['CreateDate'],
      create_time_int: json['create_time_int'],
      deliver: json['deliver'],
      delivery_time: json['delivery_time'],
      id: json['id'],
      items: json['items'] != null
          ? (json['items'] as List)
              .map((i) => ProductOrderItem.fromJson(i))
              .toList()
          : null,
      pay_type: json['pay_type'],
      stat: json['stat'],
      total_amt: json['total_amt'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bill_no'] = this.bill_no;
    data['contact'] = this.contact;
    data['CreateDate'] = this.createDate;
    data['create_time_int'] = this.create_time_int;
    data['deliver'] = this.deliver;
    data['delivery_time'] = this.delivery_time;
    data['id'] = this.id;
    data['pay_type'] = this.pay_type;
    data['stat'] = this.stat;
    data['total_amt'] = this.total_amt;
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
