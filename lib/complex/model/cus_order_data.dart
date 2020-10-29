import 'package:yiapp/model/dicts/product.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/15 11:23
// usage ：自定义订单数据格式
// ------------------------------------------------------

/// 定义购物车的数据
class AllShopData {
  List<SingleShopData> shops;
  int counts = 0; // 总购买数量
  num amt = 0; // 总价

  AllShopData({this.shops}) {
    if (this.shops != null) {
      this.shops.forEach((e) {
        this.counts += e.count;
        this.amt += e.count * e.color.price;
      });
    }
  }

  factory AllShopData.fromJson(Map<String, dynamic> json) {
    return AllShopData(
      shops: json['shops'] != null
          ? (json['shops'] as List)
              .map((e) => SingleShopData.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.shops != null) {
      data['shops'] = this.shops.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

/// 单个订单的数据
class SingleShopData {
  Product product; // 商品
  ProductColor color; // 当前图片的颜色和对应价格
  String path; // 图片 url
  int count; // 购买数量

  SingleShopData({this.product, this.color, this.path, this.count});

  factory SingleShopData.fromJson(Map<String, dynamic> json) {
    return SingleShopData(
      product: json['product'] != null
          ? Product.fromJson(json['product'])
          : Product(),
      color: json['color'] != null
          ? ProductColor.fromJson(json['color'])
          : ProductColor(),
      path: json['path'],
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product.toJson();
    }
    if (this.color != null) {
      data['color'] = this.color.toJson();
    }
    data['path'] = this.path;
    data['count'] = this.count;
    return data;
  }
}
