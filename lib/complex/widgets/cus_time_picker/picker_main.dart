import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:secret/tools/lunar.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/model/yi_date_time.dart';
import 'package:yiapp/complex/const/const_list.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/tools/cus_time.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/picker_template.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/picker_header.dart';
import 'dart:async';
import 'picker_fn.dart';
import 'picker_mode.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/28 17:18
// usage ：时间选择器布局页面
// ------------------------------------------------------

class PickerView extends StatefulWidget {
  final int itemCount;
  final double itemHeight;
  final int minYear;
  final int maxYear;
  final double factor;
  final double offset;
  final double squeeze;
  final bool showHeader;
  final bool showLunar;
  final bool resIsString;
  final bool padLeft;
  final Color backgroundColor;
  final Color color;
  final PickerMode pickMode;
  final DateTime current;
  final DateTime start;
  final DateTime end;
  final FnDateChanged onChange;
  final FnOnConfirm onConfirm;
  final FnBool isLunar;

  PickerView({
    this.itemCount,
    this.itemHeight,
    this.minYear,
    this.maxYear,
    this.factor,
    this.offset,
    this.squeeze,
    this.showHeader,
    this.showLunar,
    this.resIsString,
    this.padLeft,
    this.backgroundColor,
    this.color,
    this.pickMode,
    DateTime current,
    this.start,
    this.end,
    this.onChange,
    this.onConfirm,
    this.isLunar,
  }) : this.current = current == null ? DateTime.now() : current;

  @override
  _PickerViewState createState() => _PickerViewState();
}

class _PickerViewState extends State<PickerView> {
  // 2020年的_yearIndex是0，2016年的_yearIndex是4，其它字段同理
  int _yearIndex, _monthIndex, _dayIndex, _hourIndex, _minuteIndex = 0;
  var _yearCtrl, _monthCtrl, _dayCtrl, _hourCtrl, _minuteCtrl;
  final DateTime _now = DateTime.now();
  DateTime _lastDt; // 上一次回调的时间
  bool _isScroll = false; // 如果是手动滚动，不要触发onChange
  bool _isLunar = false; // 是否阴历，默认false，
  bool _isZhouYi = false; // 是否为周易日历
  Timer _timer; // 定时器

  @override
  void initState() {
    _isZhouYi = widget.pickMode == PickerMode.yi;
    // 获取每个日期索引
    _yearIndex = widget.current.year - _now.year;
    _monthIndex = widget.current.month - 1;
    _dayIndex = widget.current.day - 1;
    // 如果是周易日历，小时下标默认为 11:00-12:59 午时
    _hourIndex = _isZhouYi ? 6 : widget.current.hour;
    _minuteIndex = widget.current.minute;

    // 监听滚动偏移
    _yearCtrl = FixedExtentScrollController(initialItem: _yearIndex);
    _monthCtrl = FixedExtentScrollController(initialItem: _monthIndex);
    _dayCtrl = FixedExtentScrollController(initialItem: _dayIndex);
    _hourCtrl = FixedExtentScrollController(initialItem: _hourIndex);
    _minuteCtrl = FixedExtentScrollController(initialItem: _minuteIndex);
    super.initState();
  }

  /// 点击确认后的回调
  void _onConfirm() {
    int year = _now.year + _yearIndex;
    int month = _monthIndex + 1;
    int day = _dayIndex + 1;
    // time 是当前选择的阳历时间
    DateTime time = DateTime(year, month, day, _hourIndex, _minuteIndex);
    Debug.log("time:${time}");
    Lunar lunar = Lunar.fromDate(time);
    print(">>>是否阴历：$_isLunar");
    Debug.log("lunmonth:${lunar.month}");
    Debug.log("moustr:${_fnSelectMonth(_monthIndex)}");
    YiDateTime yiDt = YiDateTime(
      year: year,
      month: _isLunar ? lunar.month : month, // 根据阴阳历选择月
      day: _isLunar ? lunar.day : day, // 根据阴阳历选择日
      hour: _hourIndex,
      minute: _minuteIndex,
      monthStr: _fnSelectMonth(_monthIndex),
      dayStr: _fnSelectDay(_dayIndex),
      // 目前只能周易日历需要显示 hourStr
      hourStr: _isZhouYi ? c_old_times[_hourIndex].substring(14) : null,
    );
    YiDateTime res = yiDt.fromPickMode(widget.pickMode);
    print(">>>res.tojson:${res.toJson()}");
    widget.onConfirm(res);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.showHeader)
          PickerHeader(
            onFirm: _onConfirm,
            showLunar: widget.showLunar,
            selectLunar: (b) {
              _isLunar = b;
              if (widget.isLunar != null) {
                widget.isLunar(b);
              }
              setState(() {});
            },
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ..._dynamicPicker(widget.pickMode),
          ],
        ),
      ],
    );
  }

  /// 根据传入的模式动态展示选择器
  List<Widget> _dynamicPicker(PickerMode mode) {
    List<Widget> l = [];
    // 是否显示 年
    if (!(mode == PickerMode.hour_minute || mode == PickerMode.month_day)) {
      l.add(PickerTemplate(
        pickView: widget,
        scrollCtrl: _yearCtrl,
        onScrollEnd: _changeDate,
        onScrolling: _changeYear,
        fnSelectStr: _fnSelectYear,
      ));
    }
    // 是否显示 月
    if (!(mode == PickerMode.hour_minute || mode == PickerMode.year)) {
      l.add(PickerTemplate(
        pickView: widget,
        scrollCtrl: _monthCtrl,
        onScrollEnd: _changeDate,
        onScrolling: _changeMonth,
        fnSelectStr: _fnSelectMonth,
      ));
    }
    // 是否显示 日
    if (!(mode == PickerMode.year ||
        mode == PickerMode.year_month ||
        mode == PickerMode.hour_minute)) {
      l.add(PickerTemplate(
        pickView: widget,
        scrollCtrl: _dayCtrl,
        onScrollEnd: _changeDate,
        onScrolling: _changeDay,
        fnSelectStr: _fnSelectDay,
      ));
    }
    // 是否显示 时
    if (mode == PickerMode.hour_minute ||
        mode == PickerMode.full ||
        mode == PickerMode.yi) {
      l.add(PickerTemplate(
        pickView: widget,
        scrollCtrl: _hourCtrl,
        onScrollEnd: _changeDate,
        onScrolling: _changeHour,
        fnSelectStr: _isZhouYi ? _fnSelectZhouYi : _fnSelectHour,
        flex: _isZhouYi ? 2 : 1,
      ));
    }
    // 是否显示 分
    if (mode == PickerMode.hour_minute || mode == PickerMode.full) {
      l.add(PickerTemplate(
        pickView: widget,
        scrollCtrl: _minuteCtrl,
        onScrollEnd: _changeDate,
        onScrolling: _changeMinute,
        fnSelectStr: _fnSelectMinute,
      ));
    }
    return l;
  }

  void _scrollItem(int index, int min, int max, dynamic control) {
    if (index > max) {
      control.jumpToItem(max);
    } else if (index < min) {
      control.jumpToItem(min);
    } else {
      control.jumpToItem(index - 1);
      control.jumpToItem(index);
    }
  }

  /// 设置年份
  String _fnSelectYear(int index) {
    // 将 CupertinoPicker.builder 中的 onSelectedItemChanged: (int index)
    // 中的 index 传递进来，index 是在某一范围内的数，所以有了 2018 2019 2020 等

    // 设置年份的显示范围
    if (index >= widget.minYear - _now.year &&
        index <= widget.maxYear - _now.year) {
      int year = _now.year + index;
      DateTime nowDate = DateTime(year); // 如：2018-01-01 00:00:00.000
      DateTime start =
          widget.start == null ? null : DateTime(widget.start.year);
      DateTime end = widget.end == null ? null : DateTime(widget.end.year);
      String resYear = CusTime.isRange(nowDate, start, end) ? "$year年" : null;
      return resYear;
    }
    return null;
  }

  /// 设置月份
  String _fnSelectMonth(int index) {
    if (index >= 0 && index <= 11) {
      int monthIndex = index + 1;
      DateTime nowDate = DateTime(_now.year + _yearIndex, monthIndex);
      DateTime start = widget.start == null
          ? null
          : DateTime(widget.start.year, widget.start.month);
      DateTime end = widget.end == null
          ? null
          : DateTime(widget.end.year, widget.end.month);
      String resMonth;
      if (_isLunar) {
        resMonth = CusTime.isRange(nowDate, start, end)
            ? widget.padLeft
                ? "${monthIndex.toString().padLeft(2, "0")}月"
                : "${Lunar.fromDate(DateTime(_now.year + _yearIndex, monthIndex)).monthInChinese}月"
            : null;
      } else {
        resMonth = CusTime.isRange(nowDate, start, end)
            ? widget.padLeft
                ? "${monthIndex.toString().padLeft(2, "0")}月"
                : "$monthIndex月"
            : null;
      }
      return resMonth;
    }
    return null;
  }

  /// 设置日份
  String _fnSelectDay(int index) {
    int days = _getDays();
    if (index >= 0 && index < days) {
      int dayIndex = index + 1;
      DateTime _nowDate =
          DateTime(_now.year + _yearIndex, _monthIndex + 1, dayIndex);
      DateTime start = widget.start == null
          ? null
          : DateTime(widget.start.year, widget.start.month, widget.start.day);
      DateTime end = widget.end == null
          ? null
          : DateTime(widget.end.year, widget.end.month, widget.end.day);
      String resDay;
      if (_isLunar) {
        resDay = CusTime.isRange(_nowDate, start, end)
            ? widget.padLeft
                ? "${dayIndex.toString().padLeft(2, "0")}日"
                : "${Lunar.fromDate(DateTime(_now.year + _yearIndex, _monthIndex + 1, dayIndex)).dayInChinese}"
            : null;
      } else {
        resDay = CusTime.isRange(_nowDate, start, end)
            ? widget.padLeft
                ? "${dayIndex.toString().padLeft(2, "0")}日"
                : "$dayIndex日"
            : null;
      }
      return resDay;
    }
    return null;
  }

  /// 设置小时 针对周易日历
  String _fnSelectZhouYi(int index) {
    if (index >= 0 && index < c_old_times.length) {
      return c_old_times[index];
    }
    return null;
  }

  /// 设置小时
  String _fnSelectHour(int index) {
    if (index >= 0 && index < 24) {
      DateTime nowDate = DateTime(
          _now.year + _yearIndex, _monthIndex + 1, _dayIndex + 1, index);
      DateTime start = widget.start == null
          ? null
          : DateTime(widget.start.year, widget.start.month, widget.start.day,
              widget.start.hour);
      DateTime end = widget.end == null
          ? null
          : DateTime(widget.end.year, widget.end.month, widget.end.day,
              widget.end.hour);
      String resHour = CusTime.isRange(nowDate, start, end)
          ? "${index.toString().padLeft(2, "0")}时"
          : null;
      return resHour;
    }
    return null;
  }

  /// 设置分钟
  String _fnSelectMinute(int index) {
    if (index >= 0 && index < 60) {
      DateTime nowDate = DateTime(_now.year + _yearIndex, _monthIndex + 1,
          _dayIndex + 1, _hourIndex, index);
      DateTime start = widget.start == null
          ? null
          : DateTime(widget.start.year, widget.start.month, widget.start.day,
              widget.start.hour, widget.start.minute);
      DateTime end = widget.end == null
          ? null
          : DateTime(widget.end.year, widget.end.month, widget.end.day,
              widget.end.hour, widget.end.minute);
      String resMinute = CusTime.isRange(nowDate, start, end)
          ? widget.padLeft ? "${index.toString().padLeft(2, "0")}分" : "$index分"
          : null;
      return resMinute;
    }
    return null;
  }

  /// 滑动结束时改变日期
  void _changeDate(int _) {
    int day =
        CusTime.dayInMonth(DateTime(_now.year + _yearIndex, _monthIndex + 1));
    DateTime date = DateTime(_now.year + _yearIndex, _monthIndex + 1,
        _dayIndex + 1, _hourIndex, _minuteIndex);

    // 加入定时器，方便取消. 防止触发多次
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: 5), () {
      if (_lastDt != date && _dayIndex < day && !_isScroll) {
        _lastDt = date;
        widget.onChange(date);
      }
    });
  }

  /// 更改年份时的回调
  void _changeYear(int index) {
    if (index == _yearIndex) return;
    _yearIndex = index;
    if (!(widget.pickMode == PickerMode.year ||
        widget.pickMode == PickerMode.hour_minute)) {
      int max = 11;
      int min = 0;
      if (widget.end != null) {
        max = _now.year + _yearIndex == widget.end.year
            ? (widget.end.month - 1)
            : 11;
      }
      if (widget.start != null) {
        min = _now.year + _yearIndex == widget.start.year
            ? (widget.start.month - 1)
            : 0;
      }
      _scrollItem(_monthIndex, min, max, _monthCtrl);
    }
    setState(() {});
  }

  /// 更改月份时的回调
  void _changeMonth(int index) {
    if (index == _monthIndex) return;
    _monthIndex = index;
    if (!(widget.pickMode == PickerMode.year ||
        widget.pickMode == PickerMode.year_month ||
        widget.pickMode == PickerMode.hour_minute)) {
      int max = _getDays() - 1;
      int min = 0;

      if (widget.end != null) {
        max = (_now.year + _yearIndex == widget.end.year &&
                _monthIndex == (widget.end.month - 1))
            ? (widget.end.day - 1)
            : max;
      }
      if (widget.start != null) {
        min = (_now.year + _yearIndex == widget.start.year &&
                _monthIndex == (widget.start.month - 1))
            ? (widget.start.day - 1)
            : min;
      }
      _scrollItem(_dayIndex, min, max, _dayCtrl);
    }
    setState(() {});
  }

  /// 更改日数的回调
  void _changeDay(int index) {
    if (index == _dayIndex) return;
    _dayIndex = index;
    if (widget.pickMode == PickerMode.full) {
      _setHourCtrl();
    }
    setState(() => {});
  }

  /// 更改小时的回调
  void _changeHour(int index) {
    if (index == _hourIndex) return;
    _hourIndex = index;
    if (widget.pickMode == PickerMode.full ||
        widget.pickMode == PickerMode.hour_minute) {
      _setMinuteCtrl();
    }
    setState(() {});
  }

  /// 更改分钟的回调
  void _changeMinute(int index) {
    if (index == _minuteIndex) return;
    setState(() => _minuteIndex = index);
  }

  /// 小时控制器
  void _setHourCtrl() {
    int max = 23;
    int min = 0;

    if (widget.end != null) {
      max = (_now.year + _yearIndex == widget.end.year &&
              _monthIndex == (widget.end.month - 1) &&
              _dayIndex == (widget.end.day - 1))
          ? widget.end.hour
          : max;
    }
    if (widget.start != null) {
      min = (_now.year + _yearIndex == widget.start.year &&
              _monthIndex == (widget.start.month - 1) &&
              _dayIndex == (widget.start.day - 1))
          ? widget.start.hour
          : min;
    }
    _scrollItem(_hourIndex, min, max, _hourCtrl);
  }

  /// 分钟控制器
  void _setMinuteCtrl() {
    int max = 59;
    int min = 0;

    if (widget.end != null) {
      max = (_now.year + _yearIndex == widget.end.year &&
              _monthIndex == (widget.end.month - 1) &&
              _dayIndex == (widget.end.day - 1) &&
              _hourIndex == (widget.end.hour))
          ? widget.end.minute
          : max;
    }
    if (widget.start != null) {
      min = (_now.year + _yearIndex == widget.start.year &&
              _monthIndex == (widget.start.month - 1) &&
              _dayIndex == (widget.start.day - 1) &&
              _hourIndex == (widget.start.hour))
          ? widget.start.minute
          : min;
    }
    _scrollItem(_minuteIndex, min, max, _minuteCtrl);
  }

  /// 每个月的日期不一样，动态改变显示
  int _getDays() {
    DateTime date = DateTime(_now.year + _yearIndex, _monthIndex + 1);
    return CusTime.dayInMonth(date);
  }

  @override
  void dispose() {
    _yearCtrl.dispose();
    _monthCtrl.dispose();
    _dayCtrl.dispose();
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    super.dispose();
  }
}
