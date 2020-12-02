import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/ui/fortune/daily_fortune/daily_fortune.dart';
import 'package:yiapp/ui/luck/luck_loop.dart';
import 'package:yiapp/widget/flutter/button_plugins.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/su_button.dart';
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
  @override
  void initState() {
    Log.info("进入了运势页面");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CusAppBar(text: "每日运势", showLeading: false),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    print(">>>设备宽度Width：${ScreenUtil().screenWidth}");
    print(">>>设备宽度WidthPx：${ScreenUtil().screenWidthPx}");
    print(">>>设备高度Width：${ScreenUtil().screenHeight}");
    print(">>>设备宽度HeightPx：${ScreenUtil().screenHeightPx}");
    print(">>>pixelRatio:${ScreenUtil().pixelRatio}");
    return ListView(
      children: <Widget>[
        LuckLoops(), // 每日运势中的轮播图
        LuckCalendar(),
//        SuButton(
//          child: Text("按钮"),
//          onPressed: () {},
//        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
