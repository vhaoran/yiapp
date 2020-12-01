import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/const/const_double.dart';
import 'package:yiapp/demo/demo_main.dart';
import 'package:yiapp/func/def_obj.dart';
import 'package:yiapp/ui/provider/user_state.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/func/api_state.dart';
import 'package:yiapp/func/cus_route.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/complex/widgets/small/cus_bg_wall.dart';
import 'package:yiapp/complex/widgets/small/cus_box.dart';
import 'package:yiapp/login/login_page.dart';
import 'package:yiapp/model/login/userInfo.dart';
import 'package:yiapp/model/msg/msg-notify-his.dart';
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
  StreamSubscription<MsgYiOrder> _bubYiOrder;
  StreamSubscription<MsgNotifyHis> _busNotifyHis;
  bool _isMasterApply = false; // 是否大师申请通过
  bool _isBrokerApply = false; // 是否运营商申请通过
  String _notifyStr = ""; // 审核通过提示信息

  @override
  void initState() {
    Debug.log("进入了个人主页");
    _prepareBusEvent(); // 初始化监听
    super.initState();
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

  /// 系统通知消息类型
  _prepareBusEvent() {
    _busNotifyHis = glbEventBus.on<MsgNotifyHis>().listen((event) {
      Debug.log("监听到了MsgNotifyHis");
      if (event.to == ApiBase.uid) {
        Debug.log("系统通知消息，详情：${event.toJson()}");
        _tipDialog(event);
      }
    });
    _bubYiOrder = glbEventBus.on<MsgYiOrder>().listen((event) {
      if (event.to == ApiBase.uid) {
        Debug.log("有消息发送过来了，详情：${event.toJson()}");
      }
    });
  }

  /// 弹窗提示重新登录
  void _tipDialog(MsgNotifyHis event) {
    if (mounted) {
      setState(() {
        if (event.content.comment.contains("大师申请已通过")) {
          _isMasterApply = true;
          _notifyStr = "大师";
        }
        if (event.content.comment.contains("代理申请已通过")) {
          _isBrokerApply = true;
          _notifyStr = "运营商";
        }
        if (_isMasterApply || _isBrokerApply) {
          CusDialog.normal(
            context,
            title: "您的$_notifyStr申请已通过审核，需要重新登录",
            fnDataApproval: "",
            onCancel: () {
              _isMasterApply = _isBrokerApply = false;
              _notifyStr = "";
            },
            onThen: () => CusRoute.push(context, LoginPage()),
          );
        }
      });
    }
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
            onTap: () => CusRoute.push(context, MasterInfoPage()),
          ),
        // 游客身份看不到的内容
        if (!ApiState.is_guest && !ApiState.is_master) ...[
          NormalBox(
            title: "我的订单",
            onTap: () => CusRoute.push(context, AllMyPostPage()),
          ),
          NormalBox(
            title: "我的商品",
            onTap: () => CusRoute.push(context, UserProductInfo()),
          ),
          NormalBox(
            title: "个人资金账号",
            onTap: () => CusRoute.push(context, FundMain()),
          ),
        ],
        if (!ApiState.is_guest)
          NormalBox(
            title: "账户与安全",
            onTap: () => CusRoute.push(context, AccountSafePage()),
          ),
        // 大师、运营商、运营商管理员不能申请的
        if (!ApiState.is_master && !ApiState.is_broker_admin) ...[
          NormalBox(
            title: "申请大师",
            onTap: () => CusRoute.push(context, ApplyMasterPage()),
          ),
          NormalBox(
            title: "申请运营商",
            onTap: () => CusRoute.push(context, ApplyBrokerPage()),
          ),
        ],
        if (ApiState.is_guest)
          NormalBox(
            title: "绑定运营商",
            onTap: () => CusRoute.push(context, BindSerCodePage()),
          ),
        NormalBox(
          title: "demo 测试",
          onTap: () => CusRoute.push(context, CusDemoMain()),
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
          BackgroundWall(url: ""), // 背景墙
          Align(
            alignment: Alignment(0, 0), // 头像
            child: InkWell(
              child: CusAvatar(url: _u.icon ?? "", circle: true),
              onTap: () => CusRoute.push(context, PersonalPage()),
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
    _busNotifyHis.cancel();
    _bubYiOrder.cancel();
    super.dispose();
  }
}
