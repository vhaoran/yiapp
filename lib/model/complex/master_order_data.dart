import 'package:yiapp/model/orders/yiOrder-heHun.dart';
import 'package:yiapp/model/orders/yiOrder-liuyao.dart';
import 'package:yiapp/model/orders/yiOrder-sizhu.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/28 下午3:09
// usage ：提交大师订单的数据
// ------------------------------------------------------

class MasterOrderData {
  int master_id;
  String comment;
  int yi_cate_id;
  YiOrderSiZhu siZhu; // 四柱
  YiOrderHeHun heHun; // 合婚
  YiOrderLiuYao liuYao; // 六爻

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
    siZhu = json['siZhu'] != null ? YiOrderSiZhu.fromJson(json['siZhu']) : null;
    heHun = json['heHun'] != null ? YiOrderHeHun.fromJson(json['heHun']) : null;
    liuYao =
        json['liuYao'] != null ? YiOrderLiuYao.fromJson(json['liuYao']) : null;
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

  bool type() {

  }
}
