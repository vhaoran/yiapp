import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/model/orders/hehun_content.dart';
import 'package:yiapp/model/orders/liuyao_content.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';
import 'package:yiapp/ui/vip/sizhu/sizhu_content_ui.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/ui/vip/liuyao/liuyao_content_ui.dart';

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
        return _heHunDetailWt(yiOrderContent as HeHunContent);
      }
      if (yiOrderContent is LiuYaoContent) {
        return LiuYaoContentUI(
          liuYaoContent: yiOrderContent as LiuYaoContent,
        );
      }
    }
    return SizedBox.shrink();
  }

  /// 显示大师订单合婚的内容
  Widget _heHunDetailWt(HeHunContent content) {
    var dateMale;
    if (content.is_solar_male) {
      dateMale = content.dateTime(true);
    } else {
      dateMale = YiDateTime().fromDateTime(content.dateTime(true)).toSolar();
    }
    var dateFemale;
    if (content.is_solar_female) {
      dateFemale = content.dateTime(false);
    } else {
      dateFemale = YiDateTime().fromDateTime(content.dateTime(false)).toSolar();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _tip(tip: "所问类型", text: "合婚"),
        _tip(tip: "男方姓名", text: content.name_male),
        _tip(
          tip: "出生日期",
          text: TimeUtil.YMDHM(
            comment: true,
            isSolar: content.is_solar_male,
            date: dateMale,
          ),
        ),
        _tip(tip: "女方姓名", text: content.name_female),
        _tip(
          tip: "出生日期",
          text: TimeUtil.YMDHM(
            comment: true,
            isSolar: content.is_solar_female,
            date: dateFemale,
          ),
        ),
      ],
    );
  }

  /// 用户基本信息
  Widget _tip({String tip, String text}) {
    return Padding(
      padding: EdgeInsets.only(top: S.h(5)),
      child: Text(
        "$tip:  $text",
        style: TextStyle(color: t_gray, fontSize: S.sp(15)),
      ),
    );
  }
}
