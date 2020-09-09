import 'package:yiapp/model/dicts/master-cate.dart';
import 'package:yiapp/model/dicts/master-images.dart';

import 'master-info.dart';

class MasterInfoApply {
  String id;
  MasterInfo info;
  List<MasterImages> images;
  List<MasterCate> item;
  int stat;

  MasterInfoApply({this.id, this.images, this.info, this.item, this.stat});

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
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['stat'] = this.stat;
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
