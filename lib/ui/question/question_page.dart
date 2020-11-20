import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/login/cus_login_res.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_main.dart';
import 'package:yiapp/ui/question/flash_post/flash_post_page.dart';
import 'package:yiapp/ui/question/reward_post/reward_post_page.dart';
import 'ask_question/ask_main_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 15:39
// usage ：底部导航栏 - 问命页面
// ------------------------------------------------------

class QuestionPage extends StatefulWidget {
  QuestionPage({Key key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // 提问类型
  final List<String> _queTypes = ["六爻", "四柱", "合婚", "其他", "取消"];
  var _user = CusLoginRes(); // 本地用户信息
  List<String> _tabs = [];

  @override
  void initState() {
    Debug.log("进了提问页面");
    _init();
    super.initState();
  }

  /// 动态显示悬赏帖和闪断帖
  void _init() async {
    _user = await LoginDao(glbDB).readUserByUid();
    setState(() {
      if (_user.enable_prize == 1) {
        _tabs.add("悬赏帖");
      }
      if (_user.enable_vie == 1) {
        _tabs.add("闪断帖");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: CusAppBar(
          text: "提问区",
          showLeading: false,
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                // 选择发帖类型
                showDialog(context: context, child: _typeDialog(context));
              },
              child: Text("发帖", style: TextStyle(fontSize: 16, color: t_gray)),
            ),
          ],
        ),
        body: _bodyCtr(),
        backgroundColor: primary,
      ),
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
            _tabs.length,
            (i) => Text(_tabs[i], style: TextStyle(fontSize: 18)),
          ),
          onTap: (index) {
            // 在这里设置悬赏帖还是闪断帖
            ApiState.isFlash = index == 1 ? true : false;
          },
        ),
        Expanded(
            child: TabBarView(
          children: <Widget>[
            if (_user.enable_prize == 1) RewardPostPage(),
            if (_user.enable_vie == 1) FlashPostPage(),
          ],
        )),
      ],
    );
  }

  /// 选择问命类型
  Widget _typeDialog(context) {
    return SimpleDialog(
      backgroundColor: tipBg,
      title: Center(child: Text('请选择一个您想咨询的类型')),
      titlePadding: EdgeInsets.all(24),
      contentPadding: EdgeInsets.all(0),
      children: List.generate(
        _queTypes.length,
        (i) => Column(
          children: <Widget>[
            Divider(height: 1),
            Container(
              width: double.infinity, // 点击整行都可跳转
              child: FlatButton(
                child: CusText(_queTypes[i], Colors.black, 30),
                onPressed: () => _pushWhere(context, i),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 根据发帖类型跳转
  void _pushWhere(context, int i) {
    switch (i) {
      case 0: // 六爻
        CusRoutes.pushReplacement(context, LiuYaoPage());
        break;
      case 1: // 四柱
        CusRoutes.pushReplacement(
          context,
          AskQuestionPage(content_type: post_sizhu, barName: "四柱"),
        );
        break;
      case 2: // 合婚
        CusRoutes.pushReplacement(
          context,
          AskQuestionPage(content_type: post_hehun, barName: "合婚"),
        );
        break;
      case 3: // 其他
        CusRoutes.pushReplacement(
            context, AskQuestionPage(content_type: 0, barName: "其他"));
        break;
      default:
        Navigator.pop(context);
        break;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
