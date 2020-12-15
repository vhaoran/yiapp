import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/ui/master/master_console/console_process.dart';
import 'package:yiapp/ui/question/post_data_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/15 下午2:16
// usage ：大师控制台 -- 查看闪断帖可抢单的和处理中的
// ------------------------------------------------------

class ConsoleVie extends StatefulWidget {
  ConsoleVie({Key key}) : super(key: key);

  @override
  _ConsoleVieState createState() => _ConsoleVieState();
}

class _ConsoleVieState extends State<ConsoleVie> {
  final List<String> _tabsName = ["可抢单", "处理中"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabsName.length,
      child: Scaffold(
        appBar: CusAppBar(text: "闪断帖"),
        body: _body(),
        backgroundColor: primary,
      ),
    );
  }

  Widget _body() {
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
        ),
        SizedBox(height: S.h(5)),
        Expanded(
            child: ScrollConfiguration(
          behavior: CusBehavior(),
          child: TabBarView(
            children: <Widget>[
              PostDataPage(isVie: true),
              ConsoleProcess(),
            ],
          ),
        )),
      ],
    );
  }
}
