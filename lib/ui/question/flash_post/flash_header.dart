import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/yi_date_time.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/function/swicht_case.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_divider.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/bbs/bbs-vie.dart';
import 'package:yiapp/ui/question/yuan_bao_ctr.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/28 11:16
// usage ：闪断帖头部信息
// ------------------------------------------------------

class FlashHeader extends StatelessWidget {
  final BBSVie data;

  FlashHeader({this.data, Key key}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _postTop(), // 头像、昵称、赏金、发帖时间
          CusDivider(),
          _show("姓名", data.nick ?? "至尊宝"),
          _show("所问类型", YiSwitch.contentType(data.content_type)),
          _show("标题", "${data.title}"),
          _show("内容", "${data.brief}"),
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
      title: CusText(data.nick, t_primary, 28),
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
