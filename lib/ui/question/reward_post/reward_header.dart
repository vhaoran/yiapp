import 'package:flutter/material.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/swicht_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/flutter/cus_divider.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/model/bbs/bbs_content.dart';
import 'package:yiapp/ui/question/yuan_bao_ctr.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 15:00
// usage ：悬赏帖头部信息
// ------------------------------------------------------

class RewardHeader extends StatelessWidget {
  final BBSPrize data;

  RewardHeader({this.data, Key key}) : super(key: key) {
    _content = data.content;
    _yiDate = YiDateTime(
      year: _content.year,
      month: _content.month,
      day: _content.day,
      hour: _content.hour,
      minute: _content.minutes,
    );
  }

  RewardContent _content;
  YiDateTime _yiDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: S.w(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _topView(), // 头像、昵称、赏金、发帖时间
          CusDivider(),
          _info(tip: "姓名", text: data.nick ?? ""),
          _info(tip: "性别", text: _content.is_male ? "男" : "女" ?? "保密"),
          _info(
            tip: "出生日期",
            text: TimeUtil.YMD(isSolar: _content.is_solar, date: _yiDate),
          ),
          _info(tip: "所问类型", text: SwitchUtil.contentType(data.content_type)),
          _info(tip: "标题", text: "${data.title}"),
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: Text(
              "内容：",
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
          ),
          Text(
            "${data.brief}",
            style: TextStyle(color: t_gray, fontSize: S.sp(15)),
          ),
          CusDivider(),
        ],
      ),
    );
  }

  /// 头像、昵称、赏金、发帖时间
  Widget _topView() {
    return ListTile(
      // 头像
      leading: CusAvatar(url: data.icon ?? "", circle: true, size: 50),
      title: Text(
        data.nick ?? "", // 昵称
        style: TextStyle(color: t_primary, fontSize: S.sp(15)),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: S.h(5)),
        child: Text(
          data.create_date, // 发帖时间
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          YuanBaoCtr(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: S.w(5)),
            child: Text(
              "${data.amt}", // 赏金
              style: TextStyle(color: t_primary, fontSize: S.sp(15)),
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.all(0),
    );
  }

  /// 用户基本信息
  Widget _info({String tip, String text}) {
    return Padding(
      padding: EdgeInsets.only(top: S.h(8)),
      child: Text(
        "$tip:  $text",
        style: TextStyle(color: t_gray, fontSize: S.sp(16)),
      ),
    );
  }
}
