import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
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
  bool _isLunar = false; // 默认阳历

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
            if (widget.showLunar)
              _yinYangLi(), // 阴阳历
            if (widget.midChild != null)
              widget.midChild, // 自定义中间组件
            FlatButton(
              child: CusText("确认", CusColors.systemBlue(context), 30),
              onPressed: widget.onFirm,
            ),
          ],
        ),
        Divider(thickness: 0.3, height: 0, color: Color(0xFF999999)),
      ],
    );
  }

  Widget _yinYangLi() {
    return Row(
      children: <Widget>[
        _gongLi(),
        _nongLi(),
//        _my("公历"),
//        _my("农历")
      ],
    );
  }

  /// 公历
  Widget _my(String text) {
    return InkWell(
      onTap: () {
        _isLunar = text == "农历" ? true : false;
        widget.selectLunar(_isLunar);
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Adapt.px(30),
          vertical: Adapt.px(8),
        ),
        decoration: BoxDecoration(
          color: _isLunar ? Colors.white54 : Color(0xFFB52E2D),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            bottomLeft: Radius.circular(5),
          ),
        ),
        child: CusText(text, _isLunar ? Color(0xFFB52E2D) : Colors.white70, 28),
      ),
    );
  }

  /// 公历
  Widget _gongLi() {
    return InkWell(
      onTap: () {
        _isLunar = false;
        widget.selectLunar(false);
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Adapt.px(30),
          vertical: Adapt.px(8),
        ),
        decoration: BoxDecoration(
          color: _isLunar ? Colors.white54 : Color(0xFFB52E2D),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5),
            bottomLeft: Radius.circular(5),
          ),
        ),
        child: CusText("公历", _isLunar ? Color(0xFFB52E2D) : Colors.white70, 28),
      ),
    );
  }

  /// 农历
  Widget _nongLi() {
    return InkWell(
      onTap: () {
        _isLunar = true;
        widget.selectLunar(true);
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Adapt.px(30),
          vertical: Adapt.px(8),
        ),
        decoration: BoxDecoration(
          color: _isLunar ? Color(0xFFB52E2D) : Colors.white54,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(5),
            bottomRight: Radius.circular(5),
          ),
        ),
        child: CusText("农历", _isLunar ? Colors.white70 : Color(0xFFB52E2D), 28),
      ),
    );
  }
}
