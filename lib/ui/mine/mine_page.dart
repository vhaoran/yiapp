import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_double.dart';
import 'package:yiapp/complex/provider/user_state.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/tools/cus_tool.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/cus_bg_wall.dart';
import 'package:yiapp/complex/widgets/cus_box.dart';
import 'package:yiapp/complex/widgets/flutter/cus_bottom_sheet.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/login/login_page.dart';
import 'package:yiapp/login/register_page.dart';
import 'package:yiapp/model/login/userInfo.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/ui/mine/account_safe/account_safe_page.dart';
import 'package:yiapp/ui/mine/order_page.dart';
import 'package:yiapp/ui/mine/personal_info/personal_page.dart';

import 'address/user_addr.dart';

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
    print(">>>进入了个人主页");
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
        if (!ApiBase.isGuest)
          NormalBox(
            title: "我的订单",
            onTap: () => CusRoutes.push(context, OrderPage()),
          ),
        NormalBox(
          title: "账户与安全",
          onTap: () => CusRoutes.push(context, AccountSafePage()),
        ),
        NormalBox(
          title: "我的收货地址",
          onTap: () => CusRoutes.push(context, UserAddressPage()),
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
            onTap: ApiBase.isGuest
                ? () => CusToast.toast(context, text: "请先登录")
                : () => CusBottomSheet(context, fileFn: _selectFile),
          ),
          Align(
            alignment: Alignment(0, 0), // 头像
            child: InkWell(
              child: CusAvatar(url: _u.icon?.substring(16) ?? "", circle: true),
              onTap: ApiBase.isGuest
                  ? () => CusToast.toast(context, text: "请先登录")
                  : () => CusRoutes.push(context, PersonalPage()),
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
    return ApiBase.isGuest
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    onTap: () => CusRoutes.push(
                      context,
                      LoginPage(showDefault: true),
                    ),
                    child: Text("登录", style: ts),
                  ),
                  Text("丨", style: ts),
                  InkWell(
                    onTap: () => CusRoutes.push(context, RegisterPage()),
                    child: Text("注册", style: ts),
                  ),
                ],
              ),
            ],
          )
        : Text(
            _u.nick, // 用户昵称
            style: TextStyle(
              color: t_gray,
              fontSize: Adapt.px(30),
              fontWeight: FontWeight.w500,
            ),
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
