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
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/fn/fn_dialog.dart';
import 'package:yiapp/ui/luck/widget/pair_description.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/ui/luck/widget/pair_select.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/service/api/api_free.dart';
import 'package:yiapp/ui/luck/free_calculate/zodiac_res.dart';

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

  static const IconData _iconData = IconData(0xee26, fontFamily: ali_font);

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
      padding: EdgeInsets.only(left: S.w(25), right: S.w(25), top: S.h(15)),
      children: <Widget>[
        // 顶部描述信息
        PairDescription(
          name: "生肖配对",
          desc: "，是根据十二属相之间相合、相冲、相克、相害、相生、相刑的规律而产生的一种婚姻配对法，流行于民间。"
              "在命理学中，十二地支具有五行相生、相克及刑冲会合的关系",
          iconData: _iconData,
        ),
        SizedBox(height: S.h(40)),
        // 选择生肖
        PairSelect(
          name: "男生生肖：",
          value: _maleStr.isEmpty ? "请选择生肖" : "属$_maleStr",
          onTap: () => FnDialog(context,
              sex: male,
              groupValue: _maleZodiac,
              l: c_zodiacs,
              fnPair: _zodiacCall),
        ),
        SizedBox(height: S.h(20)),
        PairSelect(
          name: "女生生肖：",
          value: _femaleStr.isEmpty ? "请选择生肖" : "属$_femaleStr",
          onTap: () => FnDialog(context,
              sex: female,
              groupValue: _femaleZodiac,
              l: c_zodiacs,
              fnPair: _zodiacCall),
        ),
        SizedBox(height: S.h(60)),
        CusRaisedButton(
          child: Text("开始测算", style: TextStyle(fontSize: S.sp(15))),
          onPressed: _doPair,
        ),
      ],
    );
  }

  /// 选择生肖后的回调
  void _zodiacCall(int sex, int select, String name) {
    setState(() {
      if (sex == male) {
        _maleZodiac = select;
        _maleStr = name;
      } else {
        _femaleZodiac = select;
        _femaleStr = name;
      }
    });
    // 选好数据后关闭弹框
    Navigator.pop(context);
  }

  /// 查询生肖配对
  void _doPair() async {
    if (_maleZodiac == -1 || _femaleZodiac == -1) {
      CusToast.toast(context, text: "未选择所有生肖");
      return;
    }
    SpinKit.threeBounce(context);
    try {
      var m = {
        "male_ShengXiao": _maleZodiac,
        "female_ShengXiao": _femaleZodiac
      };
      var res = await ApiFree.shengXiaoMatch(m);
      Log.info("查询生肖配对结果:${res.toJson()}");
      if (res != null) {
        Navigator.pop(context);
        CusRoute.push(context, ZodiacResPage(res: res)).then((value) {
          _maleStr = _femaleStr = "";
          _maleZodiac = _femaleZodiac = -1;
          setState(() {});
        });
      }
    } catch (e) {
      Log.error("生肖配对配对出现异常：$e");
    }
  }
}
