import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/ui/question/post_data_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/model/login/cus_login_res.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_main.dart';
import 'ask_question/ask_main_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 15:39
// usage ：底部导航栏 - 问命页面
// ------------------------------------------------------

class QueMainPage extends StatefulWidget {
  QueMainPage({Key key}) : super(key: key);

  @override
  _QueMainPageState createState() => _QueMainPageState();
}

class _QueMainPageState extends State<QueMainPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // 提问类型
  final List<String> _selectTypes = ["六爻", "四柱", "合婚", "其他"];
  var _user = CusLoginRes(); // 本地用户信息
  List<String> _tabsName = [];
  List<Widget> _tabsWidget = []; // 悬赏帖闪断帖页面
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
      _tabsName.add("悬赏帖");
      _tabsWidget.add(PostDataPage());
    }
    if (_user.enable_vie == 1) {
      _tabsName.add("闪断帖");
      _tabsWidget.add(PostDataPage(isVie: true));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: _tabsName.length,
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
            _tabsName.length,
            (i) => Text(_tabsName[i], style: TextStyle(fontSize: S.sp(16))),
          ),
          onTap: (index) {
            // 设置悬赏帖还是闪断帖
            CusRole.isVie = index == 1 ? true : false;
          },
        ),
        Expanded(child: TabBarView(children: _tabsWidget)),
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
    // i 的顺序是 _selectTypes 列表的顺序
    switch (i) {
      case 0: // 六爻
        CusRoute.pushReplacement(context, LiuYaoPage());
        break;
      case 1: // 四柱
        CusRoute.pushReplacement(
            context, AskQuestionPage(content_type: post_sizhu));
        break;
      case 2: // 合婚
        CusRoute.pushReplacement(
            context, AskQuestionPage(content_type: post_hehun));
        break;
      case 3: // 其他
        CusRoute.pushReplacement(context, AskQuestionPage(content_type: 0));
        break;
      default:
        Navigator.pop(context);
        break;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
