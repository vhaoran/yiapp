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
// usage ：下划线输入框
// ------------------------------------------------------

class CusUnderField extends StatefulWidget {
  final TextEditingController controller; // 可为空
  final String fromValue; // 初始值文字
  final String hintText; // 提示文字
  final int maxLength;
  final int maxLines;
  final bool onlyNumber; // 限制只能输入数字
  final bool onlyChinese; // 限制只能输入汉字
  final bool onlyLetter; // 限制只能输入大小写字母
  final List<TextInputFormatter> inputFormatters;
  final bool autofocus;
  final bool enable;
  final bool isClear; // 为true代表suffixIcon是清空内容组件，false为自定义组件
  final TextInputType keyboardType; // 键盘输入类型
  final TextStyle style; // 输入时的文字风格
  final TextStyle hintStyle;
  final TextStyle errorStyle;
  final Widget suffixIcon;
  final bool formatter;
  String errorText; // 错误提示

  CusUnderField({
    @required this.controller,
    this.hintText: "",
    this.fromValue: "",
    this.maxLength: -1,
    this.maxLines: 1,
    this.onlyNumber: false,
    this.onlyChinese: false,
    this.onlyLetter: false,
    this.inputFormatters,
    this.autofocus: false,
    this.enable,
    this.isClear: true,
    this.keyboardType: TextInputType.text,
    this.style,
    this.hintStyle,
    this.errorStyle,
    this.suffixIcon,
    this.errorText,
    this.formatter: false,
    Key key,
  }) : super(key: key);

  @override
  _CusUnderFieldState createState() => _CusUnderFieldState();
}

class _CusUnderFieldState extends State<CusUnderField> {
  @override
  void initState() {
    widget.controller?.text = widget.fromValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 限制输入行数，默认显示一行，根据输入文字个数自动扩展输入框高度，但最多不能超过maxLines
    // 当超过maxLines行时，输入框高度不再增加，让剩下多出的文字向上滚动
    return LayoutBuilder(
      builder: (context, size) {
        var text = TextSpan(
          text: widget.controller.text,
          style: TextStyle(fontSize: Adapt.px(28)),
        );
        var tp = TextPainter(
          text: text,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
        );
        tp.layout(maxWidth: size.maxWidth);
        final int lines = (tp.size.height / tp.preferredLineHeight).ceil();
        return _input(lines);
      },
    );
  }

  /// 输入框
  Widget _input(int lines) {
    return TextField(
      controller: widget.controller,
      autofocus: widget.autofocus,
      enabled: widget.enable,
      keyboardType:
          widget.onlyNumber ? TextInputType.number : widget.keyboardType,
      maxLength: widget.maxLength,
      maxLines: lines < widget.maxLines ? null : widget.maxLines,
      style: widget.style ?? TextStyle(color: t_gray, fontSize: Adapt.px(30)),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: widget.hintStyle ??
            TextStyle(color: t_gray, fontSize: Adapt.px(30)),
        errorText: widget.errorText,
        errorStyle:
            widget.errorStyle ?? TextStyle(fontSize: Adapt.px(28), color: t_yi),
        counterText: '',
        suffixIcon: widget.isClear ? _clearInput() : widget.suffixIcon,
        focusedBorder: cusUnderBorder(),
        errorBorder: cusUnderBorder(),
        focusedErrorBorder: cusUnderBorder(),
        enabledBorder: cusUnderBorder(),
      ),
      inputFormatters: widget.inputFormatters == null
          ? [
              if (widget.onlyNumber) WhitelistingTextInputFormatter.digitsOnly,
              if (widget.onlyChinese)
                WhitelistingTextInputFormatter(RegExp(r"[\u4e00-\u9fa5]")),
              if (widget.onlyLetter)
                WhitelistingTextInputFormatter(RegExp(r"^[A-Za-z]+$")),
            ]
          : widget.inputFormatters,
      onChanged: (value) {
        if (widget.errorText != null) {
          widget.errorText = null;
        }
        setState(() {});
      },
    );
  }

  /// 清空输入信息
  Widget _clearInput() {
    bool b;
    if (widget.maxLength == -1) {
      b = widget.controller.text.isNotEmpty;
    } else {
      // 到最大输入长度时，隐藏清空组件
      b = widget.controller.text.isNotEmpty &&
          widget.controller.text.length < widget.maxLength;
    }
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
