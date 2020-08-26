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
import 'package:yiapp/ui/fortune/free_calculate/constellation/con_res.dart';

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
  int _maleSelect = -1;
  String _maleCon = "";
  // 女生星座
  int _femaleSelect = -1;
  String _femaleCon = "";

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
//              CusSelect(
//                title: "男生星座：",
//                subtitle: _maleCon.isEmpty ? "请选择星座" : "$_maleCon座",
//                onTap: () => _selectCon(sex: male),
//              ),
              CusSelect(
                title: "男生星座：",
                subtitle: _maleCon.isEmpty ? "请选择星座" : "$_maleCon座",
                onTap: () => PairDialog(context,
                    l: YiData.cons, fnPair: _testsu, sex: male),
              ),
//              Padding(
//                padding:
//                    EdgeInsets.only(top: Adapt.px(50), bottom: Adapt.px(120)),
//                child: CusSelect(
//                  title: "女生星座：",
//                  subtitle: _femaleCon.isEmpty ? "请选择星座" : "$_femaleCon座",
//                  onTap: () => _selectCon(sex: female),
//                ),
//              ),
              Padding(
                padding:
                    EdgeInsets.only(top: Adapt.px(50), bottom: Adapt.px(120)),
                child: CusSelect(
                    title: "女生星座：",
                    subtitle: _femaleCon.isEmpty ? "请选择星座" : "$_femaleCon座",
                    onTap: () => PairDialog(context,
                        l: YiData.cons, fnPair: _testsu, sex: female)),
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

  void _testsu(int value, int sex, String name) {
    if (sex == male) {
      _maleSelect = value;
      _maleCon = name.substring(0, 2);
      print(">>>当前男生星座是：$_maleCon");
    } else {
      _femaleSelect = value;
      _femaleCon = name.substring(0, 2);
      print(">>>当前女生星座是：$_femaleCon");
    }
    setState(() {});
    Navigator.pop(context);
  }

  /// 查询星座配对
  void _doPair() async {
    if (_maleSelect == -1 || _femaleSelect == -1) {
      CusToast.toast(context, text: "未选择所有星座");
      return;
    }
    try {
      var m = {"male_con": _maleCon, "female_con": _femaleCon};
      var res = await ApiPair.conMatch(m);
      print(">>>res:${res.toJson()}");
      if (res != null) {
        CusRoutes.push(context, ConResPage(res: res)).then((value) {
          _maleCon = _femaleCon = "";
          _maleSelect = _femaleSelect = -1;
          setState(() {});
        });
      }
    } catch (e) {
      print("<<<星座配对出现异常：$e");
    }
  }

  /// 选择星座
  void _selectCon({int sex}) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, state) {
            return Container(
              child: Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 35),
                backgroundColor: Colors.grey[100],
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: List.generate(
                    YiData.cons.length,
                    (i) => _conItem(
                      value: i,
                      name: "${YiData.cons[i]}",
                      sex: sex,
                      onTap: () => state(() {}),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 单个星座组件
  Widget _conItem({int value, sex, String name, VoidCallback onTap}) {
    return InkWell(
      onTap: () => _changeCon(value, sex, onTap),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: Adapt.px(20)),
              Text(name, style: TextStyle(fontSize: Adapt.px(30))),
              Spacer(),
              Radio(
                value: value,
                groupValue: sex == male ? _maleSelect : _femaleSelect,
                onChanged: (value) => _changeCon(value, sex, onTap),
              ),
            ],
          ),
          Divider(thickness: 0.4, height: 0, color: Colors.grey),
        ],
      ),
    );
  }

  /// 更改星座
  void _changeCon(int value, sex, VoidCallback onTap) {
    onTap(); // 设置 state 刷新 dialog 数据
    if (sex == male) {
      _maleSelect = value;
      _maleCon = YiData.cons.elementAt(_maleSelect).substring(0, 2);
      print(">>>当前男生星座是：$_maleCon");
    } else {
      _femaleSelect = value;
      _femaleCon = YiData.cons.elementAt(_femaleSelect).substring(0, 2);
      print(">>>当前女生星座是：$_femaleCon");
    }
    setState(() {});
    Navigator.pop(context);
  }
}
