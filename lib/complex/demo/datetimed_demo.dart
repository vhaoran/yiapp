import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:secret/secret.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/yi_tool.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/picker_mode.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/time_picker.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/1 22:07
// usage ：阴阳历测试
// ------------------------------------------------------

class DateTimeDemo extends StatefulWidget {
  DateTimeDemo({Key key}) : super(key: key);

  @override
  _DateState createState() => _DateState();
}

class _DateState extends State<DateTimeDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "阴阳历测试"),
      body: _bodyCtr(),
      backgroundColor: primary,
    );
  }

  Widget _bodyCtr() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      children: <Widget>[
        CusRaisedBtn(
          backgroundColor: Colors.green,
          text: "测试阴历农历",
          onPressed: () {
            TimePicker(
              context,
              pickMode: PickerMode.date,
              padLeft: false,
              showLunar: true,
              onConfirm: (date) => setState(() {
                int year = date.year;
                int month = date.month;
                int day = date.day;
                print(">>>选择的阳历日期是：$year年$month月$day日");
                print("<<<转换的阴历日期是：${Lunar.fromDate(
                  DateTime(year, month, day),
                )}");
              }),
            );
          },
        ),
      ],
    );
  }
}
