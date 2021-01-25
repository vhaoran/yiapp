import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/model/bbs/submit_hehun_data.dart';
import 'package:yiapp/model/bbs/submit_liuyao_data.dart';
import 'package:yiapp/model/bbs/submit_sizhu_data.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/swicht_util.dart';
import 'package:yiapp/util/time_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/25 下午7:01
// usage ：大师订单通用详情，含四柱、合婚、六爻
// ------------------------------------------------------

class YiOrderComDetail extends StatelessWidget {
  final dynamic yiOrderData;

  YiOrderComDetail({this.yiOrderData, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: S.h(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(height: 0, thickness: 0.2, color: t_gray),
          _detailViewWt(),
          Divider(height: 0, thickness: 0.2, color: t_gray),
        ],
      ),
    );
  }

  /// 动态显示四柱、合婚、六爻的数据
  Widget _detailViewWt() {
    if (yiOrderData != null) {
      if (yiOrderData is SubmitSiZhuData) {
        return _siZhuDetailWt(yiOrderData as SubmitSiZhuData);
      }
      if (yiOrderData is SubmitHeHunData) {
        return _heHunDetailWt(yiOrderData as SubmitHeHunData);
      }
      if (yiOrderData is SubmitHeHunData) {
        return _liuYaoDetailWt(yiOrderData as SubmitLiuYaoData);
      }
    }
    return SizedBox.shrink();
  }

  /// 四柱详情
  Widget _siZhuDetailWt(SubmitSiZhuData sizhu) {
    SiZhuContent content = sizhu.content;
    String name = "";
    if (content.name == null || content.name.isEmpty) {
      name = "匿名";
    } else {
      name = content.name;
    }
    var date;
    if (content.is_solar) {
      date = content.toDateTime();
    } else {
      date = YiDateTime().fromDateTime(content.toDateTime()).toSolar();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 大师订单四柱
        _tip(tip: "姓名", text: name),
        _tip(tip: "性别", text: content.is_male ? "男" : "女" ?? "保密"),
        _tip(
          tip: "出生日期",
          text: TimeUtil.YMDHM(
              comment: true, isSolar: content.is_solar, date: date),
        ),
        _comDetailWt(sizhu),
      ],
    );
  }

  /// 显示大师订单合婚的内容
  Widget _heHunDetailWt(SubmitHeHunData prize) {
    return Column(
      children: <Widget>[
        Text(
          "这是大师订单 合婚 待显示的区域",
          style: TextStyle(color: Colors.yellow, fontSize: S.sp(18)),
        ),
      ],
    );
  }

  /// 显示大师订单六爻的内容
  Widget _liuYaoDetailWt(SubmitLiuYaoData prize) {
    return Column(
      children: <Widget>[
        Text(
          "这是大师订单 六爻 待显示的区域",
          style: TextStyle(color: Colors.yellow, fontSize: S.sp(18)),
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
        style: TextStyle(color: t_gray, fontSize: S.sp(16)),
      ),
    );
  }

  /// 四柱、合婚、六爻
  Widget _comDetailWt(dynamic data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _tip(tip: "所问类型", text: SwitchUtil.contentType(data.content_type)),
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          child: Text(
            "标题：",
            style: TextStyle(color: t_gray, fontSize: S.sp(16)),
          ),
        ),
        Text(
          data.title ?? "",
          style: TextStyle(color: t_gray, fontSize: S.sp(16)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          child: Text(
            "内容：",
            style: TextStyle(color: t_gray, fontSize: S.sp(16)),
          ),
        ),
        Text(
          data.brief ?? "",
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
        SizedBox(height: S.h(5)),
      ],
    );
  }
}
