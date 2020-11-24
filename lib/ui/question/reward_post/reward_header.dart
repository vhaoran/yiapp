import 'package:flutter/material.dart';
import 'package:yiapp/complex/model/yi_date_time.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/function/swicht_case.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/date_util.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_divider.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
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
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _postTop(), // 头像、昵称、赏金、发帖时间
          CusDivider(),
          _show("姓名", data.nick ?? ""),
          _show("性别", _content?.is_male ? "男" : "女" ?? "保密"),
          _show(
            "出生日期",
            DateUtil.dateYMD(isSolar: _content.is_solar, date: _yiDate),
          ),
          _show("所问类型", YiSwitch.contentType(data.content_type)),
          _show("标题", "${data.title}"),

          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 5),
            child: CusText("内容：", t_gray, 30),
          ),
          Text(
            "${data.brief}",
            style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
          ),
          CusDivider(),
        ],
      ),
    );
  }

  /// 头像、昵称、赏金、发帖时间
  Widget _postTop() {
    return ListTile(
      leading: CusAvatar(
        url: data.icon ?? "", // 头像
        circle: true,
        size: 50,
      ),
      // 昵称
      title: CusText(data.nick ?? "", t_primary, 28),
      subtitle: Padding(
        padding: EdgeInsets.only(top: Adapt.px(10)),
        child: CusText(data.create_date, t_gray, 28), // 发帖时间
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          YuanBaoCtr(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Adapt.px(15)),
            child: CusText("${data.amt}", t_primary, 28), // 赏金
          ),
        ],
      ),
      contentPadding: EdgeInsets.all(0),
    );
  }

  Widget _show(String title, subtitle) {
    return Padding(
      padding: EdgeInsets.only(bottom: Adapt.px(10)),
      child: Text(
        "$title:  $subtitle",
        style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
      ),
    );
  }
}
