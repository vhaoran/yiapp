import 'package:flutter/material.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/complex/yi_date_time.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/swicht_util.dart';
import 'package:yiapp/util/time_util.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/model/bbs/bbs_content.dart';
import 'package:yiapp/widget/yuan_bao_ctr.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/10 上午11:56
// usage ：帖子头部信息
// ------------------------------------------------------

class PostHeader extends StatelessWidget {
  final data;

  PostHeader({this.data, Key key}) : super(key: key);

  PostContentRes _content; // 自定义的帖子内容

  @override
  Widget build(BuildContext context) {
    _content = data.content;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: S.w(10)),
      child: _co(),
    );
  }

  Widget _co() {
    var style = TextStyle(color: t_gray, fontSize: S.sp(15));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _topView(), // 头像、昵称、赏金、发帖时间
        // 帖子基本信息
        Divider(height: 0, thickness: 0.2, color: t_gray),
        if (data.content_type != post_liuyao) ...[
          _info(tip: "姓名", text: data.nick),
          _info(tip: "性别", text: _content.is_male ? "男" : "女" ?? "保密"),
        ],
        _birthDate(),
        _info(tip: "所问类型", text: SwitchUtil.contentType(data.content_type)),
        _info(tip: "标题", text: "${data.title}"),
        SizedBox(height: S.h(10)),
        Text("内容：", style: style),
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          child: Text("${data.brief}", style: style),
        ),
      ],
    );
  }

  /// 头像、昵称、赏金、发帖时间
  Widget _topView() {
    var style1 = TextStyle(color: t_gray, fontSize: S.sp(15));
    var style2 = TextStyle(color: t_primary, fontSize: S.sp(15));
    return ListTile(
      leading: CusAvatar(url: data.icon ?? "", circle: true, size: 50), // 头像
      title: Text(data.nick ?? "", style: style2), // 昵称
      subtitle: Padding(
        padding: EdgeInsets.only(top: S.h(5)),
        child: Text(data.create_date, style: style1), // 发帖时间
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          YuanBao(),
          SizedBox(width: S.w(5)),
          Text("${data.amt}", style: style2),
        ],
      ),
      contentPadding: EdgeInsets.all(0),
    );
  }

  /// 出生日期
  Widget _birthDate() {
    var date = YiDateTime(
      year: _content.year,
      month: _content.month,
      day: _content.day,
      hour: _content.hour,
      minute: _content.minutes,
    );
    return _info(
      tip: "出生日期",
      text: TimeUtil.YMD(isSolar: _content.is_solar, date: date),
    );
  }

  /// 用户基本信息
  Widget _info({String tip, String text}) {
    return Padding(
      padding: EdgeInsets.only(top: S.h(5)),
      child: Text(
        "$tip:  $text",
        style: TextStyle(color: t_gray, fontSize: S.sp(16)),
      ),
    );
  }
}
