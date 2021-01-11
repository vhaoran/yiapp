import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/demo/demo_main.dart';
import 'package:yiapp/global/def_data.dart';
import 'package:yiapp/model/login/userInfo.dart';
import 'package:yiapp/model/msg/msg-notify-his.dart';
import 'package:yiapp/model/msg/msg-yiorder.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/bus/im-bus.dart';
import 'package:yiapp/ui/login/login_page.dart';
import 'package:yiapp/ui/mine/mine_view.dart';
import 'package:yiapp/ui/mine/personal_info/personal_page.dart';
import 'package:yiapp/ui/provider/user_state.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/small/cus_bg_wall.dart';
import 'package:yiapp/widget/small/cus_box.dart';

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
    Log.info("进入了个人主页");
    _prepareBusEvent(); // 初始化监听
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _u = context.watch<UserInfoState>().userInfo ?? defaultUser;
    super.build(context);
    return Scaffold(
      body: _lv(),
      backgroundColor: sec_primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          // 用户头像、昵称、背景墙
          Container(
            height: S.h(180),
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
                  alignment: Alignment(0, CusRole.is_guest ? 0.8 : 0.75),
                  child: CusText(_u.nick ?? "游客", t_gray, 30),
                ),
              ],
            ),
          ),
          MineIdentityView(), // 根据身份显示个人主页
          NormalBox(
            title: "demo 测试",
            onTap: () => CusRoute.push(context, CusDemoMain()),
          ),
        ],
      ),
    );
  }

  /// 系统通知消息类型
  _prepareBusEvent() {
    _busNotifyHis = glbEventBus.on<MsgNotifyHis>().listen((event) {
      Log.info("监听到了MsgNotifyHis");
      if (event.to == ApiBase.uid) {
        Log.info("系统通知消息，详情：${event.toJson()}");
        _tipDialog(event);
      }
    });
    _bubYiOrder = glbEventBus.on<MsgYiOrder>().listen((event) {
      if (event.to == ApiBase.uid) {
        Log.info("有消息发送过来了，详情：${event.toJson()}");
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

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _busNotifyHis.cancel();
    _bubYiOrder.cancel();
    super.dispose();
  }
}
