import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
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
        children: <Widget>[
          Divider(height: 0, thickness: 0.2, color: t_gray),
          if (prize != null) _prizeDetail(),
          if (vie != null) _vieDetail(),
          Divider(height: 0, thickness: 0.2, color: t_gray),
        ],
      ),
    );
  }

  /// 悬赏帖帖子信息
  Widget _prizeDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 六爻没有姓名和性别，不显示
        if (prize?.content_type != post_liuyao) ...[
          _tip(tip: "姓名", text: prize?.nick ?? ""),
          _tip(tip: "性别", text: prize.content.is_male ? "男" : "女" ?? "保密"),
        ],
        _tip(
          tip: "出生日期",
          text: TimeUtil.YMD(
              isSolar: prize?.content?.is_solar, date: prize.toDateTime()),
        ),
        _tip(tip: "所问类型", text: SwitchUtil.contentType(prize?.content_type)),
        _tip(tip: "标题", text: "${prize?.title ?? ''}"),
        SizedBox(height: S.h(10)),
        Text("内容", style: TextStyle(color: t_gray, fontSize: S.sp(15))),
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          child: Text(
            prize?.brief ?? "",
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
        )
      ],
    );
  }

  /// 闪断帖帖子信息
  Widget _vieDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 六爻没有姓名和性别，不显示
        if (vie?.content_type != post_liuyao) ...[
          _tip(tip: "姓名", text: vie?.nick ?? ""),
          _tip(tip: "性别", text: vie.content.is_male ? "男" : "女" ?? "保密"),
        ],
        _tip(
          tip: "出生日期",
          text: TimeUtil.YMD(
              isSolar: vie?.content?.is_solar, date: vie.toDateTime()),
        ),
        _tip(tip: "所问类型", text: SwitchUtil.contentType(vie?.content_type)),
        _tip(tip: "标题", text: "${vie?.title ?? ''}"),
        SizedBox(height: S.h(10)),
        Text("内容", style: TextStyle(color: t_gray, fontSize: S.sp(15))),
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          child: Text(
            vie?.brief ?? "",
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
        )
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
