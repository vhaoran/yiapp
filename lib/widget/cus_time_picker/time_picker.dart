import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/global/cus_fn.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'picker_fn.dart';
import 'picker_mode.dart';
import 'picker_main.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/28 14:18
// usage ：自定义时间选择器（调起各种模式的时间类型选择器）
// ------------------------------------------------------

class TimePicker {
  final int itemCount; // 显示几行日期
  final double itemHeight; // 单个日期高度
  final int minYear; // 最小年份
  final int maxYear; // 最大年份
  final double factor; // 选中日期的放大系数
  final double offset; // 选中日期的偏移量
  final double squeeze; // 挤压系数，值越大，日期间的间隔越小
  final bool showHeader; // 是否显示顶部信息（确定，取消按钮）
  final bool showLunar; // 是否显示阴历
  final bool padLeft; // 月、日、时、分,不满足2位数的是否在前面补0
  final bool resIsString; // 返回的结果是否为字符串，默认false,返回int数组
  final Color backgroundColor; // 背景色
  final Color color; // 字体颜色
  final PickerMode pickMode; // 选择器模式
  final DateTime current; // 当前选中的时间
  final DateTime start; // 开始时间，如 DateTime(2014, 5，14)
  final DateTime end; // 结束时间,目前设置后有问题，后续再改
  final FnDateChanged onChange; // 值发生变化时的回调
  final FnOnConfirm onConfirm;
  final FnBool isLunar; // 选中的是否为阴历

  TimePicker(
    BuildContext context, {
    this.itemCount: 5,
    this.itemHeight: 38,
    this.minYear: 1900,
    this.maxYear: 2020,
    this.factor: 1.2,
    this.offset: 0,
    this.squeeze: 1,
    this.showHeader: true,
    this.showLunar: false,
    this.padLeft: false,
    this.resIsString: false,
    this.backgroundColor: t_gray,
    this.color: Colors.black,
    this.pickMode: PickerMode.date,
    this.current,
    this.start,
    this.end,
    this.onChange,
    this.onConfirm,
    this.isLunar,
  }) {
    if (current != null) {
      if (start != null && current.year < start.year) {
        CusDialog.tip(context, title: "当前年份不能小于开始年份", agreeColor: Colors.red);
        return;
      }
      if (end != null && current.year > end.year) {
        CusDialog.tip(context, title: "当前年份不能大于结束年份", agreeColor: Colors.red);
        return;
      }
    }

    _showBottom(
      context,
      backgroundColor: backgroundColor,
      child: PickerView(
        itemCount: itemCount,
        itemHeight: itemHeight,
        minYear: minYear,
        maxYear: maxYear,
        factor: factor,
        offset: offset,
        squeeze: squeeze,
        showHeader: showHeader,
        showLunar: showLunar,
        resIsString: resIsString,
        padLeft: padLeft,
        backgroundColor: backgroundColor,
        color: color,
        pickMode: pickMode,
        current: current,
        start: start,
        end: end,
        onChange: onChange ?? (date) {},
        onConfirm: onConfirm ?? (date) {},
        isLunar: isLunar,
      ),
    );
  }

  /// 底部弹框
  Future _showBottom(
    BuildContext context, {
    Widget child,
    Color backgroundColor,
  }) async {
    return await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => child,
      clipBehavior: Clip.antiAlias,
      backgroundColor: backgroundColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
        ),
      ),
    );
  }
}
