import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_list.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/fn/fn_dialog.dart';
import 'package:yiapp/ui/luck/widget/pair_description.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/ui/luck/widget/pair_select.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/service/api/api_free.dart';
import 'package:yiapp/widget/cus_button.dart';
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

  static const IconData _iconData = IconData(0xe69e, fontFamily: ali_font);

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
      padding: EdgeInsets.only(left: S.w(25), right: S.w(25), top: S.h(15)),
      children: <Widget>[
        // 顶部描述信息
        PairDescription(
          name: "星座配对",
          desc: "，根据十二星座配对，测试你的爱情，"
              "来分析你和另一半在基本性格上的适配度，谨供大家相处时的参考",
          iconData: _iconData,
        ),
        SizedBox(height: S.h(40)),
        // 选择星座
        PairSelect(
          name: "男生星座：",
          value: _maleStr.isEmpty ? "请选择星座" : "$_maleStr座",
          onTap: () => FnDialog(context,
              sex: male,
              groupValue: _maleCon,
              l: c_constellation,
              fnPair: _conCall),
        ),
        SizedBox(height: S.h(20)),
        PairSelect(
          name: "女生星座：",
          value: _femaleStr.isEmpty ? "请选择星座" : "$_femaleStr座",
          onTap: () => FnDialog(context,
              sex: female,
              groupValue: _femaleCon,
              l: c_constellation,
              fnPair: _conCall),
        ),
        SizedBox(height: S.h(60)),
        CusRaisedButton(
          child: Text("开始测算", style: TextStyle(fontSize: S.sp(15))),
          onPressed: _doPair,
        ),
      ],
    );
  }

  /// 选择星座后的回调
  void _conCall(int sex, int select, String name) {
    setState(() {
      if (sex == male) {
        _maleCon = select;
        _maleStr = name.substring(0, 2);
      } else {
        _femaleCon = select;
        _femaleStr = name.substring(0, 2);
      }
    });
    // 选好数据后关闭弹框
    Navigator.pop(context);
  }

  /// 查询星座配对
  void _doPair() async {
    if (_maleCon == -1 || _femaleCon == -1) {
      CusToast.toast(context, text: "未选择所有星座");
      return;
    }
    SpinKit.threeBounce(context);
    try {
      var m = {"male_con": _maleCon, "female_con": _femaleCon};
      var res = await ApiFree.conMatch(m);
      Log.info("查询星座配对结果:${res.toJson()}");
      if (res != null) {
        Navigator.pop(context);
        CusRoute.push(context, ConResPage(res: res)).then((value) {
          _maleStr = _femaleStr = "";
          _maleCon = _femaleCon = -1;
          setState(() {});
        });
      }
    } catch (e) {
      Log.error("星座配对出现异常：$e");
    }
  }
}
