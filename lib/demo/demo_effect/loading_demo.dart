import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/service/api/api_user.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/12 09:37
// usage ：loading 加载框演示
// ------------------------------------------------------

class LoadingDemo extends StatefulWidget {
  LoadingDemo({Key key}) : super(key: key);

  @override
  _LoadingDemoState createState() => _LoadingDemoState();
}

class _LoadingDemoState extends State<LoadingDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "loading 演示"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 30),
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            CusToast.toast(context, text: "这是弹框");
          },
          child: Text("普通弹框"),
        ),
        RaisedButton(
          onPressed: () {
            CusToast.toast(context, text: "这是弹框", showChild: true);
          },
          child: Text("完成的弹框"),
        ),
        RaisedButton(
          onPressed: () async {
            var res = await ApiUser.getUser({});
            if (res != null) {
              CusToast.toast(context, text: "修改成功");
            }
          },
          child: Text("模拟获取数据"),
        ),
        Center(
          child: Text(
            "自定义 SpinKit",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        RaisedButton(
          onPressed: () => SpinKit.threeBounce(context),
          child: Text("01 three Bounce"),
        ),
        RaisedButton(
          onPressed: () => SpinKit.fadingCircle(context),
          child: Text("02 fading Circle"),
        ),
        RaisedButton(
          onPressed: () => SpinKit.ripple(context),
          child: Text("03 ripple"),
        ),
        RaisedButton(
          onPressed: () => SpinKit.fadingCube(context),
          child: Text("04 fading Cube"),
        ),
        RaisedButton(
          onPressed: () => SpinKit.dualRing(context),
          child: Text("05 dual Ring"),
        ),
        RaisedButton(
          onPressed: () => SpinKit.ring(context),
          child: Text("06 ring"),
        ),
      ],
    );
  }
}
