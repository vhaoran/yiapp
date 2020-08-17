import 'package:flutter/material.dart';
import '../../tools/adapt.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/7 10:45
// usage ：悬浮弹框（适用于上面一个文本，下面一个Widget）
// ------------------------------------------------------

enum ToastPos {
  top,
  center,
  bottom,
}

/// 提示框
class CusToast {
  String text; // 提示信息
  double textSize; // 文字大小
  double pdHor; // 左右边距
  double pdVer; // 上下边距
  Color bgColor; // 背景颜色
  Color textColor; // 文本颜色
  int time; // 显示的时间毫秒
  bool showing; // 是否正在显示 toast
  bool showChild;
  Widget child; // 文字下面显示的图标
  ToastPos pos; // 显示位置

  CusToast.toast(
    BuildContext context, {
    this.text = "提示信息",
    this.textSize,
    this.pdHor = 18,
    this.pdVer = 14,
    this.bgColor = Colors.black,
    this.textColor = Colors.white,
    this.time = 1000,
    this.showing = false,
    this.showChild = true,
    this.child,
    this.pos = ToastPos.center,
  }) {
    // 开启一个新 toast 的当前时间，用于对比是否已经展示了指定时间
    DateTime startedTime = DateTime.now();
    OverlayState overlayState = Overlay.of(context);
    showing = true;
    OverlayEntry overlayEntry; // toast 靠它加到屏幕上

    if (overlayEntry == null) {
      // 通过 OverlayEntry 将构建的布局插入到整个布局的最上层
      overlayEntry = OverlayEntry(builder: (BuildContext context) {
        return Positioned(
          top: _toastPos(context), // 可以改变这个值来改变toast在屏幕中的位置
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Adapt.px(80)),
              child: AnimatedOpacity(
                opacity: showing ? 1 : 0, // 透明度
                duration: showing
                    ? Duration(milliseconds: 100)
                    : Duration(milliseconds: 400),
                child: _toastCtr(),
              ),
            ),
          ),
        );
      });
      //插入到整个布局的最上层
      overlayState.insert(overlayEntry);
    } else {
      overlayEntry.markNeedsBuild(); // 重新绘制UI，类似 setState
    }
    _delayed(startedTime, overlayEntry);
  }

  /// 等待时间
  void _delayed(DateTime startedTime, OverlayEntry overlayEntry) async {
    await Future.delayed(Duration(milliseconds: time));
    if (DateTime.now().difference(startedTime).inMilliseconds >= time) {
      showing = false;
      overlayEntry?.markNeedsBuild();
      await Future.delayed(Duration(milliseconds: 400));
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }

  /// 生成 toast
  _toastCtr() {
    return Card(
      color: bgColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: pdHor, vertical: pdVer),
        child: Column(
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  fontSize: Adapt.px(textSize ?? 34), color: textColor),
            ),
            if (showChild) ...[
              SizedBox(height: Adapt.px(20)),
              child ??
                  Image.asset('assets/images/icon_selected_20x20.png',
                      scale: Adapt.px(2.5)),
            ],
          ],
        ),
      ),
    );
  }

  /// 设置 toast 位置
  double _toastPos(context) {
    var tmp;
    if (pos == ToastPos.top) {
      tmp = MediaQuery.of(context).size.height * 1 / 4;
    } else if (pos == ToastPos.center) {
      tmp = MediaQuery.of(context).size.height * 2 / 5;
    } else {
      tmp = MediaQuery.of(context).size.height * 3 / 4;
    }
    return tmp;
  }
}
