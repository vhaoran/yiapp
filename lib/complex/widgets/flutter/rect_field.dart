import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import '../cus_complex.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/7 18:58
// usage ：矩形输入框
// ------------------------------------------------------

class CusRectField extends StatefulWidget {
  final TextEditingController controller; // 可为空
  final String fromValue; // 初始值文字
  final String hintText;
  final String prefixText; // 前置提示信息
  final int maxLength;
  final int maxLines;
  final bool formatter;
  final bool autofocus;
  final bool enable;
  final bool hideBorder;
  final double pdHor;
  final double fontSize;
  final FocusNode focusNode;
  String errorText; // 错误提示
  TextInputType keyboardType;

  CusRectField({
    this.controller,
    this.fromValue: "",
    this.hintText: "",
    this.prefixText,
    this.maxLength: -1,
    this.maxLines: 1,
    this.formatter: false,
    this.autofocus: true,
    this.enable: true,
    this.hideBorder: false,
    this.pdHor: 30,
    this.fontSize: 30,
    this.focusNode,
    this.errorText,
    this.keyboardType: TextInputType.text,
    Key key,
  }) : super(key: key);

  @override
  _CusRectFieldState createState() => _CusRectFieldState();
}

class _CusRectFieldState extends State<CusRectField> {
  @override
  void initState() {
    widget.controller?.text = widget.fromValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: fif_primary,
            borderRadius: BorderRadius.circular(5),
          ),
          child: _input(),
        ),
        if (widget.errorText != null) // 错误提示信息
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(15)),
            child: CusText(widget.errorText, t_yi, widget.fontSize - 2),
          ),
      ],
    );
  }

  /// 输入框
  Widget _input() {
    return TextField(
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      enabled: widget.enable,
      keyboardType: widget.keyboardType,
      style: TextStyle(color: t_gray, fontSize: Adapt.px(widget.fontSize)),
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle:
            TextStyle(color: t_gray, fontSize: Adapt.px(widget.fontSize)),
        prefixText: widget.prefixText,
        prefixStyle:
            TextStyle(color: t_yi, fontSize: Adapt.px(widget.fontSize + 2)),
        contentPadding: EdgeInsets.symmetric(
            horizontal: Adapt.px(widget.pdHor), vertical: Adapt.px(20)),
        counterText: "",
        border: widget.hideBorder ? InputBorder.none : cusOutlineBorder(),
        focusedBorder: widget.hideBorder
            ? InputBorder.none
            : cusOutlineBorder(color: Colors.white24),
        errorBorder: widget.hideBorder
            ? InputBorder.none
            : cusOutlineBorder(color: Colors.white24),
        focusedErrorBorder: widget.hideBorder
            ? InputBorder.none
            : cusOutlineBorder(color: Colors.white24),
      ),
      onChanged: (val) {
        if (widget.errorText != null) {
          widget.errorText = null;
        }
        setState(() {});
      },
      inputFormatters:
          widget.formatter ? [WhitelistingTextInputFormatter.digitsOnly] : null,
    );
  }
}
