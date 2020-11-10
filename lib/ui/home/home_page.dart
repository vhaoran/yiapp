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
import 'package:yiapp/model/login/cus_login_res.dart';
import 'package:yiapp/service/api/api-broker.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_login.dart';
import 'package:yiapp/service/login/login_utils.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import 'package:yiapp/ui/fortune/fortune_page.dart';
import 'package:yiapp/ui/home/chose_ask_type.dart';
import 'package:yiapp/ui/home/navigation_type.dart';
import 'package:yiapp/ui/master/master_list_page.dart';
import 'package:yiapp/ui/mine/mine_page.dart';
import 'package:yiapp/ui/question/question_page.dart';
import 'package:yiapp/ui/worship/worship_page.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/complex/function/shopcart_func.dart';

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
//  StreamSubscription<MsgNotifyHis> _busSub;

  @override
  void initState() {
    _bars = [
      FortunePage(),
      WorshipPage(),
      QuestionPage(),
      MasterListPage(),
      MinePage(),
    ];
//    _prepareBusEvent(); // 初始化监听
    _verifyLogin();
    super.initState();
  }

  /// 系统通知类型
//  _prepareBusEvent() {
//    _busSub = glbEventBus.on<MsgNotifyHis>().listen((event) {
//      Debug.log("监听到了吗");
//      if (event.to == ApiBase.uid) {
//        Debug.log("有大师给发帖人发布评论了");
//        Debug.log("回帖的详情：${event.toJson()}");
//      }
//    });
//  }

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

  /// 验证登录信息
  void _verifyLogin() async {
    await initDB(); // 初始化数据库
    LoginResult login;
    bool logged = await jwtToken(); // 是否有本地token
    // TODO 如果服务器发送登录信息已被改变的通知，则需重新登录，并更新本地token
    try {
      if (logged) {
        Debug.log("用户已登录过，验证当前 token");
        CusLoginRes res = await LoginDao(glbDB).readJwt();
        login = LoginResult.from(res);
      } else {
        Debug.log("用户第一次进入鸿运来，请求注册为游客身份");
        login = await ApiLogin.guestLogin({});
        if (login != null) {
          // 存储到本地用户信息数据库，同时保存jwt确定登录token
          LoginDao(glbDB).insert(CusLoginRes.from(login));
        }
      }
    } catch (e) {
      Debug.logError("用户登录出现异常：$e");
    }
    Debug.log("用户登录结果：${login.toJson()}");
    context.read<UserInfoState>().init(login.user_info);
    await setLoginInfo(login);
    // TODO 这里应该把大师信息也存储到本地数据库
    if (ApiState.isMaster) _fetchMaster();
    if (ApiState.isBrokerAdmin) _fetchBroker();
    ShopKV.key = "shop${ApiBase.uid}";
  }

  /// 如果是大师，获取大师基本资料
  _fetchMaster() async {
    Debug.log("是大师");
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
    Debug.log("是管理员");
    try {
      BrokerInfo res = await ApiBroker.brokerInfoGet(ApiState.broker_id);
      if (res != null) context.read<BrokerInfoState>().init(res);
    } catch (e) {
      Debug.logError("获取代理个人信息出现异常：$e");
    }
  }

  @override
  void dispose() {
//    _busSub.cancel();
    _pc.dispose();
    super.dispose();
  }
}
