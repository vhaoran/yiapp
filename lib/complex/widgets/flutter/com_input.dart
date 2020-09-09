import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/9 21:33
// usage ：通用输入框(下划线类型)
// ------------------------------------------------------

class ComTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText; // 提示文字
  String errorText; // 错误提示
  final int maxLength;
  final double spacing; // 输入框间隔
  final bool autofocus;
  final TextInputType keyboardType; // 键盘输入类型
  final TextStyle style; // 输入时的文字风格
  final TextStyle hintStyle;
  final TextStyle errorStyle;
  List<TextInputFormatter> inputFormatters; // 验证输入类型(黑白名单)

  ComTextField({
    @required this.controller,
    this.hintText: "",
    this.errorText,
    this.maxLength: -1,
    this.spacing: 40,
    this.autofocus: false,
    this.keyboardType: TextInputType.text,
    this.style,
    this.hintStyle,
    this.errorStyle,
    this.inputFormatters,
    Key key,
  }) : super(key: key);

  @override
  _ComTextFieldState createState() => _ComTextFieldState();
}

class _ComTextFieldState extends State<ComTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Adapt.px(widget.spacing)),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        maxLength: widget.maxLength,
        style: widget.style ?? TextStyle(color: t_gray, fontSize: Adapt.px(32)),
        autofocus: widget.autofocus,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ??
              TextStyle(color: t_gray, fontSize: Adapt.px(28)),
          errorText: widget.errorText,
          errorStyle: widget.errorStyle ??
              TextStyle(fontSize: Adapt.px(26), color: t_yi),
          counterText: '',
          suffixIcon: _clearInput(),
          focusedBorder: cusUnderBorder(),
          errorBorder: cusUnderBorder(),
          focusedErrorBorder: cusUnderBorder(),
        ),
        inputFormatters: widget.inputFormatters,
        onChanged: (value) {
          if (widget.errorText != null) {
            widget.errorText = null;
          }
          setState(() {});
        },
      ),
    );
  }

  /// 清空输入信息
  Widget _clearInput() {
    bool b = widget.controller.text.isNotEmpty &&
        widget.controller.text.length < widget.maxLength;
    if (b) {
      return IconButton(
        icon: Icon(
          FontAwesomeIcons.timesCircle,
          size: Adapt.px(32),
          color: Colors.white38,
        ),
        onPressed: () => setState(() => widget.controller.clear()),
      );
    }
    return null;
  }
}
