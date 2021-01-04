import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_time_picker/time_picker.dart';
import 'package:yiapp/widget/cus_time_picker/picker_mode.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/ui/luck/widget/pair_description.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/ui/luck/widget/pair_select.dart';
import 'package:yiapp/service/api/api_free.dart';
import 'package:yiapp/ui/luck/free_calculate/birth_res.dart';

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
  static const IconData _iconData = IconData(0xe728, fontFamily: ali_font);

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
      padding: EdgeInsets.only(left: S.w(25), right: S.w(25), top: S.h(15)),
      children: <Widget>[
        // 顶部描述信息
        PairDescription(
          iconData: _iconData,
          name: "生日配对",
          desc: "是用你和他(她)的生日测测情愫，看看你们之间的情缘究竟如何，"
              "是完美情人、最佳拍档、还是普通关系，或者一对欢喜冤家？",
        ),
        SizedBox(height: S.h(40)),
        // 选择生日
        PairSelect(
          name: "男生生日：",
          value: _maleStr.isEmpty ? "请选择生日" : "$_maleStr",
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
        SizedBox(height: S.h(20)),
        PairSelect(
          name: "女生生日：",
          value: _femaleStr.isEmpty ? "请选择生日" : "$_femaleStr",
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
        SizedBox(height: S.h(60)),
        CusRaisedButton(
          child: Text("开始测算", style: TextStyle(fontSize: S.sp(15))),
          onPressed: _doPair,
        ),
      ],
    );
  }

  void _doPair() async {
    if ((_male_month == 0) || _female_month == 0) {
      CusToast.toast(context, text: "未选择所有生日");
      return;
    }
    SpinKit.threeBounce(context);
    var m = {
      "male_month": _male_month,
      "male_day": _male_day,
      "female_month": _female_month,
      "female_day": _female_day,
    };
    try {
      var res = await ApiFree.shengRiMatch(m);
      Log.info("生日配对结果：${res.toJson()}");
      if (res != null) {
        Navigator.pop(context);
        CusRoute.push(context, BirthResPage(res: res)).then((value) {
          _male_month = _male_day = _female_month = _female_day = 0;
          _maleStr = _femaleStr = "";
          setState(() {});
        });
      }
    } catch (e) {
      Log.error("生日配对出现异常：$e");
    }
  }
}
