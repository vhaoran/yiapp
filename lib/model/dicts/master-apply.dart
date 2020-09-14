import 'package:yiapp/model/dicts/master-cate.dart';
import 'package:yiapp/model/dicts/master-images.dart';

import 'master-info.dart';

class MasterInfoApply {
  String id;
  MasterInfo info;
  List<MasterImages> images;
  List<MasterCate> item;
  int stat;
  String create_date;
  num create_date_int;

  MasterInfoApply({
    this.id,
    this.images,
    this.info,
    this.item,
    this.stat,
    this.create_date,
    this.create_date_int,
  });

  factory MasterInfoApply.fromJson(Map<String, dynamic> json) {
    return MasterInfoApply(
      id: json['id'],
      images: json['images'] != null
          ? (json['images'] as List)
              .map((i) => MasterImages.fromJson(i))
              .toList()
          : null,
      info: json['info'] != null ? MasterInfo.fromJson(json['info']) : null,
      item: json['item'] != null
          ? (json['item'] as List).map((i) => MasterCate.fromJson(i)).toList()
          : null,
      stat: json['stat'],
      create_date: json['create_date'],
      create_date_int: json['create_date_int'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stat'] = this.stat;
    data['create_date'] = this.create_date;
    data['create_date_int'] = this.create_date_int;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    if (this.info != null) {
      data['info'] = this.info.toJson();
    }
    if (this.item != null) {
      data['item'] = this.item.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
