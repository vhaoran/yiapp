import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/ui/luck/luck_calculate.dart';
import 'package:yiapp/ui/luck/luck_loop.dart';
import 'package:yiapp/util/temp/update_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'luck_calendar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 18:58
// usage ：运势页面
// ------------------------------------------------------

class LuckMainPage extends StatefulWidget {
  LuckMainPage({Key key}) : super(key: key);

  @override
  _LuckMainPageState createState() => _LuckMainPageState();
}

class _LuckMainPageState extends State<LuckMainPage>
    with AutomaticKeepAliveClientMixin {
  var _future;

  @override
  void initState() {
    Log.info("进入运势页面");
    _future = UpdateUtil.compareVersion(context); // 检查是否需要更新
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CusAppBar(text: "每日运势", showLeading: false),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return _lv();
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        children: <Widget>[
          // 每日运势中的轮播图
          LuckLoops(),
          // 当前日期，宜忌注意事项
          LuckCalendar(),
          // 免费、付费测算
          LuckCalculate(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
