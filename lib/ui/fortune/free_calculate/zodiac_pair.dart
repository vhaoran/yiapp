import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:yiapp/complex/const/const_calendar.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_num.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/small/cus_datalog.dart';
import 'package:yiapp/complex/widgets/small/cus_description.dart';
import 'package:yiapp/complex/widgets/small/cus_select.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/service/api/api_pair.dart';
import 'package:yiapp/ui/fortune/free_calculate/zodiac/zodiac_res.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/27 10:02
// usage ：生肖配对
// ------------------------------------------------------

class ZodiacPairPage extends StatefulWidget {
  ZodiacPairPage({Key key}) : super(key: key);

  @override
  _ZodiacPairPageState createState() => _ZodiacPairPageState();
}

class _ZodiacPairPageState extends State<ZodiacPairPage> {
  // 男生生肖
  int _maleZodiac = -1;
  String _maleStr = "";
  // 女生生肖
  int _femaleZodiac = -1;
  String _femaleStr = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: '生肖配对'),
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
          iconValue: 0xee26,
          title: "生肖配对",
          subtitle: "，是根据十二属相之间相合、相冲、相克、相害、相生、相刑的规律而产生的一种婚姻配对法，流行于民间。"
              "在命理学中，十二地支具有五行相生、相克及刑冲会合的关系。",
        ),
        SizedBox(height: Adapt.px(110)),
        // 选择生肖
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
          child: Column(
            children: <Widget>[
              CusSelect(
                title: "男生生肖：",
                subtitle: _maleStr.isEmpty ? "请选择生肖" : "属$_maleStr",
                onTap: () => PairDialog(context,
                    sex: male,
                    groupValue: _maleZodiac,
                    l: YiData.zodiacs,
                    fnPair: _zodiacCall),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: Adapt.px(50), bottom: Adapt.px(120)),
                child: CusSelect(
                  title: "女生生肖：",
                  subtitle: _femaleStr.isEmpty ? "请选择生肖" : "属$_femaleStr",
                  onTap: () => PairDialog(context,
                      sex: female,
                      groupValue: _femaleZodiac,
                      l: YiData.zodiacs,
                      fnPair: _zodiacCall),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
          child: CusRaisedBtn(text: "开始测算", onPressed: _doPair),
        ),
      ],
    );
  }

  /// 选择生肖后的回调
  void _zodiacCall(int sex, int select, String name) {
    if (sex == male) {
      _maleZodiac = select;
      _maleStr = name;
    } else {
      _femaleZodiac = select;
      _femaleStr = name;
    }
    setState(() {});
    Navigator.pop(context);
  }

  /// 查询生肖配对
  void _doPair() async {
    if (_maleZodiac == -1 || _femaleZodiac == -1) {
      CusToast.toast(context, text: "未选择所有生肖");
      return;
    }
    try {
      var m = {
        "male_ShengXiao": _maleZodiac,
        "female_ShengXiao": _femaleZodiac
      };
      var res = await ApiFree.shengXiaoMatch(m);
      print(">>>查询生肖配对结果:${res.toJson()}");
      if (res != null) {
        CusRoutes.push(context, ZodiacResPage(res: res)).then((value) {
          _maleStr = _femaleStr = "";
          _maleZodiac = _femaleZodiac = -1;
          setState(() {});
        });
      }
    } catch (e) {
      print("<<<生肖配对配对出现异常：$e");
    }
  }
}
