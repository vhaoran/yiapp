import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/model/orders/hehun_content.dart';
import 'package:yiapp/model/orders/sizhu_content.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/swicht_util.dart';
import 'package:yiapp/util/time_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/21 上午11:42
// usage ：帖子通用的基本信息
// usage : 含姓名、性别、出生日期、测算类型、标题、内容
// ------------------------------------------------------

class PostComDetail extends StatelessWidget {
  final BBSPrize prize;
  final BBSVie vie;

  PostComDetail({this.prize, this.vie, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: S.h(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(height: 0, thickness: 0.2, color: t_gray),
          if (prize != null) _prizeDetail(prize),
          if (vie != null) _vieDetail(vie),
          Divider(height: 0, thickness: 0.2, color: t_gray),
        ],
      ),
    );
  }

  /// 悬赏帖帖子信息
  Widget _prizeDetail(BBSPrize prize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (prize.content_type == submit_sizhu) _prizeSiZhu(prize), // 悬赏帖四柱
        if (prize.content_type == submit_hehun) _prizeHeHun(prize), // 悬赏帖合婚
        if (prize.content_type == submit_liuyao) _prizeLiuYao(prize), // 悬赏帖六爻
        _tip(tip: "所问类型", text: SwitchUtil.contentType(prize?.content_type)),
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          child: Text(
            "标题：",
            style: TextStyle(color: t_gray, fontSize: S.sp(16)),
          ),
        ),
        Text(
          prize?.title ?? "",
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
          prize?.brief ?? "",
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
        SizedBox(height: S.h(5)),
      ],
    );
  }

  /// 显示悬赏帖四柱的内容
  Widget _prizeSiZhu(BBSPrize prize) {
    SiZhuContent content = prize.content as SiZhuContent;
    String name = "";
    if (content.name == null || content.name.isEmpty) {
      name = "匿名";
    } else {
      name = content.name;
    }
    var date;
    if (content.is_solar) {
      date = prize.toDateTime();
    } else {
      date = YiDateTime().fromDateTime(prize.toDateTime()).toSolar();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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

  /// 显示悬赏帖合婚的内容
  Widget _prizeHeHun(BBSPrize prize) {
    HeHunContent content = prize.content as HeHunContent;
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

  /// 显示悬赏帖六爻的内容
  Widget _prizeLiuYao(BBSPrize prize) {
    return Column(
      children: <Widget>[
        Text(
          "这是 六爻 待显示的区域",
          style: TextStyle(color: Colors.yellow, fontSize: S.sp(18)),
        ),
      ],
    );
  }

  /// ----------------------- 以下是闪断帖 -----------------------

  /// 闪断帖帖子信息
  Widget _vieDetail(BBSVie vie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (vie.content_type == submit_sizhu) _vieSiZhu(vie), // 闪断帖四柱
        if (vie.content_type == submit_hehun) _vieHeHun(vie), // 闪断帖合婚
        if (vie.content_type == submit_liuyao) _vieLiuYao(vie), // 闪断帖六爻
        _tip(tip: "所问类型", text: SwitchUtil.contentType(vie?.content_type)),
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          child: Text(
            "标题：",
            style: TextStyle(color: t_gray, fontSize: S.sp(16)),
          ),
        ),
        Text(
          vie?.title ?? "",
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
          vie?.brief ?? "",
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
        SizedBox(height: S.h(5)),
      ],
    );
  }

  /// 显示闪断帖四柱的内容
  Widget _vieSiZhu(BBSVie vie) {
    SiZhuContent content = vie.content as SiZhuContent;
    String name = "";
    if (content.name == null || content.name.isEmpty) {
      name = "匿名";
    } else {
      name = content.name;
    }
    var date;
    if (content.is_solar) {
      date = vie.toDateTime();
    } else {
      date = YiDateTime().fromDateTime(vie.toDateTime()).toSolar();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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

  /// 显示闪断帖合婚的内容
  Widget _vieHeHun(BBSVie vie) {
    HeHunContent content = vie.content as HeHunContent;
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

  /// 显示闪断帖六爻的内容
  Widget _vieLiuYao(BBSVie vie) {
    return Column(
      children: <Widget>[
        Text(
          "这是 六爻 待显示的区域",
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
}
