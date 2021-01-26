import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/model/orders/hehun_content.dart';
import 'package:yiapp/model/orders/liuyao_content.dart';
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
  final dynamic yiOrderContent;
  final String comment; //  问题描述
  final int yiCateId;

  YiOrderComDetail({
    this.yiOrderContent,
    this.comment,
    this.yiCateId,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Log.info("大师订单详情中的 yiOrderContent ${yiOrderContent.toJson()}");
    return Padding(
      padding: EdgeInsets.only(top: S.h(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(height: 0, thickness: 0.2, color: t_gray),
          _detailViewWt(),
          _comDetailWt(comment, yiCateId),
          Divider(height: 0, thickness: 0.2, color: t_gray),
        ],
      ),
    );
  }

  /// 动态显示四柱、合婚、六爻的数据
  Widget _detailViewWt() {
    if (yiOrderContent != null) {
      if (yiOrderContent is SiZhuContent) {
        return _siZhuDetailWt(yiOrderContent as SiZhuContent);
      }
      if (yiOrderContent is HeHunContent) {
        return _heHunDetailWt(yiOrderContent as HeHunContent);
      }
      if (yiOrderContent is LiuYaoContent) {
        return _liuYaoDetailWt(yiOrderContent as LiuYaoContent);
      }
    }
    return SizedBox.shrink();
  }

  /// 四柱详情
  Widget _siZhuDetailWt(SiZhuContent content) {
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
      ],
    );
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

  /// 显示大师订单六爻的内容
  Widget _liuYaoDetailWt(LiuYaoContent prize) {
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
        style: TextStyle(color: t_gray, fontSize: S.sp(15)),
      ),
    );
  }

  /// 四柱、合婚、六爻
  Widget _comDetailWt(String comment, int yiCateId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _tip(tip: "所求类型", text: "${SwitchUtil.serviceType(yiCateId)}"),
        SizedBox(height: S.h(5)),
        Text(
          "问题描述：",
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
        SizedBox(height: S.h(5)),
        Text(
          comment ?? "",
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
        SizedBox(height: S.h(5)),
      ],
    );
  }
}
