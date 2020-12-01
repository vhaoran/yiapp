import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';

import 'base_day_view.dart';
import '../../../model/calendar/date_model.dart';

class CustomStyleDayWidget extends BaseCustomDayWidget {
  CustomStyleDayWidget(DateModel dateModel) : super(dateModel);

  @override
  void drawNormal(DateModel dateModel, Canvas canvas, Size size) {
    if (!dateModel.isCurrentMonth) return;
    bool isWeekend = dateModel.isWeekend;
    bool isInRange = dateModel.isInRange;

    //顶部的文字
    TextPainter dayTextPainter = new TextPainter()
      ..text = TextSpan(
        text: dateModel.day.toString(),
        style: new TextStyle(
          color: !isInRange ? Colors.grey : isWeekend ? t_red : t_primary,
          fontSize: 16,
        ),
      )
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    dayTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    dayTextPainter.paint(canvas, Offset(0, 10));

    //下面的文字
    TextPainter lunarTextPainter = new TextPainter()
      ..text = new TextSpan(
        text: dateModel.lunarString,
        style: new TextStyle(
          color:
              !isInRange ? Colors.grey : isWeekend ? t_red : Color(0xFFAFAFAF),
          fontSize: 12,
        ),
      )
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    lunarTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    lunarTextPainter.paint(canvas, Offset(0, size.height / 2));
  }

  pr(String name, dynamic obj) {
    print('$name------$obj');
  }

  @override
  void drawSelected(DateModel dateModel, Canvas canvas, Size size) {
    if (!dateModel.isCurrentMonth) {
      return;
    }
    // print(SolarUtil.getWeeksOfMonth(2020,7,1));
    // print(LunarUtils.YI_JI[0]);
    // print(LunarUtils.hex(9));
    // Lunar d = Lunar(DateTime.now());
    // pr('sad', d);
    // pr('公历', '${d.getSolar()}');
    // pr('农历',
    //     '${d.getYearInChinese()}-${d.getMonthInChinese()}-${d.getDayInChinese()}');
    // pr('吉神宜趋', d.getDayJiShen());
    // pr('凶煞宜忌', d.getDayXiongSha());

    // pr('宜', d.getDayYi());
    // pr('忌', d.getDayJi());
    // pr('节日', d.getFestivals());
    // pr('非正式节日', d.getOtherFestivals());
    // pr('干支纪年', d.getYearInGanZhi());
    // pr('阴历年的天干', d.getYearGan());
    // pr('阴历年的地支', d.getYearZhi());
    // pr('干支纪月', d.getMonthInGanZhi());
    // pr('阴历月的天干', d.getMonthGan());
    // pr('阴历月的天干', d.getMonthZhi());
    // pr('阴历月的天干', d.getDayGan());
    // pr('阴历月的天干', d.getDayZhi());
    // pr('阴历月的天干', d.getYearInGanZhiByLiChun());
    // pr('阴历月的天干', d.getYearGanByLiChun());
    // pr('阴历月的天干', d.getYearZhiByLiChun());
    // pr('阴历月的天干', d.getYearInGanZhiExact());
    // pr('阴历月的天干', d.getYearGanExact());
    // pr('阴历月的天干', d.getYearZhiExact());
    // pr('阴历月的天�����������', d.getMonthInGanZhiExact());
    // pr('阴历月的天干', d.getMonthGanExact());
    // pr('阴历月的天干', d.getDayInGanZhiExact());
    // pr('阴历月的天干', d.getDayGanExact());
    // pr('阴历月的天干', d.getDayZhiExact());
    // pr('阴历月的天干', d.getMonthGanExact());
    //绘制背景
    var width = size.width;
    var height = size.height;
    var bw = size.width - 5; // 背景宽度
    var bh = size.height - 5; // 背景高度
    double elevation = 10;
    const PI = 3.1415926;
    const ANGLE = PI / 180 * (65); //调整旋转度数
    var center = Offset(width / 2, height / 2);

    var c1 = Offset(
      center.dx - (bw / 4 * cos(ANGLE)),
      center.dy - (bh / 4 * sin(ANGLE)),
    );
    var c2 = Offset(
      center.dx - (bw / 4 * cos(ANGLE + PI)),
      center.dy - (bh / 4 * sin(ANGLE + PI)),
    );

    var c1c = Paint()
      ..color = Color(0xFF473D44)
      ..style = PaintingStyle.fill;
    var c2c = Paint()
      ..color = Color(0xFFC5B8C2)
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..addArc(
        Rect.fromCenter(
          center: center,
          width: bw,
          height: bh,
        ).translate(0, 0 - elevation),
        0,
        2 * PI,
      );
    canvas.drawShadow(path, Color(0xFFB8818F), elevation, true);

    // 阴大半圆
    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        width: bw,
        height: bh,
      ),
      ANGLE, // 起始角度
      PI, // 扇面
      true, // 居中
      c1c,
    );
    // 阳大半圆
    canvas.drawArc(
      Rect.fromCenter(
        center: center,
        width: bw,
        height: bh,
      ),
      PI + ANGLE, // 起始角度
      PI, // 扇面
      true, // 居中
      c2c,
    );

    // 阳小半圆
    canvas.drawArc(
      Rect.fromCenter(
        center: c1,
        width: bw / 2,
        height: bh / 2,
      ),
      0, // 起始角度
      2 * PI, // 扇���
      true, // 居中
      c2c,
    );

    // 阴小半圆
    canvas.drawArc(
      Rect.fromCenter(
        center: c2,
        width: bw / 2,
        height: bh / 2,
      ),
      0, // 起始角度
      2 * PI, // 扇面
      true, // 居中
      c1c,
    );

    //顶部的文字
    TextPainter dayTextPainter = new TextPainter()
      ..text = TextSpan(
        text: dateModel.day.toString(),
        style: new TextStyle(color: Colors.black, fontSize: 20),
      )
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    dayTextPainter.layout(minWidth: width, maxWidth: width);
    dayTextPainter.paint(
      canvas,
      Offset(0, height / 4 - 20 / 2),
    );

    //下面的文字
    TextPainter lunarTextPainter = new TextPainter()
      ..text = new TextSpan(
        text: dateModel.lunarString,
        style: new TextStyle(color: Colors.white, fontSize: 12),
      )
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    lunarTextPainter.layout(minWidth: width, maxWidth: width);
    lunarTextPainter.paint(
      canvas,
      Offset(0, (height - height / 4) - height / 6),
    );
  }
}
