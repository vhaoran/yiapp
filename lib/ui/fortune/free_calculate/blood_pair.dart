import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/const/const_list.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/tools/cus_tool.dart';
import 'package:yiapp/complex/widgets/small/fn_dialog.dart';
import 'package:yiapp/complex/widgets/small/cus_description.dart';
import 'package:yiapp/complex/widgets/small/cus_select.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/service/api/api_free.dart';
import 'blood_res.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/27 15:59
// usage ：血型配对
// ------------------------------------------------------

class BloodPairPage extends StatefulWidget {
  BloodPairPage({Key key}) : super(key: key);

  @override
  _BloodPairPageState createState() => _BloodPairPageState();
}

class _BloodPairPageState extends State<BloodPairPage> {
  // 男生血型
  int _maleBlood = -1;
  String _maleStr = "";
  // 女生血型
  int _femaleBlood = -1;
  String _femaleStr = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: '血型配对'),
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
          iconValue: 0xe656,
          title: "血型配对",
          subtitle: "，指根据自己的血型和恋人的血型来大致分析下双方的性格特征，"
              "并给出两人的速配指数，以及性格方面的相关建议和提醒。",
        ),
        SizedBox(height: Adapt.px(110)),
        // 选择血型
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
          child: Column(
            children: <Widget>[
              CusSelect(
                title: "男生血型：",
                subtitle: _maleStr.isEmpty ? "请选择血型" : "$_maleStr型",
                onTap: () => FnDialog(context,
                    sex: male,
                    groupValue: _maleBlood,
                    l: c_bloods,
                    fnPair: _bloodCall),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: Adapt.px(50), bottom: Adapt.px(120)),
                child: CusSelect(
                  title: "女生血型：",
                  subtitle: _femaleStr.isEmpty ? "请选择血型" : "$_femaleStr型",
                  onTap: () => FnDialog(context,
                      sex: female,
                      groupValue: _femaleBlood,
                      l: c_bloods,
                      fnPair: _bloodCall),
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

  /// 选择血型后的回调
  void _bloodCall(int sex, int select, String name) {
    if (sex == male) {
      _maleBlood = select;
      _maleStr = CusTool.AZ(name);
    } else {
      _femaleBlood = select;
      _femaleStr = CusTool.AZ(name);
    }
    setState(() {});
    Navigator.pop(context);
  }

  /// 查询血型配对
  void _doPair() async {
    if (_maleBlood == -1 || _femaleBlood == -1) {
      CusToast.toast(context, text: "未选择所有血型");
      return;
    }
    try {
      var m = {"male_blood": _maleStr, "female_blood": _femaleStr};
      var res = await ApiFree.bloodMatch(m);
      Debug.log("查询血型配对结果:${res.toJson()}");
      if (res != null) {
        CusRoutes.push(context, BloodResPage(res: res)).then((value) {
          _maleStr = _femaleStr = "";
          _maleBlood = _femaleBlood = -1;
          setState(() {});
        });
      }
    } catch (e) {
      Debug.logError("血型配对出现异常：$e");
    }
  }
}
