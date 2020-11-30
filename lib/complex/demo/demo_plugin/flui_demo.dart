import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/refactor_widgets/su_button.dart';
import 'package:yiapp/complex/refactor_widgets/su_fetch.dart';
import 'package:yiapp/complex/refactor_widgets/su_toast.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/28 下午4:54
// usage ：Flutter小部件UI库flui
// ------------------------------------------------------

class DemoFlui extends StatefulWidget {
  DemoFlui({Key key}) : super(key: key);

  @override
  _DemoFluiState createState() => _DemoFluiState();
}

class _DemoFluiState extends State<DemoFlui> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "第三方插件 flui"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[
        Text("按钮", style: TextStyle(color: Colors.white, fontSize: 20)),
        SuButton(
          child: Text("自定义按钮"),
          onPressed: () {},
        ),
        SizedBox(height: 10),
        Text("Toast", style: TextStyle(color: Colors.white, fontSize: 20)),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: <Widget>[
            SuButton(
              child: Text("text"),
              onPressed: () {
                SuToast.text(text: "修改成功");
              },
            ),
            SuButton(
              child: Text("showText"),
              onPressed: () {
                SuToast.text(text: "修改成功", position: SuToastPosition.bottom);
              },
            ),
            SuButton(
              child: Text("上传成功"),
              onPressed: () {
                var dismiss = SuToast.loading(text: "上传中，请稍后...");
                Future.delayed(Duration(seconds: 2), () {
                  dismiss();
                  SuToast.success(text: "上传成功");
                });
              },
            ),
            SuButton(
              child: Text("信息"),
              onPressed: () {
                SuToast.info(text: "some info");
              },
            ),
            SuButton(
              child: Text("成功"),
              onPressed: () {
                SuToast.success(text: "成功信息");
              },
            ),
            SuButton(
              child: Text("错误"),
              onPressed: () {
                SuToast.error(text: "some error");
              },
            ),
          ],
        ),
        Text("加载数据场景", style: TextStyle(color: Colors.white, fontSize: 20)),
        SuButton(
          onPressed: () {
            CusRoutes.push(
                context,
                SuFetching(
                  showLoading: true,
                  title: '正在加载中...',
                ));
          },
          child: Text("加载数据场景"),
        ),
        Text("自定义ListTile",
            style: TextStyle(color: Colors.white, fontSize: 20)),
        FLListTile(
          title: Text('账号管理'),
          trailing: Icon(Icons.navigate_next),
          onTap: () {},
        )
      ],
    );
  }
}
