import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/function/mix_func.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/model/login/cus_login_res.dart';
import 'package:yiapp/model/login/login_result.dart';
import 'package:yiapp/model/msg/msg-notify-his.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_login.dart';
import 'package:yiapp/service/bus/im-bus.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import 'package:yiapp/ui/fortune/fortune_page.dart';
import 'package:yiapp/ui/home/login_verify.dart';
import 'package:yiapp/ui/home/navigation_type.dart';
import 'package:yiapp/ui/master/master_list_page.dart';
import 'package:yiapp/ui/mall/product/product_store.dart';
import 'package:yiapp/ui/mine/mine_page.dart';
import 'package:yiapp/ui/question/question_page.dart';

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
  List<Widget> _bars = []; // 底部导航组件
  List<String> _names = []; // 底部导航名称
  int _curIndex = 0; // 底部导航栏索引
  // 需要用该控制器，否则即使继承 AutomaticKeepAliveClientMixin，也会重新刷新
  PageController _pc = PageController();
  StreamSubscription<MsgNotifyHis> _busSub;

  @override
  void initState() {
    _startLogin();
    _prepareBusEvent(); // 初始化监听
    super.initState();
  }

  /// 系统通知消息类型
  _prepareBusEvent() {
    _busSub = glbEventBus.on<MsgNotifyHis>().listen((event) {
      if (event.to == ApiBase.uid) {
        Debug.log("系统通知消息：${event.toJson()}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pc,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _bars.length,
        itemBuilder: (context, index) => _bars[index],
      ),
      bottomNavigationBar: NavigationType(
        curIndex: _curIndex, // 底部导航栏设置
        names: _names,
        onChanged: (val) {
          if (val == null) return;
          if (_curIndex != val) {
            setState(() {
              _curIndex = val;
              _pc.jumpToPage(_curIndex);
            });
          }
        },
      ),
      backgroundColor: Colors.black26,
    );
  }

  /// 用户第一次登录，以及登录后的登录
  void _startLogin() async {
    await initDB(); // 初始化数据库
    LoginResult login;
    bool logged = await jwtToken(); // 根据是否有本地token，判断用户是否登录过
    // TODO 如果服务器发送登录信息已被改变的通知，则需重新登录，目前先定位不管是否更改都去请求
    try {
      if (logged) {
        Debug.log("用户已登录过，验证当前 token");
        CusLoginRes res = await LoginDao(glbDB).readUserByJwt();
        login = LoginResult.from(res);
      } else {
        Debug.log("用户第一次进入鸿运来，请求注册为游客身份");
        login = await ApiLogin.guestLogin({});
      }
    } catch (e) {
      Debug.logError("用户登录出现异常：$e");
    }
    await LoginVerify.init(login, context);
    _dynamicModules(); // 动态的运营商模块
  }

  /// 动态的运营商模块
  void _dynamicModules() async {
    // 大师不受运营商控制，默认显示所有模块
    if (ApiState.is_master) {
      _bars = [
        FortunePage(),
        MallPage(),
        QuestionPage(),
        MasterListPage(),
        MinePage()
      ];
      _names = ["运势", "商城", "问命", "大师", "我的"];
    }
    // 非大师身份，则按照运营商开通的服务模块动态显示
    else {
      // 默认开启运势中的"免费测算"和"我的"
      _bars = [FortunePage(), MinePage()];
      _names = ["运势", "我的"]; // 用两个列表不用再拆开，方便运算传值
      CusLoginRes res = await LoginDao(glbDB).readUserByUid();
      if (res.enable_mall == 1) {
        Debug.log("开启了商城");
        _bars.insert(_bars.length - 1, MallPage());
        _names.insert(_names.length - 1, "商城");
      }
      if (res.enable_prize == 1 || res.enable_vie == 1) {
        if (res.enable_prize == 1) {
          Debug.log("开启了悬赏帖");
        }
        if (res.enable_vie == 1) {
          Debug.log("开启了闪断帖");
        }
        _bars.insert(_bars.length - 1, QuestionPage());
        _names.insert(_names.length - 1, "问命");
      }
      if (res.enable_master == 1) {
        Debug.log("开启了大师");
        _bars.insert(_bars.length - 1, MasterListPage());
        _names.insert(_names.length - 1, "大师");
      }
    }
    Debug.log("底部导航栏names:${_names.toString()}");
    setState(() {});
  }

  @override
  void dispose() {
    _busSub.cancel();
    _pc.dispose();
    super.dispose();
  }
}
