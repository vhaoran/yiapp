import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:left_scroll_actions/left_scroll_actions.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/dicts/broker-admin.dart';
import 'package:yiapp/model/login/userInfo.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/19 14:57
// usage ：通用单个代理管理员显示组件,类型可用BrokerAdmin或者UserInfo
// ------------------------------------------------------

class BrokerUserItem extends StatefulWidget {
  final BrokerAdmin b; // 代理管理员用
  final FnInt fnRm; // 移除操作

  BrokerUserItem({this.b, this.fnRm, Key key}) : super(key: key);

  @override
  _BrokerUserItemState createState() => _BrokerUserItemState();
}

class _BrokerUserItemState extends State<BrokerUserItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.white,
      color: fif_primary,
      margin: EdgeInsets.all(Adapt.px(3)),
      child: _leftScroll(),
    );
  }

  Widget _leftScroll() {
    return CupertinoLeftScroll(
      closeTag: LeftScrollCloseTag("BrokerAdminPage"),
      key: Key(widget.b.id.toString()),
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Adapt.px(15)),
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: CusText(widget.b.nick, t_gray, 28),
          leading: CusAvatar(
              url: widget.b.icon, circle: true, size: 100, borderRadius: 0),
        ),
      ),
      buttons: <Widget>[
        LeftScrollItem(
          text: "删除",
          textColor: Colors.white,
          color: Colors.red,
          onTap: () {
            if (widget.fnRm != null) {
              widget.fnRm(widget.b.uid);
            }
          },
        ),
      ],
    );
  }
}
