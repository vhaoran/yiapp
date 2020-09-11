import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:secret/secret.dart';
import 'package:yiapp/complex/class/cus_date_time.dart';
import 'package:yiapp/complex/class/old_time.dart';
import 'package:yiapp/complex/const/const_calendar.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/cus_time.dart';
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
              pickMode: PickerMode.zhou_yi,
              padLeft: false,
              showLunar: true,
              onConfirm: (date) => setState(() {
                if (date is CusDateTime) {
                  print(">>>选中的年：${date.year}");
                  print(">>>选中的月：${date.month}");
                  print(">>>选中的日：${date.day}");
                  print(">>>选中的时：${date.oldTime.hour}");
                  print(">>>选中的分：${date.oldTime.minute}");
//                  print(">>>${YiTool.yangLi(date)}");
//                  print(">>>${YiTool.yinLi(date)}");
//                var old = date as CusDateTime;
//                print(">>>当前的时辰${old.oldTime.hour}");
//                print(">>>当前的分钟${old.oldTime.minute}");
                }
              }),
            );
          },
        ),
      ],
    );
  }
}
