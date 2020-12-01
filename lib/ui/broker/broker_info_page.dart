import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/ui/provider/broker_state.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/small/cus_box.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/model/dicts/broker-info.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/ui/broker/broker_admin.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 10:11
// usage ：运营商个人信息页面
// ------------------------------------------------------

class BrokerInfoPage extends StatefulWidget {
  BrokerInfoPage({Key key}) : super(key: key);

  @override
  _BrokerInfoPageState createState() => _BrokerInfoPageState();
}

class _BrokerInfoPageState extends State<BrokerInfoPage> {
  BrokerInfo _b;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _b = context.watch<BrokerInfoState>()?.brokerInfo ?? BrokerInfo();
    return Scaffold(
      appBar: CusAppBar(text: "运营商信息"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[
        MidWidgetBox(
          title: "头像",
          child: CusAvatar(url: _b.icon ?? "", size: 40, circle: true),
          onTap: () {},
        ),
        NormalBox(
          title: "昵称",
          subtitle: _b.owner_nick,
          onTap: () {},
        ),
        NormalBox(title: "邀请码", subtitle: _b.service_code),
        NormalBox(
          title: "运营商管理员",
          onTap: () => CusRoute.push(context, BrokerAdminPage()),
        ),
      ],
    );
  }
}
