import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/yi_date_time.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_divider.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-Prize.dart';
import 'package:yiapp/model/bbs/bbs_content.dart';
import 'package:yiapp/ui/question/com_post/yuan_bao_ctr.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/23 15:00
// usage ：帖子头部
// ------------------------------------------------------

class PostHeader extends StatelessWidget {
  final BBSPrize data;

  PostHeader({this.data, Key key}) : super(key: key) {
    _content = data.content;
    _yiDate = YiDateTime(
      year: _content.year,
      month: _content.month,
      day: _content.day,
      hour: _content.hour,
      minute: _content.minutes,
    );
  }

  BBSContent _content;
  YiDateTime _yiDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _postTop(), // 头像、昵称、赏金、发帖时间
        CusDivider(),
        _show("姓名", _content?.name ?? "至尊宝"),
        _show("性别", _content?.is_male ? "男" : "女" ?? "保密"),
        _show(
          "出生日期",
          _content.is_solar
              ? "${YiTool.fullDateGong(_yiDate)}"
              : "${YiTool.fullDateNong(_yiDate)}",
        ),
        _show("所问类型", _type()),
        _show("标题", "${data.title}"),
        _show("内容", "${data.brief}"),
        CusDivider(),
      ],
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
      title: CusText(data.nick.isEmpty ? "至尊宝" : data.nick, t_primary, 28),
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
            child: CusText("${data.score}", t_primary, 28), // 赏金
          ),
        ],
      ),
      contentPadding: EdgeInsets.all(0),
    );
  }

  /// 所问类型
  String _type() {
    String str = "";
    switch (data.content_type) {
      case post_liuyao: // 六爻
        str = "六爻";
        break;
      case post_sizhu: // 四柱
        str = "四柱";
        break;
      case he_hun: // 合婚
        str = "合婚";
        break;
      default:
        str = "未知";
    }
    return str;
  }

  Widget _show(String title, subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Adapt.px(5)),
      child: Row(
        children: <Widget>[
          Text(
            "$title:",
            style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
          ),
          SizedBox(width: Adapt.px(30)),
          Text(
            "$subtitle",
            style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
          ),
        ],
      ),
    );
  }
}
