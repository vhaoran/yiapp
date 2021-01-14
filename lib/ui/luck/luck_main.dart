import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_update_dialog/flutter_update_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/model/complex/update_res.dart';
import 'package:yiapp/ui/luck/luck_calculate.dart';
import 'package:yiapp/ui/luck/luck_loop.dart';
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
  UpdateRes _res;
  // 获取服务器apk版本号以及下载地址
  final _versionUrl = "https://hy3699.com/version";

  @override
  void initState() {
    Log.info("进入运势页面");
    _future = _compareVersion();
    super.initState();
  }

  /// 比较版本号
  _compareVersion() async {
    try {
      Response response = await Dio().get(_versionUrl);
      if (response != null) {
        var m = UpdateRes.fromJson(json.decode(response.data));
        _res = m;
        Log.info("返回的版本号：${m.version},下载地址：${m.url}");
        String serverVersion = _res.version.replaceAll(".", "");
        String localVersion = CusRole.packageInfo.version.replaceAll(".", "");
        bool update = num.parse(serverVersion) > num.parse(localVersion);
        if (update) {
          _updateDialog();
        }
      }
    } catch (e) {
      Log.error("获取版本号出现异常：$e");
    }
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

  /// 提示更新弹窗
  void _updateDialog() {
    UpdateDialog.showUpdate(context,
        width: 260,
        titleTextSize: 16,
        contentTextSize: 15,
        buttonTextSize: 15,
        updateButtonText: '升级',
        themeColor: Color(0xFFFFAC5D), // 按钮背景色
        title: "检测到新版本 ${_res.version}",
        topImage: Image.asset('assets/images/bg_update_top.png'),
        updateContent: "当前版本 ${CusRole.packageInfo.version}",
        onUpdate: () async {
      try {
        if (await canLaunch(_res.url)) {
          Log.info("apk下载地址有效，可以下载");
          bool ok = await launch(_res.url, forceSafariVC: false);
          Log.info("打开浏览器结果:$ok");
          Navigator.pop(context);
        }
      } catch (e) {
        Log.error("下载apk出现异常：$e");
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
