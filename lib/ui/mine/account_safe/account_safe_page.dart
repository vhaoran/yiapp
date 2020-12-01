import 'package:flutter/material.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/func/cus_route.dart';
import 'package:yiapp/complex/widgets/small/cus_box.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/ui/mine/account_safe/ch_pwd.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/10 16:36
// usage ：【账号与安全】页面
// ------------------------------------------------------

class AccountSafePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "账号与安全"),
      body: _lv(context),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        SizedBox(height: Adapt.px(15)),
        NormalBox(
          title: "修改登录密码",
          onTap: () => CusRoute.push(context, ChPwdPage()),
        ),
      ],
    );
  }
}
