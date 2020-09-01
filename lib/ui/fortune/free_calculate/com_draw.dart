import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shake_animation_widget/shake_animation_widget.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/cus_math.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/service/api/api_free.dart';
import 'package:yiapp/ui/fortune/free_calculate/com_draw_res.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/31 16:02
// usage ：通用的免费抽灵签组件
// ------------------------------------------------------

class ComDrawPage extends StatefulWidget {
  ComDrawPage({Key key}) : super(key: key);

  @override
  _ComDrawPageState createState() => _ComDrawPageState();
}

class _ComDrawPageState extends State<ComDrawPage> {
  String _title; // 传递过来的名称
  var _aniCtrl = ShakeAnimationController(); // 抖动动画控制器
  bool _enable = true; // 默认抽签按钮可以点击

  @override
  Widget build(BuildContext context) {
    _title = ModalRoute.of(context).settings.arguments ?? "";
    return Scaffold(
      appBar: CusAppBar(text: _title),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          // 摇签动画
          _shakeAnimation(),
        ],
      ),
      backgroundColor: primary,
    );
  }

  /// 抽签动画
  Widget _shakeAnimation() {
    String path = "assets/images/shake_sign.png";
    return ShakeAnimationWidget(
      shakeAnimationController: _aniCtrl,
      shakeAnimationType: ShakeAnimationType.RoateShake, // 微旋转的抖动
      isForward: false, // 设置不开启抖动
      shakeCount: 1,
      shakeRange: 0.4, // 抖动的幅度 取值范围为[0,1]
      child: Center(
        child: InkWell(
          child: Image.asset(path, scale: 1.2),
          onTap: _enable
              ? () async {
                  setState(() => _enable = false);
                  if (_aniCtrl.animationRunging) {
                    _aniCtrl.stop();
                  } else {
                    _aniCtrl.start(shakeCount: 1);
                    await Future.delayed(Duration(milliseconds: 1000)).then(
                      (value) {
                        int num = CusMath.random(mod: _mod());
                        String tip = CusMath.numToChinese(num);
                        CusDialog.tip(
                          context,
                          child: Image.asset(path, scale: 4),
                          title: "您抽到了第$tip签",
                          textAgree: "解签",
                          onApproval: () => _chooseDraw(_title, num),
                        );
                      },
                    );
                    setState(() => _enable = true);
                  }
                }
              : null,
        ),
      ),
    );
  }

  /// 选择不同的灵签
  void _chooseDraw(String drawName, int num) async {
    var res;
    var m = {"num": num};
    try {
      switch (drawName) {
        case "大仙灵签":
          res = await ApiFree.daXianDraw(m);
          break;
        case "关公灵签":
          res = await ApiFree.guanDiDraw(m);
          break;
        case "观音灵签":
          res = await ApiFree.guanYinDraw(m);
          break;
        case "妈祖灵签":
          res = await ApiFree.maZuDraw(m);
          break;
        case "月老灵签":
          res = await ApiFree.yueLaoDraw(m);
          break;
        case "车公灵签":
          res = await ApiFree.cheGongDraw(m);
          break;
        case "吕祖灵签":
          res = await ApiFree.lvZuDraw(m);
          break;
        default:
          break;
      }
    } catch (e) {
      print("<<<$_title灵签出现异常：$e");
    }
    if (res != null) {
      CusRoutes.push(
        context,
        ComDrawResPage(result: res, title: _title),
      );
    }
  }

  /// 根据不同模式取模
  int _mod() {
    int mod = 0;
    switch (_title) {
      case "大仙灵签":
      case "关公灵签":
      case "观音灵签":
        mod = 100;
        break;
      case "妈祖灵签":
      case "吕祖灵签":
        mod = 60;
        break;
      case "月老灵签":
        mod = 101;
        break;
      case "车公灵签":
        mod = 96;
        break;
      default:
        break;
    }
    return mod;
  }
}
