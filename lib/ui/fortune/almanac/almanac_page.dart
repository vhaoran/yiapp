import 'package:flutter/material.dart';
import 'package:secret/tools/lunar.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'calendar_view.dart';
import '../../../complex/const/const_calendar.dart';
import 'controller.dart';
import 'custom_style_day_widget.dart';
import 'custom_style_week_barItem.dart';
import '../../../model/calendar/date_model.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/13 10:35
// usage ：黄历页面
// ------------------------------------------------------

class AlmanacPage extends StatefulWidget {
  AlmanacPage({Key key}) : super(key: key);

  @override
  _AlmanacPageState createState() => _AlmanacPageState();
}

class _AlmanacPageState extends State<AlmanacPage> {
  ValueNotifier<String> _date; // 日历顶部的年月 2020年8月
  ValueNotifier<DateModel> _selectDate; // 选择的日期

  CalendarController _controller;
  Lunar _lunar; // 诸如 二〇二〇年六月廿四

  @override
  void initState() {
    _lunar = Lunar(DateTime.now());
    _initData(); // 初始化数据
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: sec_primary,
      body: ScrollConfiguration(
        behavior: CusBehavior(),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10),
            CalendarViewWidget(
              calendarController: _controller,
              weekBarItemWidgetBuilder: () => CustomStyleWeekBarItem(),
              dayWidgetBuilder: (dateModel) => CustomStyleDayWidget(dateModel),
            ),
            _yiOrJi(), // 宜和忌
          ],
        ),
      ),
    );
  }

  /// 初始化数据
  void _initData() {
    DateTime now = DateTime.now();
    _controller = CalendarController(
      selectDateModel: DateModel.fromDateTime(now),
      mode: CalendarConst.month_week,
    );

    // 监听切换月份
    _controller.addMonthChangeListener(
      (year, month) => _date.value = "$year年$month月",
    );

    // 监听点击了其它日期
    _controller.addOnCalendarSelectListener((dateModel) {
      _selectDate.value = dateModel; // 刷新选择的时间
      _lunar = Lunar.fromYmd(
          dateModel.lunar[0], dateModel.lunar[1], dateModel.lunar[2]);
    });

    // 日期变更
    _date = ValueNotifier("${DateTime.now().year}年${DateTime.now().month}月");
    _selectDate = ValueNotifier(DateModel.fromDateTime(DateTime.now()));
  }

  Widget _appBar() {
    return CusAppBar(
      showLeading: false,
      showDefault: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          InkWell(
            child: Icon(Icons.navigate_before, size: Adapt.px(56)),
            onTap: () => _controller.previousPage(), // 上一页
          ),
          ValueListenableBuilder(
            valueListenable: _date,
            builder: (context, value, child) => Text(_date.value),
          ),
          InkWell(
            child: Icon(Icons.navigate_next, size: Adapt.px(56)),
            onTap: () => _controller.nextPage(), // 下一页
          ),
        ],
      ),
      backGroundColor: fou_primary,
    );
  }

  /// 宜、忌
  Widget _yiOrJi() {
    return ValueListenableBuilder(
      valueListenable: _selectDate,
      builder: (context, value, child) {
        // value 如：DateModel{year: 2020, month: 8, day: 13}
        return Column(
          children: <Widget>[
            // 显示农历日期 如 二〇二〇年六月廿四
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF6E5A3E)), // 边色与边宽度
                color: fou_primary,
              ),
              child: Container(
                width: Adapt.screenW(),
                alignment: Alignment.center,
                child: Text(
                  '$_lunar',
                  style: TextStyle(color: t_primary, fontSize: Adapt.px(28)),
                ),
              ),
            ),
            // 显示宜、忌
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      _lunar.dayYi.join(' '),
                      style: TextStyle(color: t_yi),
                    ),
                    leading: Image.asset("assets/images/yi.png"),
                    contentPadding: EdgeInsets.all(0),
                  ),
                  ListTile(
                    title: Text(
                      _lunar.dayJi.join(' '),
                      style: TextStyle(color: t_ji),
                    ),
                    leading: Image.asset("assets/images/ji.png"),
                    contentPadding: EdgeInsets.all(0),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
