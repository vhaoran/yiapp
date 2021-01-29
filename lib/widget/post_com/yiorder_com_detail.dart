import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/orders/hehun_content.dart';
import 'package:yiapp/model/orders/liuyao_content.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';
import 'package:yiapp/ui/vip/hehun/hehun_content_ui.dart';
import 'package:yiapp/ui/vip/liuyao/liuyao_content_ui.dart';
import 'package:yiapp/ui/vip/sizhu/sizhu_content_ui.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/25 下午7:01
// usage ：大师订单通用详情，含四柱、合婚、六爻
// ------------------------------------------------------

class YiOrderComDetail extends StatelessWidget {
  final dynamic yiOrderContent;

  YiOrderComDetail({this.yiOrderContent, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _detailWt();
  }

  /// 动态显示四柱、合婚、六爻的数据
  Widget _detailWt() {
    if (yiOrderContent != null) {
      if (yiOrderContent is SiZhuContent) {
        return SiZhuContentUI(siZhuContent: yiOrderContent as SiZhuContent);
      }
      if (yiOrderContent is HeHunContent) {
        return HeHunContentUI(heHunContent: yiOrderContent as HeHunContent);
      }
      if (yiOrderContent is LiuYaoContent) {
        return LiuYaoContentUI(liuYaoContent: yiOrderContent as LiuYaoContent);
      }
    }
    Log.info("未知大师订单类型");
    return SizedBox.shrink();
  }
}
