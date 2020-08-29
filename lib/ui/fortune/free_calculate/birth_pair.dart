import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_time.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/time_picker.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/picker_mode.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/small/cus_description.dart';
import 'package:yiapp/complex/widgets/small/cus_select.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/28 10:31
// usage ：生日配对页面
// ------------------------------------------------------

class BirthPairPage extends StatefulWidget {
  BirthPairPage({Key key}) : super(key: key);

  @override
  _BirthPairPageState createState() => _BirthPairPageState();
}

class _BirthPairPageState extends State<BirthPairPage> {
  String _male_month = ""; // 男生-月
  String _male_day = ""; // 男生-日
  String _female_month = ""; // 女生-月
  String _female_day = ""; // 女生-日
  String _maleStr = ""; // 显示男生生日
  String _femaleStr = ""; // 显示女生生日

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: '生日配对'),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(
          left: Adapt.px(50), right: Adapt.px(50), top: Adapt.px(30)),
      children: <Widget>[
        // 顶部描述信息
        CusDescription(
          iconValue: 0xe728,
          title: "生日配对",
          subtitle: "是用你和他(她)的生日测测情愫，看看你们之间的情缘究竟如何，"
              "是完美情人、最佳拍档、还是普通关系，或者一对欢喜冤家？",
        ),
        SizedBox(height: Adapt.px(110)),
        // 选择生日
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
          child: Column(
            children: <Widget>[
              CusSelect(
                title: "男生生日：",
                subtitle: _maleStr.isEmpty ? "请选择生日" : "$_maleStr",
                onTap: _birthday,
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: Adapt.px(50), bottom: Adapt.px(120)),
                child: CusSelect(
                  title: "女生生日：",
                  subtitle: _femaleStr.isEmpty ? "请选择生日" : "$_femaleStr",
                  onTap: () {},
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  /// 选择生日
  void _birthday() {
    TimePicker(
      context,
      pickMode: PickerMode.full,
      onConfirm: _date,
      resIsString: true,
      padLeft: false,
      start: DateTime(2015, 8, 15),
    );
  }

  void _date(dynamic date) {
    print(">>>返回的时间是：${date}");
  }
}
