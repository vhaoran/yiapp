import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import 'package:yiapp/complex/widgets/small/cus_singlebar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/22 17:03
// usage ：底部导航类型
// ------------------------------------------------------

class NavigationType extends StatefulWidget {
  bool isMid;
  int curIndex;
  FnInt onChanged;

  NavigationType({
    this.isMid: false,
    this.curIndex: 0,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  _NavigationTypeState createState() => _NavigationTypeState();
}

class _NavigationTypeState extends State<NavigationType> {
  final List<String> _barNames = ["运势", "供奉", "问命", "大师", "我的"];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _barNames.map(
          (name) {
            int i = _barNames.indexOf(name);
            Color select = widget.curIndex == i ? t_primary : t_gray;
            return CusSingleBar(
              title: widget.isMid && i == 2 ? "发布提问" : name,
              titleColor: select,
              iconColor: select,
              length: _barNames.length,
              icon: _icon(i),
              onTap: () {
                if (widget.onChanged != null) {
                  widget.onChanged(i);
                }
              },
            );
          },
        ).toList(),
      ),
      color: ter_primary,
      shape: CircularNotchedRectangle(),
    );
  }

  /// 动态获取底部导航栏图标
  IconData _icon(int i) {
    IconData icon;
    switch (i) {
      case 0:
        icon = IconData(0xe618, fontFamily: 'AliIcon');
        break;
      case 1:
        icon = IconData(0xe66b, fontFamily: 'AliIcon');
        break;
      case 2:
        icon = IconData(0xe666, fontFamily: 'AliIcon');
        break;
      case 3:
        icon = IconData(0xe605, fontFamily: 'AliIcon');
        break;
      case 4:
        icon = IconData(0xe608, fontFamily: 'AliIcon');
        break;
      default:
        icon = FontAwesomeIcons.fastForward;
        break;
    }
    return icon;
  }
}
