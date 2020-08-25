import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_calendar.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/cus_description.dart';
import 'package:yiapp/complex/widgets/cus_select.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';

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
  int _select = -1; // 选择的星座
  String _maleCon = ""; // 男生星座

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
        // 描述信息
        CusDescription(
          iconValue: 0xe69e,
          title: "星座配对",
          subtitle: "，根据十二星座配对，测试你的爱情，"
              "来分析你和另一半在基本性格上的适配度，谨供大家相处时的参考",
        ),
        SizedBox(height: Adapt.px(120)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
          child: CusSelect(
            title: "男生星座：",
            subtitle: _maleCon.isEmpty ? "请选择星座" : "$_maleCon座",
            onTap: _selectCon,
          ),
        )
      ],
    );
  }

  /// 选择星座
  void _selectCon() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
              child: Dialog(
                backgroundColor: Colors.grey[100],
                child: ListView(
                  children: <Widget>[
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: List.generate(YiData.cons.length, (i) {
                        String e = YiData.cons[i];
                        return _conItem(
                          value: i,
                          name: "$e座",
                          onTap: () => state(() {}),
                        );
                      }),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  /// 单个星座组件
  Widget _conItem({int value, String name, VoidCallback onTap}) {
    return InkWell(
      onTap: () => _changeCon(onTap, value),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: Adapt.px(20)),
              Text(name, style: TextStyle(fontSize: Adapt.px(30))),
              Spacer(),
              Radio(
                value: value,
                groupValue: _select,
                onChanged: (value) => _changeCon(onTap, value),
              ),
            ],
          ),
          Divider(thickness: 0.4, height: 0, color: Colors.grey),
        ],
      ),
    );
  }

  /// 更改星座
  void _changeCon(VoidCallback onTap, int value) {
    onTap(); // 设置 state 刷新 dialog 数据
    _select = value;
    _maleCon = YiData.cons.elementAt(_select);
    setState(() {});
    Navigator.pop(context);
  }
}
