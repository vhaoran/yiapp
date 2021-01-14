import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/temp/update_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/small/cus_box.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/14 下午2:05
// usage ：关于我们
// ------------------------------------------------------

class AboutHongYunApp extends StatefulWidget {
  AboutHongYunApp({Key key}) : super(key: key);

  @override
  _AboutHongYunAppState createState() => _AboutHongYunAppState();
}

class _AboutHongYunAppState extends State<AboutHongYunApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "关于我们"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        children: <Widget>[
          SizedBox(height: S.h(10)),
          Container(
            child: ClipOval(
              child: Image.asset("assets/images/ic_launcher.png"),
            ),
            width: S.w(60),
            height: S.h(60),
          ),
          SizedBox(height: S.h(10)),
          Center(
            child: Text(
              // app名称和当前版本号
              CusRole.packageInfo.appName + " " + CusRole.packageInfo.version,
              style: TextStyle(color: t_gray, fontSize: S.sp(16)),
            ),
          ),
          SizedBox(height: S.h(10)),
          NormalBox(
              title: "检查新版版",
              onTap: () async {
                bool ok = await UpdateUtil.compareVersion(context);
                if (!ok) {
                  CusToast.toast(context, text: "当前已是最新版本");
                }
              }),
        ],
      ),
    );
  }
}
