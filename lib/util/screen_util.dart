import 'package:flutter_screenutil/flutter_screenutil.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/3 上午10:29
// usage ：封装ScreenUtil，便于使用和缩短代码
// ------------------------------------------------------

class S {
  static num _ratio = 2; // 2倍比例

  /// 字体大小适配
  static double sp(num fontSize, {bool allowFontScalingSelf}) {
    double setSp = ScreenUtil()
        .setSp(fontSize * _ratio, allowFontScalingSelf: allowFontScalingSelf);
    return setSp;
  }

  /// 宽度适应
  static double w(num width) {
    return ScreenUtil().setWidth(width * _ratio);
  }

  /// 高度适应
  static double h(num height) {
    return ScreenUtil().setHeight(height * _ratio);
  }

  /// 设备宽度
  static double screenW() {
    return ScreenUtil().screenWidth;
  }

  /// 设备高度
  static double screenH() {
    return ScreenUtil().screenHeight;
  }
}
