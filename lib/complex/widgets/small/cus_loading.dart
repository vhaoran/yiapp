import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/12 14:55
// usage ：弹出的加载页面
// ------------------------------------------------------

class SpinKit {
  /// 三个圆点的loading框，目前只用了这个，其它的用来扩展
  static threeBounce(
    BuildContext context, {
    Color color = Colors.white,
    double size = 40,
    bool show = true,
    String text,
    int seconds,
    String errText,
  }) {
    _comDialog(
      context,
      show: show,
      text: text,
      seconds: seconds,
      errText: errText,
      child: SpinKitThreeBounce(color: color, size: size),
    );
  }

  static ripple(BuildContext context,
      {Color color = Colors.white, double size = 120, bool show = true}) {
    _comDialog(
      context,
      show: show,
      child: SpinKitRipple(color: color, size: size),
    );
  }

  static fadingCube(BuildContext context,
      {Color color = Colors.white, double size = 50, bool show = true}) {
    _comDialog(
      context,
      show: show,
      child: SpinKitFadingCube(color: color, size: size),
    );
  }

  static dualRing(BuildContext context,
      {Color color = Colors.white, double size = 60, bool show = true}) {
    _comDialog(
      context,
      show: show,
      child: SpinKitDualRing(color: color, size: size),
    );
  }

  static ring(BuildContext context,
      {Color color = Colors.white, double size = 60, bool show = true}) {
    _comDialog(
      context,
      show: show,
      child: SpinKitRing(color: color, size: size),
    );
  }

  static fadingCircle(BuildContext context,
      {double size = 70, bool show = true}) {
    _comDialog(
      context,
      show: show,
      child: SpinKitFadingCircle(
        size: size,
        itemBuilder: (BuildContext context, int index) => DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white, // 这里也可以根据index的奇偶性设置不同颜色
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  static _comDialog(
    BuildContext context, {
    Widget child,
    bool show = true, // 是否显示提示文字
    String text, // 提示内容
    String errText, // 超时提示内容
    int seconds, // 超时时间
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          child,
          if (show) ...[
            SizedBox(height: 15),
            Text(
              text ?? "请稍等...",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ],
      ),
    ).timeout(Duration(seconds: seconds ?? 10), onTimeout: () {
      Navigator.pop(context);
      // 超时提示
      CusDialog.tip(context, title: errText ?? "请求数据异常，请重新尝试");
    });
  }
}
