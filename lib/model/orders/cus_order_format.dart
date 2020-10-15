import 'package:yiapp/model/dicts/product.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/15 11:23
// usage ：自定义订单数据格式
// ------------------------------------------------------

class CusOrderData {
  Product product; // 商品
  ProductColor color; // 当前图片的颜色和对应价格
  String path; // 图片 url
  int count; // 购买数量

  CusOrderData({this.product, this.color, this.path, this.count});

  factory CusOrderData.fromJson(Map<String, dynamic> json) {
    return CusOrderData(
      product: json['product'],
      color: json['color'],
      path: json['path'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product'] = this.product.toJson();
    data['color'] = this.color.toJson();
    data['path'] = this.path;
    data['count'] = this.count;
    return data;
  }
}
