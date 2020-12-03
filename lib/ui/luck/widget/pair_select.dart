import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/screen_util.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/25 17:15
// usage ：配对选择组件，如选择星座，生肖
// ------------------------------------------------------

class PairSelect extends StatelessWidget {
  final String name;
  final String value;
  final VoidCallback onTap;

  const PairSelect({this.name, this.value, this.onTap, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          name,
          style: TextStyle(color: t_gray, fontSize: S.sp(16)),
        ),
        SizedBox(width: S.w(5)),
        _dataShow(),
      ],
    );
  }

  /// 选择结果
  Widget _dataShow() {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: S.w(180),
            constraints: BoxConstraints(maxHeight: S.h(30)),
            child: Text(
              value,
              style: TextStyle(color: t_yi, fontSize: S.sp(16)),
            ),
            decoration: BoxDecoration(
              color: fif_primary,
              border: Border.all(color: Colors.grey),
            ),
          ),
          Container(
            alignment: Alignment.center,
            constraints: BoxConstraints(maxHeight: S.h(30)),
            child: Icon(FontAwesomeIcons.angleDown),
            decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
