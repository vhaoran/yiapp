import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_double.dart';
import 'package:yiapp/complex/demo/demo_main.dart';
import 'package:yiapp/complex/function/def_obj.dart';
import 'package:yiapp/complex/provider/user_state.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_bottom_sheet.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/complex/widgets/small/cus_bg_wall.dart';
import 'package:yiapp/complex/widgets/small/cus_box.dart';
import 'package:yiapp/model/login/userInfo.dart';
import 'package:yiapp/model/msg/msg-yiorder.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/bus/im-bus.dart';
import 'package:yiapp/ui/back_stage/backstage_manage.dart';
import 'package:yiapp/ui/broker/broker_apply.dart';
import 'package:yiapp/ui/broker/broker_info_page.dart';
import 'package:yiapp/ui/master/master_apply.dart';
import 'package:yiapp/ui/master/master_info_page.dart';
import 'package:yiapp/ui/mine/account_safe/account_safe_page.dart';
import 'package:yiapp/ui/mine/bind_service_code.dart';
import 'package:yiapp/ui/mine/fund_account/fund_main.dart';
import 'package:yiapp/ui/mine/mall/product_main.dart';
import 'package:yiapp/ui/mine/personal_info/personal_page.dart';
import 'my_orders/all_my_post.dart';

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
  UserInfo _u = UserInfo();

  StreamSubscription<MsgYiOrder> _bubSub;

  @override
  void initState() {
    Debug.log("进入了个人主页");
    super.initState();
    _prepareBusEvent();
  }

  void _prepareBusEvent() {
    _bubSub = glbEventBus.on<MsgYiOrder>().listen((event) {
      Debug.log("有订单消息了,消息详情：${event.toJson()}");
      if (event.to == ApiBase.uid) {
        Debug.log("是发给自己的");
      }
    });
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
        if (ApiState.isVip)
          NormalBox(
            title: "我的订单",
            onTap: () => CusRoutes.push(context, AllMyPostPage()),
          ),
        NormalBox(
          title: "商城",
          onTap: () => CusRoutes.push(context, ProductMainPage()),
        ),
        NormalBox(
          title: "账户与安全",
          onTap: () => CusRoutes.push(context, AccountSafePage()),
        ),
        NormalBox(
          title: "个人资金账号",
          onTap: () => CusRoutes.push(context, FundMain()),
        ),
        if (!ApiState.isMaster)
          NormalBox(
            title: "申请大师",
            onTap: () => CusRoutes.push(context, ApplyMasterPage()),
          ),
        if (ApiState.isMaster)
          NormalBox(
            title: "大师信息",
            onTap: () => CusRoutes.push(context, MasterInfoPage()),
          ),
//        if (!ApiState.isAdmin)
        NormalBox(
          title: "申请代理",
          onTap: () => CusRoutes.push(context, ApplyBrokerPage()),
        ),
        if (ApiState.isBrokerAdmin)
          NormalBox(
            title: "代理信息",
            onTap: () => CusRoutes.push(context, BrokerInfoPage()),
          ),
        if (ApiState.isAdmin)
          NormalBox(
            title: "后台管理",
            onTap: () => CusRoutes.push(context, BackstageManage()),
          ),
        NormalBox(
          title: "绑定代理",
          onTap: () => CusRoutes.push(context, BindSerCodePage()),
        ),
        NormalBox(
          title: "demo 测试",
          onTap: () => CusRoutes.push(context, CusDemoMain()),
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
            onTap: () => CusBottomSheet(context, OnFile: _selectFile),
          ),
          Align(
            alignment: Alignment(0, 0), // 头像
            child: InkWell(
              child: CusAvatar(url: _u.icon ?? "", circle: true),
              onTap: () => CusRoutes.push(context, PersonalPage()),
            ),
          ),
          Align(
            alignment: Alignment(0, ApiState.isGuest ? 0.8 : 0.75),
            child:
                CusText(_u?.nick ?? "暂时为空", t_gray, 30), // 已登录显示用户名，未登录则显示登录丨注册
          ),
        ],
      ),
    );
  }

  void _selectFile(File file) {
    Debug.log("当前选择的图片：$file");
    _file = file;
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _bubSub.cancel();
    super.dispose();
  }
}
