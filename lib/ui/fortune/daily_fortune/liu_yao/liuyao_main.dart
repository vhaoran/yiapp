import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_divider.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_online.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_time.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_way.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/3 10:06
// usage ：六爻排盘页面
// ------------------------------------------------------

class LiuYaoPage extends StatefulWidget {
  LiuYaoPage({Key key}) : super(key: key);

  @override
  _LiuYaoPageState createState() => _LiuYaoPageState();
}

class _LiuYaoPageState extends State<LiuYaoPage> {
  String _guaTime = ""; // 起卦时间
  int _select = 0; // 选中的哪一个起卦方式
  List<int> _onLines = []; // 在线起卦的六爻编码

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "六爻排盘"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(40)),
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: Adapt.px(20)),
          child: Text(
            "        六爻排盘又名周易摇卦，始于周朝，创于周文王，由《周易》演变，"
            "因万物演化皆有规律，通过摇卦预测吉凶，直观灵验。",
            style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
          ),
        ),
        // 起卦时间
        LiuYaoTime(
          pickerTime: (String time) => setState(() => _guaTime = time),
        ),
        // 选择起卦方式
        LiuYaoWay(select: (int way) => setState(() => _select = way)),
        // 根据起卦方式，显示具体内容
        _guaType(_select),
        CusDivider(),
        Text(
          "        请让内心平静，摒除杂念，集中注意力默想自己占卜之事，"
          "每次摇卦时在心里默数3秒，会更加灵验哦!",
          style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
        ),
      ],
    );
  }

  /// 动态选择起卦方式
  Widget _guaType(int select) {
    Widget w;
    if (select != 0) _onLines.clear(); // 点击其它卦时，清空在线起卦数据
    switch (select) {
      case 0: // 在线起卦
        w = LiuYaoByOnLine(
          l: _onLines,
          guaTime: (String time) => setState(() => _guaTime = time),
        );
        break;
      default:
        w = SizedBox.shrink();
        break;
    }
    return w;
  }
}
