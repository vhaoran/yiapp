import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/login/cus_login_res.dart';
import 'package:yiapp/model/login/login_result.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_login.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import 'package:yiapp/ui/home/cus_navigation.dart';
import 'package:yiapp/ui/home/login_verify.dart';
import 'package:yiapp/ui/luck/luck_main.dart';
import 'package:yiapp/ui/mall/mall_main.dart';
import 'package:yiapp/ui/master/master_list_page.dart';
import 'package:yiapp/ui/mine/mine_page.dart';
import 'package:yiapp/ui/question/question_page.dart';
import 'package:yiapp/util/us_util.dart';

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
  List<Widget> _barWidgets = []; // 底部导航组件
  List<String> _barNames = []; // 底部导航名称
  int _curIndex = 0; // 当前导航栏索引
  var _pc = PageController();
  var _future;

  @override
  void initState() {
    _future = _initLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pc,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _barWidgets.length,
        itemBuilder: (context, index) => _barWidgets[index],
      ),
      bottomNavigationBar: _cusNavigationBar(),
      backgroundColor: Colors.black26,
    );
  }

  /// 底部导航栏
  Widget _cusNavigationBar() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (!(snap.connectionState == ConnectionState.done)) {
          return Center(child: CircularProgressIndicator());
        }
        return CusBottomNavigationBar(
          curIndex: _curIndex,
          barNames: _barNames,
          onChanged: (val) {
            if (val == null) return;
            if (_curIndex != val) {
              _curIndex = val;
              _pc.jumpToPage(_curIndex);
              setState(() {});
            }
          },
        );
      },
    );
  }

  /// 初始化登录信息
  _initLogin() async {
    await initDB(); // 初始化数据库
    LoginResult login;
    bool hasToken = await UsUtil.hasToken();
    // TODO 如果服务器发送登录信息已被改变的通知，则需重新登录，目前先定为不管是否更改都去请求
    try {
      if (hasToken) {
        Log.info("用户已登录过，验证当前 token");
        CusLoginRes res = await LoginDao(glbDB).readUserByJwt();
        login = LoginResult.from(res);
      } else {
        Log.info("用户第一次进入鸿运来，请求注册为游客身份");
        login = await ApiLogin.guestLogin({});
      }
    } catch (e) {
      Log.error("用户登录出现异常：$e");
    }
    await LoginVerify.init(login, context);
    _dynamicModules(); // 动态的运营商模块
  }

  /// 动态设置运营商模块
  void _dynamicModules() async {
    // 默认开启运势中的"免费测算"和"我的"(这里大师和游客看到的是一样的)
    _barWidgets = [LuckMainPage(), MinePage()];
    _barNames = ["运势", "我的"];
    CusLoginRes res = await LoginDao(glbDB).readUserByUid();
    if (res.enable_mall == 1) {
      Log.info("开启了商城");
      _barWidgets.insert(_barWidgets.length - 1, MallPage());
      _barNames.insert(_barNames.length - 1, "商城");
    }
    if (res.enable_prize == 1 || res.enable_vie == 1) {
      if (res.enable_prize == 1) Log.info("开启了悬赏帖");
      if (res.enable_vie == 1) Log.info("开启了闪断帖");
      _barWidgets.insert(_barWidgets.length - 1, QuestionPage());
      _barNames.insert(_barNames.length - 1, "问命");
    }
    if (res.enable_master == 1) {
      Log.info("开启了大师");
      _barWidgets.insert(_barWidgets.length - 1, MasterListPage());
      _barNames.insert(_barNames.length - 1, "大师");
    }
    setState(() {});
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }
}
