import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:yiapp/complex/const/const_calendar.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/const/const_list.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/small/fn_dialog.dart';
import 'package:yiapp/complex/widgets/small/cus_description.dart';
import 'package:yiapp/complex/widgets/small/cus_select.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/service/api/api_free.dart';
import 'con_res.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/25 10:03
// usage ：星座配对
// ------------------------------------------------------

class ConPairPage extends StatefulWidget {
  ConPairPage({Key key}) : super(key: key);

  @override
  _ConPairPageState createState() => _ConPairPageState();
}

class _ConPairPageState extends State<ConPairPage> {
  // 男生星座
  int _maleCon = -1;
  String _maleStr = "";
  // 女生星座
  int _femaleCon = -1;
  String _femaleStr = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: '星座配对'),
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
          iconValue: 0xe69e,
          title: "星座配对",
          subtitle: "，根据十二星座配对，测试你的爱情，"
              "来分析你和另一半在基本性格上的适配度，谨供大家相处时的参考",
        ),
        SizedBox(height: Adapt.px(120)),
        // 选择星座
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
          child: Column(
            children: <Widget>[
              CusSelect(
                title: "男生星座：",
                subtitle: _maleStr.isEmpty ? "请选择星座" : "$_maleStr座",
                onTap: () => FnDialog(context,
                    sex: male,
                    groupValue: _maleCon,
                    l: c_constellation,
                    fnPair: _conCall),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: Adapt.px(50), bottom: Adapt.px(120)),
                child: CusSelect(
                  title: "女生星座：",
                  subtitle: _femaleStr.isEmpty ? "请选择星座" : "$_femaleStr座",
                  onTap: () => FnDialog(context,
                      sex: female,
                      groupValue: _femaleCon,
                      l: c_constellation,
                      fnPair: _conCall),
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

  /// 选择星座后的回调
  void _conCall(int sex, int select, String name) {
    if (sex == male) {
      _maleCon = select;
      _maleStr = name.substring(0, 2);
    } else {
      _femaleCon = select;
      _femaleStr = name.substring(0, 2);
    }
    setState(() {});
    Navigator.pop(context);
  }

  /// 查询星座配对
  void _doPair() async {
    if (_maleCon == -1 || _femaleCon == -1) {
      CusToast.toast(context, text: "未选择所有星座");
      return;
    }
    print(">>>nan:$_maleCon nv $_femaleCon");
    try {
      var m = {"male_con": _maleCon, "female_con": _femaleCon};
      var res = await ApiFree.conMatch(m);
      print(">>>查询星座配对结果:${res.toJson()}");
      if (res != null) {
        CusRoutes.push(context, ConResPage(res: res)).then((value) {
          _maleStr = _femaleStr = "";
          _maleCon = _femaleCon = -1;
          setState(() {});
        });
      }
    } catch (e) {
      print("<<<星座配对出现异常：$e");
    }
  }
}
