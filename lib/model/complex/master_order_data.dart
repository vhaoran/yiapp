import 'package:yiapp/model/orders/hehun_res.dart';
import 'package:yiapp/model/orders/liuyao_res.dart';
import 'package:yiapp/model/orders/sizhu_res.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/28 下午3:09
// usage ：提交大师订单的数据
// ------------------------------------------------------

class MasterOrderData {
  int master_id;
  String comment;
  int yi_cate_id;
  SiZhuRes siZhu; // 四柱
  HeHunRes heHun; // 合婚
  LiuYaoRes liuYao; // 六爻

  MasterOrderData({
    this.master_id,
    this.comment,
    this.yi_cate_id,
    this.siZhu,
    this.heHun,
    this.liuYao,
  });

  MasterOrderData.fromJson(Map<String, dynamic> json) {
    master_id = json['master_id'];
    comment = json['comment'];
    yi_cate_id = json['yi_cate_id'];
    siZhu = json['siZhu'] != null ? SiZhuRes.fromJson(json['siZhu']) : null;
    heHun = json['heHun'] != null ? HeHunRes.fromJson(json['heHun']) : null;
    liuYao =
        json['liuYao'] != null ? LiuYaoRes.fromJson(json['liuYao']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['master_id'] = this.master_id;
    data['comment'] = this.comment;
    data['yi_cate_id'] = this.yi_cate_id;
    if (this.siZhu != null) data['siZhu'] = this.siZhu.toJson();
    if (this.heHun != null) data['heHun'] = this.heHun.toJson();
    if (this.liuYao != null) data['liuYao'] = this.liuYao.toJson();
    return data;
  }

  bool type() {}
}
