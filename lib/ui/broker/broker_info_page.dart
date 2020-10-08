import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/provider/broker_state.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/complex/widgets/small/cus_box.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/model/dicts/broker-info.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/ui/broker/broker_admin.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 10:11
// usage ：代理个人信息页面
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
      appBar: CusAppBar(text: "代理信息"),
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
        NormalBox(title: "推荐码", subtitle: _b.service_code),
        NormalBox(
          title: "代理管理员",
          onTap: () => CusRoutes.push(context, BrokerAdminPage()),
        ),
      ],
    );
  }
}
