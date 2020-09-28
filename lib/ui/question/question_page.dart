import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/ui/question/flash_post/flash_post_page.dart';
import 'package:yiapp/ui/question/reward_post/reward_post_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 15:39
// usage ：底部导航栏 - 提问页面
// ------------------------------------------------------

class QuestionPage extends StatefulWidget {
  QuestionPage({Key key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  List<String> _tabs = ["悬赏帖", "闪断帖"];

  @override
  void initState() {
    Debug.log("进了提问页面");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: CusAppBar(text: "悬赏提问区", showLeading: false),
        body: _bodyCtr(),
        backgroundColor: primary,
      ),
    );
  }

  Widget _bodyCtr() {
    return Column(
      children: <Widget>[
        TabBar(
          indicatorWeight: Adapt.px(6),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: t_yi,
          labelPadding: EdgeInsets.only(bottom: Adapt.px(5)),
          labelColor: t_yi,
          unselectedLabelColor: t_gray,
          tabs: List.generate(
            _tabs.length,
            (i) => Text(_tabs[i], style: TextStyle(fontSize: Adapt.px(32))),
          ),
          onTap: (index) {
            ApiState.isFlash = index == 1 ? true : false;
          },
        ),
        Expanded(
          child: TabBarView(
            children: <Widget>[
              RewardPostPage(), // 悬赏帖
              FlashPostPage(), // 闪断帖
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
