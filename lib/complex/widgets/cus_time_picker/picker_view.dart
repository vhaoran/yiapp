import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/tools/cus_time.dart';
import 'dart:async';
import 'date.dart';
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
  final double factor;
  final double offset;
  final double squeeze;
  final bool showTitle;
  final Color backgroundColor;
  final Color color;
  final PickerMode pickMode;
  final DateTime current;
  final DateTime start;
  final DateTime end;
  final FnDateChanged onChange;
  final FnDateChanged onConfirm;
  final FnCancel onCancel;

  PickerView({
    this.itemCount,
    this.itemHeight,
    this.factor,
    this.offset,
    this.squeeze,
    this.showTitle,
    this.backgroundColor,
    this.color,
    this.pickMode,
    DateTime current,
    DateTime start,
    DateTime end,
    this.onChange,
    this.onConfirm,
    this.onCancel,
  })  : this.current =
            current == null ? DateTime.now() : CusDate.parse(current),
        this.start = start == null ? null : CusDate.parse(start),
        this.end = end != null ? null : CusDate.parse(end);

  /// 整个选择器高度
  double get _pickerHeight => itemHeight * (itemCount + 1);

  /// 隐藏年份
  bool get _hideYear => pickMode == PickerMode.hour_minute;

  /// 隐藏月份
  bool get _hideMonth =>
      pickMode == PickerMode.year || pickMode == PickerMode.hour_minute;

  /// 隐藏天
  bool get hideDay =>
      pickMode == PickerMode.year ||
      pickMode == PickerMode.year_month ||
      pickMode == PickerMode.hour_minute;

  /// 隐藏
  bool get hideTime =>
      pickMode == PickerMode.year ||
      pickMode == PickerMode.year_month ||
      pickMode == PickerMode.date;

  @override
  _PickerViewState createState() => _PickerViewState();
}

class _PickerViewState extends State<PickerView> {
  // 2020年的_yearIndex是0，2016年的_yearIndex是4，其它字段同理
  int _yearIndex, _monthIndex, _dayIndex, _hourIndex, _minuteIndex = 0;
  DateTime _last; // 上一次回调的时间
  bool _isScroll = false; // 如果是手动滚动，不要触发onChange
  Timer _timer; // 定时器
  final DateTime _now = DateTime.now();

  FixedExtentScrollController _yearControl,
      _monthControl,
      _dayControl,
      _hourControl,
      _minuteControl;

  int _getDays() {
    DateTime date = DateTime(_now.year + _yearIndex, _monthIndex + 1);
    return CusTime.daysInMonth(date);
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  /// 监听滚动偏移
  void _init() {
    _yearIndex = widget.current.year - _now.year;
    _monthIndex = widget.current.month - 1;
    _dayIndex = widget.current.day - 1;
    _hourIndex = widget.current.hour;
    _minuteIndex = widget.current.minute;

    _yearControl = FixedExtentScrollController(initialItem: _yearIndex);
    _monthControl = FixedExtentScrollController(initialItem: _monthIndex);
    _dayControl = FixedExtentScrollController(initialItem: _dayIndex);
    _hourControl = FixedExtentScrollController(initialItem: _hourIndex);
    _minuteControl = FixedExtentScrollController(initialItem: _minuteIndex);
  }

  String _stringIndexByYear(int index) {
    // 将 CupertinoPicker.builder 中的 onSelectedItemChanged: (int index)
    // 中的 index 传递进来，index 是在某一范围内的数，所以有了 2018 2019 2020 等
    int _year = _now.year + index;
    // TODO 这里以当前年份 -50 即最小年份 2020-50，
//    print(">>>年份这里的index是：$index");
    print(">>>这里的_year:$_year");
    return "${_year}";
    if (index >= -50 && index <= 0) {
      int _year = _now.year + index;
      return _year.toString();
//      print(">>>_year +-+-+--+-+-:$_year");
//      DateTime _nowDate = DateTime(_year);
//      DateTime start =
//          widget.start == null ? null : DateTime(widget.start.year);
//      DateTime end = widget.end == null ? null : DateTime(widget.end.year);
//
//      print(">>> isinrange:${CusDate.isInRange(_nowDate, start, end)}");
//      String st = CusDate.isInRange(_nowDate, start, end)
//          ? _year.toString() + '年'
//          : null;
//      print(">>>返回的年份：$st");
//      print(">>>返回的_yearIndex：$_yearIndex");
//      return CusDate.isInRange(_nowDate, start, end)
//          ? _year.toString() + '年'
//          : null;
    }
    return null;
  }

  String _stringIndexByMonth(int index) {
    if (index >= 0 && index <= 11) {
      int _monthIndex = index + 1;
      DateTime _nowDate = DateTime(_now.year + _yearIndex, _monthIndex);
      DateTime start = widget.start == null
          ? null
          : DateTime(widget.start.year, widget.start.month);
      DateTime end = widget.end == null
          ? null
          : DateTime(widget.end.year, widget.end.month);

      return CusDate.isInRange(_nowDate, start, end)
          ? (index + 1).toString() + '月'
          : null;
    }
    return null;
  }

  _setScroll(fn) {
    _isScroll = true;
    fn();
    _isScroll = false;
  }

  _scrollItem(
      int index, FixedExtentScrollController control, int min, int max) {
    if (index > max) {
      _setScroll(() {
        control.jumpToItem(max);
      });
    } else if (index < min) {
      _setScroll(() {
        control.jumpToItem(min);
      });
    } else {
      _setScroll(() {
        control.jumpToItem(index - 1);
        control.jumpToItem(index);
      });
    }
  }

  changeDay(index) {
    if (index == _dayIndex) return;

    setState(() {
      _dayIndex = index;
    });

    if (widget.pickMode == PickerMode.full) {
      setHourControl();
    }
  }

  setHourControl() {
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

    _scrollItem(_hourIndex, _hourControl, min, max);
  }

  String stringIndexByDay(int index) {
    int days = _getDays();

    if (index >= 0 && index < days) {
      int _index = index + 1;
      DateTime _nowDate =
          DateTime(_now.year + _yearIndex, _monthIndex + 1, _index);
      DateTime start = widget.start == null
          ? null
          : DateTime(widget.start.year, widget.start.month, widget.start.day);
      DateTime end = widget.end == null
          ? null
          : DateTime(widget.end.year, widget.end.month, widget.end.day);

      return CusDate.isInRange(_nowDate, start, end)
          ? _index.toString() + '日'
          : null;
    }
    return null;
  }

  changeHour(index) {
    if (index == _hourIndex) return;

    setState(() {
      _hourIndex = index;
    });
    if (widget.pickMode == PickerMode.full ||
        widget.pickMode == PickerMode.hour_minute) {
      setMinuteControl();
    }
  }

  setMinuteControl() {
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

    _scrollItem(_minuteIndex, _minuteControl, min, max);
  }

  String _stringIndexByHour(int index) {
    if (index >= 0 && index < 24) {
      DateTime _nowDate = DateTime(
          _now.year + _yearIndex, _monthIndex + 1, _dayIndex + 1, index);
      DateTime start = widget.start == null
          ? null
          : DateTime(widget.start.year, widget.start.month, widget.start.day,
              widget.start.hour);
      DateTime end = widget.end == null
          ? null
          : DateTime(widget.end.year, widget.end.month, widget.end.day,
              widget.end.hour);

      return CusDate.isInRange(_nowDate, start, end)
          ? index.toString().padLeft(2, '0') + '时'
          : null;
    }
    return null;
  }

  _changeMinute(index) {
    if (index == _minuteIndex) return;
    setState(() => _minuteIndex = index);
  }

  String stringIndexByMinute(int index) {
    if (index >= 0 && index < 60) {
      DateTime _nowDate = DateTime(_now.year + _yearIndex, _monthIndex + 1,
          _dayIndex + 1, _hourIndex, index);
      DateTime start = widget.start == null
          ? null
          : DateTime(widget.start.year, widget.start.month, widget.start.day,
              widget.start.hour, widget.start.minute);
      DateTime end = widget.end == null
          ? null
          : DateTime(widget.end.year, widget.end.month, widget.end.day,
              widget.end.hour, widget.end.minute);

      return CusDate.isInRange(_nowDate, start, end)
          ? index.toString().padLeft(2, '0') + '分'
          : null;
    }
    return null;
  }

  _changeDate(int _) {
    int days = CusTime.daysInMonth(
        new DateTime(_now.year + _yearIndex, _monthIndex + 1));
    DateTime date = new DateTime(_now.year + _yearIndex, _monthIndex + 1,
        _dayIndex + 1, _hourIndex, _minuteIndex);

    /// 加入定时器，方便取消
    /// 防止触发多次
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: 5), () {
      if (_last != date && _dayIndex < days && !_isScroll) {
        _last = date;
        widget.onChange(date);
      }
    });
  }

  /// 点击确认按钮要执行的
  _onFirm() {
    DateTime date = DateTime(_now.year + _yearIndex, _monthIndex + 1,
        _dayIndex + 1, _hourIndex, _minuteIndex);
    widget.onConfirm(date);
    Navigator.of(context).pop();
  }

  Widget _renderColumnView(
      {ValueKey key,
      StringAtIndexCallBack stringAtIndexCB,
      ScrollController scrollControl,
      ValueChanged<int> onScrolling,
      ValueChanged<int> onScrollEnd}) {
    return Expanded(
      // flex: layoutProportion,
      child: Container(
        padding: EdgeInsets.all(6),
        height: widget._pickerHeight, // theme.containerHeight
        // decoration: BoxDecoration(color: Colors.white),
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification.depth == 0 &&
                onScrollEnd != null &&
                notification is ScrollEndNotification &&
                notification.metrics is FixedExtentMetrics) {
              final FixedExtentMetrics metrics = notification.metrics;
              final int currentItemIndex = metrics.itemIndex;
              onScrollEnd(currentItemIndex);
            }
            return false;
          },
          child: CupertinoPicker.builder(
            key: key,
            backgroundColor: widget.backgroundColor ?? Colors.white,
            scrollController: scrollControl,
            itemExtent: widget.itemHeight, // theme.itemHeight,
            onSelectedItemChanged: (int index) {
              onScrolling(index);
            },
            useMagnifier: true,
            magnification: widget.factor,
            squeeze: widget.squeeze,
            offAxisFraction: widget.offset,
            itemBuilder: (BuildContext context, int index) {
              print(">>>这里的index:是++++++++++$index");
              final content = stringAtIndexCB(index);
              if (content == null) return null;
              return Container(
                height: widget.itemHeight, // theme.itemHeight,
                alignment: Alignment.center,
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 18).copyWith(
                    color: widget.color ?? Color(0xFF000046),
                  ), // theme.itemStyle,
                  textAlign: TextAlign.start,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// 取消或者确定按钮
  Widget _renderHeader() {
    return Row(
      children: <Widget>[
        FlatButton(
          textColor: Color(0xFF999999),
          child: Text('取消'),
          onPressed: () {
            widget.onCancel();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          textColor: Theme.of(context).primaryColor,
          child: Text('确认'),
          onPressed: () => _onFirm(),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
  }

  /// 选择时间区域
  Widget _renderSheet(BuildContext context) {
    return Row(
      children: <Widget>[
        if (!widget._hideYear)
          _renderColumnView(
            scrollControl: _yearControl,
            onScrollEnd: _changeDate,
            onScrolling: _changeYear,
            stringAtIndexCB: _stringIndexByYear,
          ),
//        if (!widget._hideMonth)
//          _renderColumnView(
//            scrollController: _monthControl,
//            selectedChangedWhenScrollEnd: _changeDate,
//            selectedChangedWhenScrolling: _changeMonth,
//            stringAtIndexCB: _stringIndexByMonth,
//          ),
//        if (!widget.hideDay)
//          _renderColumnView(
//            scrollController: _dayControl,
//            selectedChangedWhenScrollEnd: _changeDate,
//            selectedChangedWhenScrolling: changeDay,
//            stringAtIndexCB: stringIndexByDay,
//          ),
//        if (!widget.hideTime)
//          _renderColumnView(
//            scrollController: _hourControl,
//            selectedChangedWhenScrollEnd: _changeDate,
//            selectedChangedWhenScrolling: changeHour,
//            stringAtIndexCB: _stringIndexByHour,
//          ),
//        if (!widget.hideTime)
//          _renderColumnView(
//            scrollController: _minuteControl,
//            selectedChangedWhenScrollEnd: _changeDate,
//            selectedChangedWhenScrolling: _changeMinute,
//            stringAtIndexCB: stringIndexByMinute,
//          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      height: widget._pickerHeight + (widget.showTitle ? 48 : 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (widget.showTitle) _renderHeader(),
          _renderSheet(context),
        ],
      ),
    );
  }

  /// 更改年份时的回调
  _changeYear(index) {
    if (index == _yearIndex) return;
    _yearIndex = index;
    setState(() {});
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

      _scrollItem(_monthIndex, _monthControl, min, max);
    }
  }

  /// 更改月份时的回调
  _changeMonth(index) {
    if (index == _monthIndex) return;
    _monthIndex = index;
    setState(() {});
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

      _scrollItem(_dayIndex, _dayControl, min, max);
    }
  }

  @override
  void dispose() {
    _yearControl.dispose();
    _monthControl.dispose();
    _dayControl.dispose();
    _hourControl.dispose();
    _minuteControl.dispose();
    super.dispose();
  }
}
