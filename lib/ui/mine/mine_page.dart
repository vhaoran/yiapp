import 'dart:async';
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
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/complex/widgets/small/cus_bg_wall.dart';
import 'package:yiapp/complex/widgets/small/cus_box.dart';
import 'package:yiapp/model/login/userInfo.dart';
import 'package:yiapp/model/msg/msg-yiorder.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/bus/im-bus.dart';
import 'package:yiapp/ui/broker/broker_apply.dart';
import 'package:yiapp/ui/master/master_apply.dart';
import 'package:yiapp/ui/master/master_info_page.dart';
import 'package:yiapp/ui/mine/account_safe/account_safe_page.dart';
import 'package:yiapp/ui/mine/bind_service_code.dart';
import 'package:yiapp/ui/mine/fund_account/fund_main.dart';
import 'package:yiapp/ui/mine/personal_info/personal_page.dart';
import 'package:yiapp/ui/mine/user_pro_info.dart';
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
  UserInfo _u = UserInfo();

  StreamSubscription<MsgYiOrder> _bubSub;

  @override
  void initState() {
    Debug.log("进入了个人主页");
    super.initState();
//    _prepareBusEvent();
  }

  @override
  Widget build(BuildContext context) {
    _u = context.watch<UserInfoState>().userInfo ?? defaultUser;
    super.build(context);
    return Scaffold(
      body: _bodyCtr(),
      backgroundColor: sec_primary,
    );
  }

  void _prepareBusEvent() {
    _bubSub = glbEventBus.on<MsgYiOrder>().listen((event) {
      Debug.log("有订单消息了,消息详情：${event.toJson()}");
      if (event.to == ApiBase.uid) {
        Debug.log("是发给自己的");
      }
    });
  }

  Widget _bodyCtr() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        _avatarAndMore(), // 用户头像、昵称、背景墙
        // 如果是大师
        if (ApiState.is_master)
          NormalBox(
            title: "大师信息",
            onTap: () => CusRoutes.push(context, MasterInfoPage()),
          ),
        // 游客身份看不到的内容
        if (!ApiState.is_guest) ...[
          NormalBox(
            title: "我的订单",
            onTap: () => CusRoutes.push(context, AllMyPostPage()),
          ),
          NormalBox(
            title: "我的商品",
            onTap: () => CusRoutes.push(context, UserProductInfo()),
          ),
          NormalBox(
            title: "账户与安全",
            onTap: () => CusRoutes.push(context, AccountSafePage()),
          ),
          NormalBox(
            title: "个人资金账号",
            onTap: () => CusRoutes.push(context, FundMain()),
          ),
        ],
        // 大师、运营商、运营商管理员不能申请的
        if (!ApiState.is_master && !ApiState.is_broker_admin) ...[
          NormalBox(
            title: "申请大师",
            onTap: () => CusRoutes.push(context, ApplyMasterPage()),
          ),
          NormalBox(
            title: "申请运营商",
            onTap: () => CusRoutes.push(context, ApplyBrokerPage()),
          ),
          NormalBox(
            title: "绑定运营商",
            onTap: () => CusRoutes.push(context, BindSerCodePage()),
          ),
        ],
//        NormalBox(
//          title: "demo 测试",
//          onTap: () => CusRoutes.push(context, CusDemoMain()),
//        ),
      ],
    );
  }

  /// 用户头像、昵称、背景墙
  Widget _avatarAndMore() {
    return Container(
      height: Adapt.px(bgWallH),
      child: Stack(
        children: <Widget>[
          BackgroundWall(url: ""), // 背景墙
          Align(
            alignment: Alignment(0, 0), // 头像
            child: InkWell(
              child: CusAvatar(url: _u.icon ?? "", circle: true),
              onTap: () => CusRoutes.push(context, PersonalPage()),
            ),
          ),
          Align(
            alignment: Alignment(0, ApiState.is_guest ? 0.8 : 0.75),
            child: CusText(_u.nick ?? "游客", t_gray, 30),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _bubSub.cancel();
    super.dispose();
  }
}
