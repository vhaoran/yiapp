import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final Widget prefixIcon; // 前置组件
  final Widget suffixIcon; // 后置组件
  final int maxLength;
  final int maxLines;
  final bool onlyNumber; // 限制只能输入数字
  final bool onlyChinese; // 限制只能输入汉字
  final List<TextInputFormatter> inputFormatters;
  final bool autofocus;
  final bool enable;
  final bool hideBorder;
  final bool isClear; // 为true代表suffixIcon是清空内容组件，false为自定义组件
  final double pdHor;
  final double fontSize;
  final double borderRadius;
  final Color backgroundColor;
  final FocusNode focusNode;
  final TextAlign textAlign;
  String errorText; // 错误提示
  TextInputType keyboardType;
  final VoidCallback onChanged;

  CusRectField({
    this.controller,
    this.fromValue: "",
    this.hintText: "",
    this.prefixText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength: -1,
    this.maxLines: 1,
    this.onlyNumber: false,
    this.onlyChinese: false,
    this.inputFormatters,
    this.autofocus: true,
    this.enable: true,
    this.hideBorder: false,
    this.isClear: false,
    this.pdHor: 30,
    this.fontSize: 30,
    this.borderRadius: 5,
    this.backgroundColor: fif_primary,
    this.focusNode,
    this.textAlign: TextAlign.start,
    this.errorText,
    this.keyboardType: TextInputType.text,
    this.onChanged,
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
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
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
        textAlign: widget.textAlign,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle:
              TextStyle(color: t_gray, fontSize: Adapt.px(widget.fontSize)),
          prefixText: widget.prefixText,
          prefixStyle:
              TextStyle(color: t_yi, fontSize: Adapt.px(widget.fontSize + 2)),
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isClear ? _clearInput() : widget.suffixIcon,
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
          if (widget.onChanged != null) {
            widget.onChanged();
          }
          setState(() {});
        },
        inputFormatters: widget.inputFormatters == null
            ? [
                if (widget.onlyNumber)
                  WhitelistingTextInputFormatter.digitsOnly,
                if (widget.onlyChinese)
                  WhitelistingTextInputFormatter(RegExp(r"[\u4e00-\u9fa5]"))
              ]
            : widget.inputFormatters);
  }

  /// 清空输入信息
  Widget _clearInput() {
    bool hadData;
    if (widget.maxLength == -1) {
      hadData = widget.controller.text.isNotEmpty;
    } else {
      // 到最大输入长度时，隐藏清空组件
      hadData = widget.controller.text.isNotEmpty &&
          widget.controller.text.length < widget.maxLength;
    }
    if (hadData) {
      return IconButton(
        icon: Icon(
          FontAwesomeIcons.timesCircle,
          size: Adapt.px(32),
          color: Colors.white54,
        ),
        onPressed: () {
          widget.controller.clear();
          if (widget.onChanged != null) {
            widget.onChanged();
          }
          setState(() {});
        },
      );
    }
    return null;
  }
}
