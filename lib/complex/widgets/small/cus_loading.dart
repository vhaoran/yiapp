import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/12 14:55
// usage ：弹出的加载页面
// ------------------------------------------------------

class SpinKit {
  static threeBounce(BuildContext context,
      {Color color = Colors.white, double size = 40, bool show = true}) {
    _comDialog(
      context,
      show: show,
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

  static _comDialog(BuildContext context, {Widget child, bool show = true}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          child,
          if (show) ...[
            SizedBox(height: 15),
            Text("请稍等...", style: TextStyle(fontSize: 20, color: Colors.white)),
          ],
        ],
      ),
    );
  }
}
