import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:secret/secret.dart';
import 'package:yiapp/complex/const/const_color.dart';
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
      children: <Widget>[
        CusRaisedBtn(
          backgroundColor: Colors.green,
          text: "测试阴历农历",
          onPressed: () {
//            print(">>>${Lunar.fromDate(DateTime(2020, 8, 31))}");
            TimePicker(
              context,
              pickMode: PickerMode.date,
              padLeft: false,
              onConfirm: (date) => setState(() {
                int year = date.first;
                int month = date[1];
                int day = date[2];
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
