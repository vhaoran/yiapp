import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/func/cus_callback.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_divider.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/3 19:14
// usage ：选择起卦方式，如在线起卦等
// ------------------------------------------------------

class LiuYaoWay extends StatefulWidget {
  final FnInt select;

  const LiuYaoWay({this.select, Key key}) : super(key: key);

  @override
  _LiuYaoWayState createState() => _LiuYaoWayState();
}

class _LiuYaoWayState extends State<LiuYaoWay> {
  final List<String> _ways = ["在线起卦", "待定起卦", "待定起卦"];
  int _select = 0; // 选中的哪一个起卦方式,默认选择第一个

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "起卦方式",
          style: TextStyle(
            color: t_gray,
            fontSize: Adapt.px(32),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: Adapt.px(20)),
        GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          shrinkWrap: true,
          mainAxisSpacing: 10,
          padding: EdgeInsets.only(bottom: Adapt.px(20)),
          crossAxisSpacing: 10,
          childAspectRatio: 4,
          children: List.generate(_ways.length, (i) {
            bool select = _select == i;
            return CusRaisedBtn(
              text: _ways[i],
              borderRadius: 50,
              pdVer: 0,
              backgroundColor: select ? t_yi : CusColors.systemGrey(context),
              textColor: select ? Colors.black : Colors.white,
              onPressed: () {
                if (_select != i) _select = i;
                if (widget.select != null) {
                  widget.select(_select);
                }
                setState(() {});
              },
            );
          }),
        ),
        CusDivider(),
      ],
    );
  }
}
