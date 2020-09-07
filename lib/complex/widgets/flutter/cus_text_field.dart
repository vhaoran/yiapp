import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
  FnString input;
  final String hintText;

  CusTextField({
    this.value,
    this.input,
    this.hintText: "默认内容",
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
        keyboardType: TextInputType.text,
        style: TextStyle(color: t_gray, fontSize: Adapt.px(32)),
        maxLength: 8,
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
          if (widget.input != null) {
            widget.input(_value);
          }
          setState(() {});
        },
      ),
    );
  }
}
