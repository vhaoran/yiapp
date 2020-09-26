import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/function/mix_func.dart';
import 'package:yiapp/complex/provider/broker_state.dart';
import 'package:yiapp/complex/provider/master_state.dart';
import 'package:yiapp/complex/provider/user_state.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/tools/cus_reg.dart';
import 'package:yiapp/model/dicts/broker-info.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/model/login/login_result.dart';
import 'package:yiapp/service/api/api-broker.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_login.dart';
import 'package:yiapp/service/login/login_utils.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/ui/fortune/fortune_page.dart';
import 'package:yiapp/ui/home/chose_ask_type.dart';
import 'package:yiapp/ui/home/navigation_type.dart';
import 'package:yiapp/ui/master/master_page.dart';
import 'package:yiapp/ui/mine/mine_page.dart';
import 'package:yiapp/ui/question/question_page.dart';
import 'package:yiapp/ui/worship/worship_page.dart';
import 'package:provider/provider.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 15:15
// usage ：首页
// ------------------------------------------------------

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _bars; // 底部导航组件
  int _curIndex = 0; // 底部导航栏索引
  bool _isMid = false; // 是否为中间提问
  // 需要用该控制器，否则即使继承 AutomaticKeepAliveClientMixin，也会重新刷新
  PageController _pc = PageController();

  @override
  void initState() {
    _bars = [
      FortunePage(),
      WorshipPage(),
      QuestionPage(),
      MasterPage(),
      MinePage(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!ApiBase.login) _autoLogin(context);
    return Scaffold(
      body: PageView.builder(
        controller: _pc,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _bars.length,
        itemBuilder: (context, index) => _bars[index],
      ),
      bottomNavigationBar: NavigationType(
        isMid: _isMid,
        curIndex: _curIndex, // 底部导航栏设置
        onChanged: (val) {
          if (val == null) return;
          if (_curIndex != val) {
            setState(() {
              _curIndex = val;
              _isMid = _curIndex == 2 ? true : false;
              _pc.jumpToPage(_curIndex);
            });
          }
        },
      ),
      backgroundColor: Colors.black26,
      floatingActionButton: _isMid ? ChoseAskType(isMid: _isMid) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// 如果已经登录过一次，则自动登录,反之为第一次登录程序
  void _autoLogin(BuildContext context) async {
    LoginResult result;
    if (await hadLogin()) {
      try {
        Debug.log("用户已经登录过，现在自动登录");
        String loginData = await KV.getStr(kv_login);
        result = LoginResult.fromJson(json.decode(loginData));
      } catch (e) {
        Debug.logError("用户已经登录过，但登录出现异常$e");
      }
    } else {
      try {
        Debug.log("用户第一次进入程序，以游客登录模式进入");
        result = await ApiLogin.guestLogin({});
        if (result != null) {
          await KV.setStr(kv_jwt, result.jwt); // 存储本地token
          await KV.setStr(kv_login, json.encode(result.toJson()));
        }
      } catch (e) {
        Debug.logError("游客登录异常：$e");
      }
    }
    Debug.log("用户登录结果：${result.toJson()}");
    await setLoginInfo(result);
    if (ApiState.isMaster) _fetchMaster();
    if (ApiState.isBroker) _fetchBroker();
    context.read<UserInfoState>().init(result.user_info);
    ApiState.isGuest = !CusRegExp.phone(result.user_info.user_code);
  }

  /// 如果是大师，获取大师基本资料
  _fetchMaster() async {
    try {
      MasterInfo res = await ApiMaster.masterInfoGet(ApiBase.uid);
      if (res != null) {
        context.read<MasterInfoState>().init(res);
      }
    } catch (e) {
      Debug.logError("获取大师个人信息出现异常：$e");
    }
  }

  /// 如果是代理，获取代理基本资料
  _fetchBroker() async {
    try {
      BrokerInfo res = await ApiBroker.brokerInfoGet(ApiState.broker_id);
      if (res != null) context.read<BrokerInfoState>().init(res);
    } catch (e) {
      Debug.logError("获取代理个人信息出现异常：$e");
    }
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }
}
