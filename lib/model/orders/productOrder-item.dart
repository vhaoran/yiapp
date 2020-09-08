// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/8 14:19
// usage : 商城订单订货条目
// ------------------------------------------------------

class ProductOrderItem {
  //商品id
  String product_id;

  //颜色编码
  String color_code;

  //端口名称
  String name;

  //数量
  int qty;

  //价格
  num price;

  //金额
  num amt;

  ProductOrderItem(
      {this.amt,
      this.color_code,
      this.name,
      this.price,
      this.product_id,
      this.qty});

  factory ProductOrderItem.fromJson(Map<String, dynamic> json) {
    return ProductOrderItem(
      amt: json['amt'],
      color_code: json['color_code'],
      name: json['name'],
      price: json['price'],
      product_id: json['product_id'],
      qty: json['qty'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amt'] = this.amt;
    data['color_code'] = this.color_code;
    data['name'] = this.name;
    data['price'] = this.price;
    data['product_id'] = this.product_id;
    data['qty'] = this.qty;
    return data;
  }
}
