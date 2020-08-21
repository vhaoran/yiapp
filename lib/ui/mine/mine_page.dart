import 'dart:io';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_num.dart';
import 'package:yiapp/complex/provider/user_state.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/cus_bg_wall.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_bottom_sheet.dart';
import 'package:yiapp/model/user/userInfo.dart';

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
  UserInfo _userInfo;

  @override
  void initState() {
    print(">>>进了个人主页");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _userInfo = context.watch<UserInfoState>().userInfo ?? UserInfo();
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
        _info(),
      ],
    );
  }

  /// 用户个人信息
  Widget _info() {
    return Container(
      height: Adapt.px(bgWallH),
      child: Stack(
        children: <Widget>[
          BackgroundWall(
            url: "", // 背景墙
            onTap: () => CusBottomSheet(context, fileFn: _selectFile),
          ),
          Align(
            alignment: Alignment(0, 0), // 头像
            child: CusAvatar(url: "", borderRadius: 100),
          ),
          Align(
            alignment: Alignment(0, 0.75),
            child: Text(
              _userInfo.nick ?? "用户454709171", // 用户名
              style: TextStyle(
                color: t_gray,
                fontSize: Adapt.px(30),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
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
