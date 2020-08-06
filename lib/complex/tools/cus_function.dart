import 'dart:ui';
import 'package:flutter/material.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/6 10:32
// usage ：自定义功能函数
// ------------------------------------------------------

/// 01 自定义颜色
class CusColors {
  // AppBar、BottomNavigationBar 等背景色
  static const Color bar = Color.fromRGBO(51, 44, 44, 1);
  // 最常见的文字颜色
  static const Color text = Color.fromRGBO(255, 198, 121, 1);
}

/// 02 自定义路由
class CusRoutes {
  // push 跳转到下一个页面
  static Future<dynamic> push(BuildContext context, Widget page) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  // pushReplacement 跳转到下一个页面并销毁当前页面
  static Future<dynamic> pushReplacement(BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => page),
    );
  }
}

/// 03 解析时间为指定格式
class CusTime {
  // 转换为年月日 2020年6月29日
  static String ymd(String created_at) {
    var date = DateTime.parse(created_at);
    String time = "${date.year}年${date.month}月${date.day}日";
    return time;
  }

  // 转换为时分 15:29
  static String hm(String created_at) {
    var date = DateTime.parse(created_at);
    String minute = date.minute < 10 ? "0${date.minute}" : "${date.minute}";
    return "${date.hour}:$minute";
  }

  // 转换为年月日时分 2020年8月6日10:37
  static String ymdhm(String created_at) {
    var date = DateTime.parse(created_at);
    String minute = date.minute < 10 ? "0${date.minute}" : "${date.minute}";
    return "${date.year}年${date.month}月${date.day}日${date.hour}:$minute";
  }
}

/// 04 自定义正则验证
class CusReg {
  // 验证手机号
  static bool phone(String phone) {
    return RegExp(r"1[0-9]\d{9}$").hasMatch(phone);
  }

  // 纯数字
  static bool money(String money) {
    return RegExp(r"^[0-9]*$").hasMatch(money);
  }
}

/// 05 自定义数学运算
class CusMath {
  // 四舍五入保留小数(默认两位)
  static num asFixed(dynamic value, {int fixed = 2}) {
    if (value is double) {
      return num.parse(value.toStringAsFixed(fixed));
    } else if (value is String) {
      return num.parse(num.parse(value).toStringAsFixed(fixed));
    }
    return value; // 如果是int，不需要保留小数直接显示
  }
}

/// 屏幕自适应类
class Adapt {
  // Flutter 中控件的高宽和字体大小时，使用的是逻辑像素，并非是实际的物理像素，
  // 实际像素 = 逻辑像素 * MediaQuery.devicePixelRatio

  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);

  // 用逻辑像素表示的屏幕宽度
  static double _width = mediaQuery.size.width;

  // 用逻辑像素表示的屏幕高度
  static double _height = mediaQuery.size.height;

  // 屏幕上部被系统UI遮挡的部分的逻辑高度（即：状态栏高度）
  static double _topBarH = mediaQuery.padding.top;

  static double _botBarH = mediaQuery.padding.bottom;

  // 每一个逻辑像素点对应的物理像素点个数
  static double _pixelRatio = mediaQuery.devicePixelRatio;

  static var _ratio;

  // 默认750设计图，计算真实像素值，实际尺寸 = UI 尺寸 * 设备宽度 / 设计图宽度
  static init(int number) {
    int uiWidth = number is int ? number : 750;
    _ratio = _width / uiWidth;
  }

  static px(number) {
    if (!(_ratio is double || _ratio is int)) {
      Adapt.init(750);
    }
    return number * _ratio;
  }

  // 1px像素大小
  static onePx() => 1 / _pixelRatio;

  static screenW() => _width;

  static screenH() => _height;

  static padTopH() => _topBarH;

  static padBotH() => _botBarH;
}
