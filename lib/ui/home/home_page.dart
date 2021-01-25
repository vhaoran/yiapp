import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/login/cus_login_res.dart';
import 'package:yiapp/model/login/login_result.dart';
import 'package:yiapp/service/api/api-push.dart';
import 'package:yiapp/service/api/api_login.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import 'package:yiapp/ui/home/cus_navigation.dart';
import 'package:yiapp/ui/home/login_verify.dart';
import 'package:yiapp/ui/luck/luck_main.dart';
import 'package:yiapp/ui/mall/mall_main.dart';
import 'package:yiapp/ui/mine/mine_page.dart';
import 'package:yiapp/ui/question/que_main_page.dart';
import 'package:yiapp/ui/vip/user_post_ask_page.dart';
import 'package:yiapp/widget/master/masters_page.dart';

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
  Map<String, Widget> _m = {}; // 底部导航名称、组件
  var _pc = PageController();
  var _future;

  @override
  void initState() {
    _future = _initLogin();
    super.initState();

    //for mob push start
    ApiPush.preparePush();
    //for mob push end
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return _buildScaffold();
        });
  }

  Widget _buildScaffold() {
    return Scaffold(
      body: PageView.builder(
        controller: _pc,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _m.length,
        itemBuilder: (context, index) => _m.values.toList()[index],
      ),
      bottomNavigationBar: CusBottomNavigationBar(
        barNames: _m.keys.toList(),
        onChanged: (curIndex) => _pc.jumpToPage(curIndex),
      ),
      backgroundColor: Colors.black26,
    );
  }

  /// 初始化登录信息
  _initLogin() async {
    bool ok = await initDB(); // 初始化数据库
    if (ok) {
      bool hasToken = await KV.getStr(kv_jwt) != null;
      LoginResult login; // 登录结果
      try {
        if (hasToken) {
          Log.info("用户已登录过，验证当前 token");
          SqliteLoginRes res = await LoginDao(glbDB).readUserByJwt();
          login = LoginResult.from(res);
        } else {
          Log.info("用户第一次进入鸿运来，请求注册为游客身份");
          login = await ApiLogin.guestLogin();
        }
      } catch (e) {
        Log.error("用户登录出现异常：$e");
      }
      await LoginVerify.init(login, context);
      await _dynamicModules(); // 动态的运营商模块
    } else {
      Log.error("初始化数据库出现异常");
    }
  }

  /// 动态设置运营商模块
  Future<void> _dynamicModules() async {
    _m = {"运势": LuckMainPage()};
    // 大师添加控制台导航
    SqliteLoginRes res = await LoginDao(glbDB).readUserByUid();
    _printModules(res); // 仅打印运营商开启的模块
    if (res.enable_mall == 1) _m.addAll({"商城": MallPage()});
    if (res.enable_prize == 1 || res.enable_vie == 1) {
//      _m.addAll({"问命": QueMainPage()});
      _m.addAll({"问命": UserPostAskPage()});
    }
    if (res.enable_master == 1) _m.addAll({"大师": BrokerMastersListPage()});
    _m.addAll({"我的": MinePage()});
    setState(() {});
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  /// 仅用来打印运营商开启了哪些服务模块
  void _printModules(SqliteLoginRes res) {
    if (res.enable_mall == 1) Log.info("商城模块已开启");
    if (res.enable_prize == 1) Log.info("悬赏帖模块已开启");
    if (res.enable_vie == 1) Log.info("闪断帖模块已开启");
    if (res.enable_master == 1) Log.info("大师模块已开启");
  }
}
