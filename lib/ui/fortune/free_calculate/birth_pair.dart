import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:secret/tools/lunar.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/time_picker.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/picker_mode.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/small/cus_description.dart';
import 'package:yiapp/complex/widgets/small/cus_select.dart';
import 'package:yiapp/service/api/api_free.dart';
import 'package:yiapp/ui/fortune/free_calculate/birth_res.dart';

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
  int _male_month = 0; // 男生-月
  int _male_day = 0; // 男生-日
  int _female_month = 0; // 女生-月
  int _female_day = 0; // 女生-日
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
                onTap: () => TimePicker(
                  context,
                  pickMode: PickerMode.month_day,
                  onConfirm: (date) => setState(() {
                    _male_month = date.month;
                    _male_day = date.day;
                    _maleStr = "$_male_month月$_male_day日";
                  }),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: Adapt.px(50), bottom: Adapt.px(120)),
                child: CusSelect(
                  title: "女生生日：",
                  subtitle: _femaleStr.isEmpty ? "请选择生日" : "$_femaleStr",
                  onTap: () => TimePicker(
                    context,
                    pickMode: PickerMode.month_day,
                    onConfirm: (date) => setState(() {
                      _female_month = date.month;
                      _female_day = date.day;
                      _femaleStr = "$_female_month月$_female_day日";
                    }),
                  ),
                ),
              )
            ],
          ),
        ),
        CusRaisedBtn(text: "开始测算", onPressed: __doPair),
      ],
    );
  }

  void __doPair() async {
    if ((_male_month == 0) || _female_month == 0) {
      CusToast.toast(context, text: "未选择所有生日");
      return;
    }
    var m = {
      "male_month": _male_month,
      "male_day": _male_day,
      "female_month": _female_month,
      "female_day": _female_day,
    };
    try {
      var res = await ApiFree.shengRiMatch(m);
      print(">>>生日配对结果：${res.toJson()}");
      if (res != null) {
        CusRoutes.push(context, BirthResPage(res: res)).then((value) {
          _male_month = _male_day = _female_month = _female_day = 0;
          _maleStr = _femaleStr = "";
          setState(() {});
        });
      }
    } catch (e) {
      print("<<<生日配对出现异常：$e");
    }
  }
}
