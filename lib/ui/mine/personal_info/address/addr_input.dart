import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/9 17:14
// usage ：封装的添加地址时的输入框
// ------------------------------------------------------

class AddrTextField extends StatefulWidget {
  final TextEditingController editingCtrl;
  final String hintText;
  final String errorText;
  List<TextInputFormatter> inputFormatters;
  final int maxLength;

  AddrTextField({
    this.editingCtrl,
    this.hintText: "",
    this.errorText,
    this.inputFormatters: null,
    this.maxLength: 100,
    Key key,
  }) : super(key: key);

  @override
  _AddrTextFieldState createState() => _AddrTextFieldState();
}

class _AddrTextFieldState extends State<AddrTextField> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: fif_primary,
      margin: EdgeInsets.only(bottom: Adapt.px(2)),
      child: _input(),
    );
  }

  /// 输入框
  Widget _input() {
    return TextField(
      style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
      controller: widget.editingCtrl,
      inputFormatters: widget.inputFormatters,
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
        errorText: widget.errorText,
        contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
        counterText: "",
        suffix: _clearInput(), // 清空输入信息
        border: InputBorder.none,
      ),
      onChanged: (val) {
        setState(() {});
      },
    );
  }

  /// 清空输入的信息
  Widget _clearInput() {
    bool show = widget.editingCtrl.text.isNotEmpty &&
        widget.editingCtrl.text.length < widget.maxLength;
    if (show) {
      return IconButton(
        icon: Icon(
          FontAwesomeIcons.timesCircle,
          size: Adapt.px(32),
          color: Colors.white38,
        ),
        onPressed: () => setState(() => widget.editingCtrl.clear()),
      );
    }
    return null;
  }
}
