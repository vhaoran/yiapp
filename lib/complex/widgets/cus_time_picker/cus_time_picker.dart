import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'picker_fn.dart';
import 'picker_mode.dart';
import 'picker_view.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/28 14:18
// usage ：自定义时间选择器（调起各种模式的时间类型选择器）
// ------------------------------------------------------

class CusTimePicker {
  final int itemCount; // 显示几个日期
  final double itemHeight; // 单个日期高度
  final double factor; // 选中日期的放大系数
  final double offset; // 选中日期的偏移量
  final double squeeze; // 挤压系数，值越大，日期间的间隔越小
  final bool showTitle; // 是否显示顶部信息（确定，取消按钮）
  final Color backgroundColor; // 背景色
  final Color color; // 字体颜色
  final PickerMode pickMode; // 选择器模式
  final DateTime current; // 当前选中的时间
  final DateTime start; // 开始时间
  final DateTime end; // 结束时间
  final FnDateChanged onChange; // 值发生变化时的回调
  final FnDateChanged onConfirm; // 点击确认按钮的回调
  final FnCancel onCancel; // 点击取消按钮的回调

  CusTimePicker(
    BuildContext context, {
    this.itemCount: 5,
    this.itemHeight: 38,
    this.factor: 1.2,
    this.offset: 0,
    this.squeeze: 1,
    this.showTitle: true,
    this.backgroundColor: t_gray,
    this.color: Colors.black,
    this.pickMode: PickerMode.date,
    this.current,
    this.start,
    this.end,
    this.onChange,
    this.onConfirm,
    this.onCancel,
  }) {
    _showBottom(
      context,
      backgroundColor: backgroundColor,
      child: PickerView(
          itemCount: itemCount,
          itemHeight: itemHeight,
          factor: factor,
          offset: offset,
          squeeze: squeeze,
          showTitle: showTitle,
          backgroundColor: backgroundColor,
          color: color,
          pickMode: pickMode,
          current: current,
          start: start,
          end: end,
          onCancel: onCancel ?? () {},
          onConfirm: onConfirm ?? (date) {},
          onChange: onChange ?? (date) {}),
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
