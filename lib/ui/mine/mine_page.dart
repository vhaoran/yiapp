import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_double.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/demo/demo_main.dart';
import 'package:yiapp/complex/provider/user_state.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/tools/cus_tool.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/cus_bg_wall.dart';
import 'package:yiapp/complex/widgets/cus_box.dart';
import 'package:yiapp/complex/widgets/flutter/cus_bottom_sheet.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/login/login_page.dart';
import 'package:yiapp/login/register_page.dart';
import 'package:yiapp/model/login/userInfo.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_login.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/ui/master/backstage_manage.dart';
import 'package:yiapp/ui/broker/broker_apply.dart';
import 'package:yiapp/ui/broker/broker_info_page.dart';
import 'package:yiapp/ui/master/master_apply.dart';
import 'package:yiapp/ui/master/master_info_page.dart';
import 'package:yiapp/ui/mine/account_safe/account_safe_page.dart';
import 'package:yiapp/ui/mine/bind_service_code.dart';
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
  UserInfo _u;

  @override
  void initState() {
    Debug.log("进入了个人主页");
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
        if (!ApiState.isGuest)
          NormalBox(
            title: "我的订单",
            onTap: () => CusRoutes.push(context, AllMyPostPage()),
          ),
        NormalBox(
          title: "账户与安全",
          onTap: () => CusRoutes.push(context, AccountSafePage()),
        ),
//        if (!ApiState.isMaster)
        NormalBox(
          title: "申请大师",
          onTap: () => CusRoutes.push(context, ApplyMasterPage()),
        ),
//        if (ApiState.isMaster)
        NormalBox(
          title: "大师信息",
          onTap: () => CusRoutes.push(context, MasterInfoPage()),
        ),
        NormalBox(
          title: "申请代理",
          onTap: () => CusRoutes.push(context, ApplyBrokerPage()),
        ),
        if (ApiState.isBrokerAdmin)
          NormalBox(
            title: "代理信息",
            onTap: () => CusRoutes.push(context, BrokerInfoPage()),
          ),
//        if (ApiState.isAdmin)
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
        CusRaisedBtn(
          text: "测试游客登录",
          onPressed: () async {
            try {
              var res = await ApiLogin.guestLogin({});
              Debug.log("游客登录结果：${res.toJson()}");
              Debug.log("json.encode:${json.encode(res.toJson())}");
              if (res != null) {
                await KV.setStr(kv_jwt, res.jwt);
                await KV.setStr(kv_login, json.encode(res.toJson()));
//                context.read<UserInfoState>().init(res.user_info);
              }
            } catch (e) {
              Debug.logError("游客登录异常：$e");
            }
          },
        ),
        CusRaisedBtn(
          text: "获取登录过的信息",
          onPressed: () async {
            String login = await KV.getStr(kv_login);
            Debug.log("获取到的信息：${login}");
            Map map = json.decode(login);
            Debug.log("${map['is_admin']}");
            var info = UserInfo.fromJson(map).id;
            Debug.log("+++++++：${info}");
            String jwt = await KV.getStr(kv_jwt);
            Debug.log("获取的token是：$jwt");
          },
        ),
        CusRaisedBtn(
          text: "清理",
          onPressed: () async {
            bool ok = await KV.clear();
            Debug.log("结果：$ok");
          },
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
            onTap: ApiState.isGuest
                ? () => CusToast.toast(context, text: "请先登录")
                : () => CusBottomSheet(context, OnFile: _selectFile),
          ),
          Align(
            alignment: Alignment(0, 0), // 头像
            child: InkWell(
              child: CusAvatar(url: _u.icon ?? "", circle: true),
              onTap: ApiState.isGuest
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
    return ApiState.isGuest
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
    Debug.log("当前选择的图片：$file");
    _file = file;
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
