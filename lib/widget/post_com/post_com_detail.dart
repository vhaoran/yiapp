import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/bbs/bbs_prize.dart';
import 'package:yiapp/model/bbs/bbs_vie.dart';
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
// date  ：2021/1/21 上午11:42
// usage ：帖子通用的基本信息
// usage : 含姓名、性别、出生日期、测算类型、标题、内容
// ------------------------------------------------------

class PostComDetail extends StatefulWidget {
  final BBSPrize prize;
  final BBSVie vie;
  // 发布六爻帖子时因为有标题、摘要的输入框了，所以无需再次显示，但查看帖子时要显示
  final bool hideTitleBrief;

  PostComDetail({this.prize, this.vie, this.hideTitleBrief: false, Key key})
      : super(key: key);

  @override
  _PostComDetailState createState() => _PostComDetailState();
}

class _PostComDetailState extends State<PostComDetail> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: S.h(5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.prize != null) _prizeDetail(widget.prize),
          if (widget.vie != null) _vieDetail(widget.vie),
          if (!widget.hideTitleBrief)
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
        // 悬赏帖四柱
        if (prize.content_type == submit_sizhu)
          SiZhuContentUI(siZhuContent: prize.content as SiZhuContent),
        if (prize.content_type == submit_hehun) _prizeHeHun(prize), // 悬赏帖合婚
        // 悬赏帖六爻
        if (prize.content_type == submit_liuyao)
          LiuYaoContentUI(
            liuYaoContent: prize.content as LiuYaoContent,
          ),
        if (!widget.hideTitleBrief) ...[
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
        ],
        SizedBox(height: S.h(5)),
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

  /// ----------------------- 以下是闪断帖 -----------------------

  /// 闪断帖帖子信息
  Widget _vieDetail(BBSVie vie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 闪断帖四柱
        if (vie.content_type == submit_sizhu)
          SiZhuContentUI(siZhuContent: vie.content as SiZhuContent),
        if (vie.content_type == submit_hehun) _vieHeHun(vie), // 闪断帖合婚
        // 闪断帖六爻
        if (vie.content_type == submit_liuyao)
          LiuYaoContentUI(
            liuYaoContent: vie.content as LiuYaoContent,
          ),
        if (!widget.hideTitleBrief) ...[
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
        ],
        SizedBox(height: S.h(5)),
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
