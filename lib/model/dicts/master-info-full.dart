import 'package:yiapp/model/dicts/master-cate.dart';
import 'package:yiapp/model/dicts/master-images.dart';

import 'master-info.dart';

// ------------------------------------------------------
// author: whr    除本人外请勿更改，如果确有必要，请征得本人同意
// date  : 2020/9/9 15:03
// usage : 大师个人全部信息
// ------------------------------------------------------
class MasterInfoFull {
  //个人信息
  MasterInfo info;

  //图片介绍
  List<MasterImages> images;

  //服务项目
  List<MasterCate> items;

  MasterInfoFull({this.info, this.items, this.images});

  factory MasterInfoFull.fromJson(Map<String, dynamic> m) {
    MasterInfoFull src = new MasterInfoFull();

    src.info = MasterInfo?.fromJson(m["info"]);
    src.images =
        (m["images"] as List)?.map((x) => MasterImages.fromJson(x))?.toList();
    src.items =
        (m["items"] as List)?.map((x) => MasterCate.fromJson(x))?.toList();

    return src;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['info'] = this.info?.toJson();
    data["items"] = this.items?.map((e) => e.toJson())?.toList();
    data["images"] = this.images?.map((e) => e.toJson())?.toList();

    return data;
  }
}
