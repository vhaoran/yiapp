import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/ui/masters/vie/master_vie_aim_main.dart';
import 'package:yiapp/ui/masters/vie/master_vie_doing_main.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/23 上午9:32
// usage ：大师控制台的闪断帖，含可抢单和处理中
// ------------------------------------------------------

class MasterViePage extends StatefulWidget {
  MasterViePage({Key key}) : super(key: key);

  @override
  _MasterViePageState createState() => _MasterViePageState();
}

class _MasterViePageState extends State<MasterViePage> {
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
              MasterVieAimMain(),
              MasterVieDoingMain(),
            ],
          ),
        )),
      ],
    );
  }
}
