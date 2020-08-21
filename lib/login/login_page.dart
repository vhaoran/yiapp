import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_by_pwd.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/20 15:11
// usage ：登录页面
// ------------------------------------------------------

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PwdLoginPage(), // 默认密码登录
    );
  }
}
