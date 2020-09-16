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
  final int maxLength;
  final int maxLines;
  final bool formatter;
  final bool autofocus;
  final bool enable;
  final double pdHor;
  String errorText; // 错误提示
  TextInputType keyboardType;

  CusRectField({
    this.controller,
    this.fromValue: "",
    this.hintText: "",
    this.maxLength: -1,
    this.maxLines: 1,
    this.formatter: false,
    this.autofocus: true,
    this.enable: true,
    this.pdHor: 30,
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
        if (widget.errorText != null)
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(15)),
            child: CusText(widget.errorText, t_yi, 28),
          ),
      ],
    );
  }

  /// 输入框
  Widget _input() {
    return TextField(
      autofocus: widget.autofocus,
      enabled: widget.enable,
      keyboardType: widget.keyboardType,
      style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
        contentPadding: EdgeInsets.symmetric(
            horizontal: Adapt.px(widget.pdHor), vertical: Adapt.px(20)),
        counterText: "",
        border: cusOutlineBorder(),
        focusedBorder: cusOutlineBorder(color: Colors.white24),
        errorBorder: cusOutlineBorder(color: Colors.white24),
        focusedErrorBorder: cusOutlineBorder(color: Colors.white24),
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
