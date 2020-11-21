import 'package:yiapp/model/dicts/product.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/21 下午5:57
// usage ：用户获取运营商商品分类中的商品
// ------------------------------------------------------

class BrokerProductRes {
  int broker_id;
  int cate_id;
  String cate_name;
  List<ProductColor> colors;
  int id;
  String id_of_es;
  String image_main;
  List<ProductImage> images;
  String key_word;
  String name;
  String remark;

  BrokerProductRes({
    this.broker_id,
    this.cate_id,
    this.cate_name,
    this.colors,
    this.id,
    this.id_of_es,
    this.image_main,
    this.images,
    this.key_word,
    this.name,
    this.remark,
  });

  factory BrokerProductRes.fromJson(Map<String, dynamic> json) {
    return BrokerProductRes(
      broker_id: json['broker_id'],
      cate_id: json['cate_id'],
      cate_name: json['cate_name'],
      colors: json['colors'] != null
          ? (json['colors'] as List)
              .map((i) => ProductColor.fromJson(i))
              .toList()
          : null,
      id: json['id'],
      id_of_es: json['id_of_es'],
      image_main: json['image_main'],
      images: json['images'] != null
          ? (json['images'] as List)
              .map((i) => ProductImage.fromJson(i))
              .toList()
          : null,
      key_word: json['key_word'],
      name: json['name'],
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['broker_id'] = this.broker_id;
    data['cate_id'] = this.cate_id;
    data['cate_name'] = this.cate_name;
    data['id'] = this.id;
    data['id_of_es'] = this.id_of_es;
    data['image_main'] = this.image_main;
    data['key_word'] = this.key_word;
    data['name'] = this.name;
    data['remark'] = this.remark;
    if (this.colors != null) {
      data['colors'] = this.colors.map((v) => v.toJson()).toList();
    }
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
