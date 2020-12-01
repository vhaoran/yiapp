import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/func/cus_callback.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/switch_yin_yang.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/29 14:48
// usage ：顶部标题，含取消或者确定按钮
// ------------------------------------------------------

class PickerHeader extends StatefulWidget {
  final Widget midChild; // 中间可扩展的组件
  final bool showLunar; // 显示阳历/阴历
  final VoidCallback onFirm; // 确认后的事件
  final FnBool selectLunar; // 点击阴历的事件

  const PickerHeader({
    this.midChild,
    this.showLunar: false,
    @required this.onFirm,
    this.selectLunar,
    Key key,
  }) : super(key: key);

  _PickerHeaderState createState() => _PickerHeaderState();
}

class _PickerHeaderState extends State<PickerHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: CusText("取消", Color(0xFF999999), 30),
              onPressed: () => Navigator.pop(context),
            ),
            if (widget.showLunar) // 阴阳历
              SwitchYinYang(selectLunar: (val) => widget.selectLunar(val)),
            if (widget.midChild != null)
              widget.midChild, // 自定义中间组件
            FlatButton(
              child: CusText("确认", Color(0xFFB52E2D), 30),
              onPressed: widget.onFirm,
            ),
          ],
        ),
        Divider(thickness: 0.3, height: 0, color: Color(0xFF999999)),
      ],
    );
  }
}
