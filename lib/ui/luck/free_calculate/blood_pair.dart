import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/const/con_list.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/util/temp/cus_tool.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/fn/fn_dialog.dart';
import 'package:yiapp/ui/luck/widget/pair_description.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/ui/luck/widget/pair_select.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
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
      padding: EdgeInsets.only(left: S.w(25), right: S.w(25), top: S.h(15)),
      children: <Widget>[
        // 顶部描述信息
        PairDescription(
          iconValue: 0xe656,
          name: "血型配对",
          desc: "，指根据自己的血型和恋人的血型来大致分析下双方的性格特征，"
              "并给出两人的速配指数，以及性格方面的相关建议和提醒",
        ),
        SizedBox(height: S.h(40)),
        // 选择血型
        PairSelect(
          name: "男生血型：",
          value: _maleStr.isEmpty ? "请选择血型" : "$_maleStr型",
          onTap: () => FnDialog(context,
              sex: male,
              groupValue: _maleBlood,
              l: c_bloods,
              fnPair: _bloodCall),
        ),
        SizedBox(height: S.h(20)),
        PairSelect(
          name: "女生血型：",
          value: _femaleStr.isEmpty ? "请选择血型" : "$_femaleStr型",
          onTap: () => FnDialog(context,
              sex: female,
              groupValue: _femaleBlood,
              l: c_bloods,
              fnPair: _bloodCall),
        ),
        SizedBox(height: S.h(60)),
        CusRaisedButton(
          child: Text("开始测算", style: TextStyle(fontSize: S.sp(15))),
          onPressed: _doPair,
        ),
      ],
    );
  }

  /// 选择血型后的回调
  void _bloodCall(int sex, int select, String name) {
    setState(() {
      if (sex == male) {
        _maleBlood = select;
        _maleStr = CusTool.AZ(name);
      } else {
        _femaleBlood = select;
        _femaleStr = CusTool.AZ(name);
      }
    });
    // 选好数据后关闭弹框
    Navigator.pop(context);
  }

  /// 查询血型配对
  void _doPair() async {
    if (_maleBlood == -1 || _femaleBlood == -1) {
      CusToast.toast(context, text: "未选择所有血型");
      return;
    }
    SpinKit.threeBounce(context);
    try {
      var m = {"male_blood": _maleStr, "female_blood": _femaleStr};
      var res = await ApiFree.bloodMatch(m);
      Log.info("查询血型配对结果:${res.toJson()}");
      if (res != null) {
        Navigator.pop(context);
        CusRoute.push(context, BloodResPage(res: res)).then((value) {
          _maleStr = _femaleStr = "";
          _maleBlood = _femaleBlood = -1;
          setState(() {});
        });
      }
    } catch (e) {
      Log.error("血型配对出现异常：$e");
    }
  }
}
