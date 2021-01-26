import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/ui/question/ask_question/ask_main_page.dart';
import 'package:yiapp/ui/vip/hehun/hehun_measure_page.dart';
import 'package:yiapp/ui/vip/prize/user_prize_ask_main.dart';
import 'package:yiapp/ui/vip/sizhu/sizhu_measure_page.dart';
import 'package:yiapp/ui/vip/vie/user_vie_ask_main.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/model/login/cus_login_res.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import 'package:yiapp/ui/vip/liuyao/liuyao_shake_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/22 下午3:37
// usage ：会员问命页面
// ------------------------------------------------------

class UserPostAskPage extends StatefulWidget {
  UserPostAskPage({Key key}) : super(key: key);

  @override
  _UserPostAskPageState createState() => _UserPostAskPageState();
}

class _UserPostAskPageState extends State<UserPostAskPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // 提问类型
  final List<String> _selectTypes = ["六爻", "四柱", "合婚", "其他"];
  var _user = SqliteLoginRes(); // 本地用户信息
  Map<String, Widget> _tabW = {};
  var _future;

  @override
  void initState() {
    Log.info("进了提问页面");
    _future = _initLoad();
    super.initState();
  }

  /// 动态显示悬赏帖和闪断帖
  _initLoad() async {
    _user = await LoginDao(glbDB).readUserByUid();
    if (_user.enable_prize == 1) {
      _tabW.addAll({"悬赏帖": UserPrizeAskMain()});
    }
    if (_user.enable_vie == 1) {
      _tabW.addAll({"闪断帖": UserVieAskMain()});
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: _tabW.keys.toList().length,
      child: Scaffold(
        appBar: _appBar(),
        body: FutureBuilder(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              }
              return _bodyCtr();
            }),
        backgroundColor: primary,
      ),
    );
  }

  Widget _appBar() {
    return CusAppBar(
      text: "提问区",
      showLeading: false,
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            // 选择发帖类型
            showDialog(context: context, child: _typeDialog(context));
          },
          child: Text(
            "发帖",
            style: TextStyle(fontSize: S.sp(15), color: t_gray),
          ),
        ),
      ],
    );
  }

  Widget _bodyCtr() {
    return Column(
      children: <Widget>[
        TabBar(
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: t_primary,
          labelPadding: EdgeInsets.only(bottom: 3),
          labelColor: t_primary,
          unselectedLabelColor: t_gray,
          tabs: List.generate(
            _tabW.keys.toList().length,
            (i) => Text(
              _tabW.keys.toList()[i],
              style: TextStyle(fontSize: S.sp(16)),
            ),
          ),
          onTap: (index) {
            // 设置悬赏帖还是闪断帖
            CusRole.isVie = index == 1 ? true : false;
          },
        ),
        SizedBox(height: S.h(5)),
        Expanded(child: TabBarView(children: _tabW.values.toList())),
      ],
    );
  }

  /// 选择问命类型
  Widget _typeDialog(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SimpleDialog(
          backgroundColor: tip_bg,
          title: Center(
            child: Text("选择一个你想咨询的类型", style: TextStyle(fontSize: S.sp(15))),
          ),
          titlePadding: EdgeInsets.all(16),
          contentPadding: EdgeInsets.all(0),
          children: List.generate(
            _selectTypes.length,
            (i) => Column(
              children: <Widget>[
                Divider(height: 1),
                Container(
                  width: double.infinity, // 点击整行都可跳转
                  child: FlatButton(
                    child: Text(_selectTypes[i],
                        style: TextStyle(fontSize: S.sp(15))),
                    onPressed: () => _pushWhere(context, i),
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.clear, color: t_gray),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  /// 根据发帖类型跳转
  void _pushWhere(context, int i) {
    // 关闭选择类型弹框
    Navigator.pop(context);
    // i 的顺序是 _selectTypes 列表的顺序
    switch (i) {
      case 0: // 六爻
        CusRoute.pushReplacement(context, LiuYaoShakePage());
        break;
      case 1: // 四柱
        CusRoute.push(context, SiZhuMeasurePage());
        break;
      case 2: // 合婚
        CusRoute.push(context, HeHunMeasurePage());
        break;
      case 3: // 其他
        CusRoute.pushReplacement(
          context,
          AskQuestionPage(content_type: submit_other),
        );
        break;
      default:
        Navigator.pop(context);
        break;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
