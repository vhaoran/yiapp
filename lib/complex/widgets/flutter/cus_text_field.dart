import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_callback.dart';
import '../cus_complex.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/7 18:58
// usage ：自定义输入框
// ------------------------------------------------------

class CusTextField extends StatefulWidget {
  final String value; // 外部传入的默认参数
  FnString onChanged;
  VoidCallback callback;
  final String hintText;
  TextInputType keyboardType;
  int maxLength;
  List<TextInputFormatter> inputFormatters;

  CusTextField({
    this.value: "",
    this.onChanged,
    this.callback,
    this.hintText: "默认内容",
    this.keyboardType: TextInputType.text,
    this.maxLength: 18,
    this.inputFormatters: null,
    Key key,
  }) : super(key: key);

  @override
  _CusTextFieldState createState() => _CusTextFieldState();
}

class _CusTextFieldState extends State<CusTextField> {
  String _value = "";

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: fif_primary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        autofocus: true,
        keyboardType: widget.keyboardType,
        style: TextStyle(color: t_gray, fontSize: Adapt.px(32)),
        maxLength: widget.maxLength,
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: _value,
            selection: TextSelection.fromPosition(
              TextPosition(offset: _value.length), // 光标移动到最后
            ),
          ), // 设置默认内容
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: t_gray, fontSize: Adapt.px(32)),
          contentPadding: EdgeInsets.only(left: Adapt.px(30)),
          counterText: "",
          border: cusOutlineBorder(),
          focusedBorder: cusOutlineBorder(color: Colors.white24),
          errorBorder: cusOutlineBorder(color: Colors.red),
        ),
        onChanged: (val) {
          _value = val;
          if (widget.onChanged != null) {
            widget.onChanged(_value);
          }
          if (widget.callback != null) {
            widget.callback();
          }
        },
        inputFormatters: widget.inputFormatters,
      ),
    );
  }
}
