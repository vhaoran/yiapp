import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/function/mix_func.dart';
import 'package:yiapp/complex/provider/user_state.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/cus_singlebar.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_login.dart';
import 'package:yiapp/service/login/login_utils.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/ui/fortune/fortune_page.dart';
import 'package:yiapp/ui/master/master_page.dart';
import 'package:yiapp/ui/mine/mine_page.dart';
import 'package:yiapp/ui/reward/reward_page.dart';
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
  final List<String> _barNames = ["运势", "供奉", "悬赏", "大师", "我的"];
  List<Widget> _bars; // 底部导航栏
  int _curIndex = 0; // 底部导航栏索引
  // 需要用该控制器，否则即使继承 AutomaticKeepAliveClientMixin，也会重新刷新
  PageController _pc = PageController();

  @override
  void initState() {
    _bars = [
      FortunePage(),
      WorshipPage(),
      RewardPage(),
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
      bottomNavigationBar: _bottomAppBar(),
      backgroundColor: Colors.black26,
      floatingActionButton: GestureDetector(
        onTap: () => _jumpPage(2),
        child: Image.asset('assets/images/tai_chi.png',
            width: Adapt.px(140), height: Adapt.px(140)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// 如果已经登录过一次，则自动登录
  void _autoLogin(BuildContext context) async {
    if (await hadLogin()) {
      print(">>>用户已经登录过，现在自动登录");
      try {
        String mobile = await KV.getStr(kv_user_code);
        String pwd = await KV.getStr(kv_pwd);
        var m = {"user_code": mobile, "pwd": pwd};
        var r = await ApiLogin.login(m);
        if (r != null) {
          await setLoginInfo(r);
          context.read<UserInfoState>().init(r.user_info);
        }
      } catch (e) {
        print("<<<自动登录出现异常：$e");
      }
    } else {
      print(">>>游客登录");
    }
  }

  /// 底部导航栏
  Widget _bottomAppBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _barNames.map(
          (name) {
            int i = _barNames.indexOf(name);
            Color select = _curIndex == i ? t_primary : t_gray;
            return CusSingleBar(
              title: name,
              titleColor: select,
              iconColor: select,
              length: _barNames.length,
              icon: _icon(i),
              onTap: () => _jumpPage(i),
            );
          },
        ).toList(),
      ),
      color: ter_primary,
      shape: CircularNotchedRectangle(),
    );
  }

  /// 动态获取底部导航栏图标
  IconData _icon(int i) {
    IconData icon;
    switch (i) {
      case 0:
        icon = IconData(0xe618, fontFamily: 'AliIcon');
        break;
      case 1:
        icon = IconData(0xe66b, fontFamily: 'AliIcon');
        break;
      case 3:
        icon = IconData(0xe605, fontFamily: 'AliIcon');
        break;
      case 4:
        icon = IconData(0xe608, fontFamily: 'AliIcon');
        break;
      default:
        icon = FontAwesomeIcons.fastForward;
        break;
    }
    return icon;
  }

  /// 跳转页面
  void _jumpPage(int i) {
    if (_curIndex != i) {
      _curIndex = i;
      setState(() {});
      _pc.jumpToPage(_curIndex);
    }
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }
}
