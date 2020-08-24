import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_num.dart';
import 'package:yiapp/complex/provider/user_state.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/tools/cus_tool.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/cus_bg_wall.dart';
import 'package:yiapp/complex/widgets/cus_box.dart';
import 'package:yiapp/complex/widgets/flutter/cus_bottom_sheet.dart';
import 'package:yiapp/login/login_page.dart';
import 'package:yiapp/login/login_page.dart';
import 'package:yiapp/login/register_page.dart';
import 'package:yiapp/model/user/userInfo.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/mine/order_page.dart';
import 'package:yiapp/ui/mine/personal_info/personal_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 15:41
// usage ：底部导航栏 - 个人主页
// ------------------------------------------------------

class MinePage extends StatefulWidget {
  MinePage({Key key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage>
    with AutomaticKeepAliveClientMixin {
  File _file; // 返回的相册或者拍摄的图片
  UserInfo _u;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _u = ApiBase.login
        ? context.watch<UserInfoState>().userInfo ?? defaultUser
        : defaultUser;
    super.build(context);
    return Scaffold(
      body: _bodyCtr(),
      backgroundColor: sec_primary,
    );
  }

  Widget _bodyCtr() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        _avatarAndMore(), // 用户头像、昵称、背景墙
        if (ApiBase.login)
          NormalBox(
            title: "我的订单",
            onTap: () => CusRoutes.push(context, OrderPage()),
          ),
      ],
    );
  }

  /// 用户头像、昵称、背景墙
  Widget _avatarAndMore() {
    return Container(
      height: Adapt.px(bgWallH),
      child: Stack(
        children: <Widget>[
          BackgroundWall(
            url: "", // 背景墙
            onTap: ApiBase.login
                ? () => CusBottomSheet(context, fileFn: _selectFile)
                : null,
          ),
          Align(
            alignment: Alignment(0, 0), // 头像
            child: InkWell(
              child: CusAvatar(url: _u.icon?.substring(16) ?? "", circle: true),
              onTap: () => CusRoutes.push(
                context,
                ApiBase.login ? PersonalPage(userInfo: _u) : LoginPage(),
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, 0.75),
            child: _userCodeCt(), // 已登录显示用户名，未登录则显示登录丨注册
          ),
        ],
      ),
    );
  }

  /// 已登录显示用户名，未登录则显示登录丨注册
  Widget _userCodeCt() {
    TextStyle ts = TextStyle(color: t_gray, fontSize: Adapt.px(28));
    return ApiBase.login
        ? Text(
            _u.user_name ?? "用户454709171", // 用户名
            style: TextStyle(
              color: t_gray,
              fontSize: Adapt.px(30),
              fontWeight: FontWeight.w500,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () => CusRoutes.push(context, LoginPage()),
                child: Text("登录", style: ts),
              ),
              Text("丨", style: ts),
              InkWell(
                onTap: () => CusRoutes.push(context, RegisterPage()),
                child: Text("注册", style: ts),
              ),
            ],
          );
  }

  void _selectFile(File file) {
    print(">>>当前选择的图片：$file");
    _file = file;
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
