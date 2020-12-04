import 'package:yiapp/model/dicts/ProductCate.dart';
import 'package:yiapp/model/dicts/product.dart';

import 'api_base.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/10 09:08
// usage : 商品基本信息的维护
//
// ------------------------------------------------------
class ApiProduct {
  static final String pre = "/yi/user/";

  //------ 商品分类-列表查询--------------
  static Future<List<Category>> categoryList() async {
    var url = pre + "CategoryList";
    var data = new Map<String, dynamic>();

    return await ApiBase.postList(url, data, (l) {
      return l.map((e) => Category.fromJson(e)).toList();
    }, enableJwt: true);
  }

//-----------根据id获取商品分类-------------------------------------
  static Future<Category> categoryGet(int id) async {
    var url = pre + "CategoryGet";
    var data = {"id": id};
    return await ApiBase.postObj(url, data, (m) {
      return Category.fromJson(m);
    }, enableJwt: true);
  }

  //-----------新增商品分类-------------------------------------
  static Future<Category> categoryAdd(Map<String, dynamic> m) async {
    var url = pre + "CategoryAdd";
    var data = m;
    return await ApiBase.postObj(url, data, (m) {
      return Category.fromJson(m);
    }, enableJwt: true);
  }

  //-----------修改商品分类-------------------------------------
  static Future<bool> categoryCh(Map<String, dynamic> m) async {
    var url = pre + "CategoryCh";
    var data = m;
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //-----------移除商品分类-------------------------------------
  static Future<bool> categoryRm(int id) async {
    var url = pre + "CategoryRm";
    var data = {"id": id};

    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //-----------查询商品--分页-------------------------------------
  static productPage(Map<String, dynamic> pb) async {
    var url = pre + "ProductPage";
    return await ApiBase.postPage(url, pb, (m) => Product.fromJson(m));
  }

//-----------通过id获取商品-------------------------------------
  static Future<Product> bProductGet(String id) async {
    var url = pre + "BProductGet";
    var data = {"id_of_es": id};
    return await ApiBase.postObj(url, data, (m) {
      return Product.fromJson(m);
    }, enableJwt: true);
  }

//-----------新增商品信息-------------------------------------
  static Future<Product> productAdd(Map<String, dynamic> m) async {
    var url = pre + "ProductAdd";
    var data = m;
    return await ApiBase.postObj(url, data, (m) {
      return Product.fromJson(m);
    }, enableJwt: true);
  }

  //-----------新增商品信息-------------------------------------
  static Future<Product> productAddStruct(Product src) async {
    var url = pre + "ProductAdd";
    var data = src.toJson();
    return await ApiBase.postObj(url, data, (m) {
      return Product.fromJson(m);
    }, enableJwt: true);
  }

  //-----------修改商品信息-------------------------------------
  static Future<bool> productCh(Map<String, dynamic> m) async {
    var url = pre + "ProductCh";
    var data = m;
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //-----------通过id删除商品-------------------------------------
  static Future<bool> productRm(String id) async {
    var url = pre + "ProductRm";
    var data = {
      "id_of_es": id,
    };
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }
//------------------------------------------------
}
