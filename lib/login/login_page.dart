import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'login_by_pwd.dart';
import 'register_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/20 15:11
// usage ：登录页面
// ------------------------------------------------------

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: _appBar(context),
      body: PwdLoginPage(), // 默认密码登录
    );
  }

  Widget _appBar(context) {
    return CusAppBar(
      showLeading: false,
      color: primary,
      actions: <Widget>[
        IconButton(
            padding: EdgeInsets.only(right: 10),
            icon: Text(
              '注册',
              style: TextStyle(color: Colors.black, fontSize: Adapt.px(30)),
            ),
            onPressed: () => CusRoutes.push(context, RegUserPage())),
      ],
    );
  }
}
