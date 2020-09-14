import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_reg.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/8 11:23
// usage ：修改用户手机号(user_code) 暂不做
// ------------------------------------------------------

class ChUserMobile extends StatefulWidget {
  final String mobile;

  ChUserMobile({this.mobile, Key key}) : super(key: key);

  @override
  _ChUserMobileState createState() => _ChUserMobileState();
}

class _ChUserMobileState extends State<ChUserMobile> {
  String _mobile = "";
  bool _isMobile = false; // 是否为手机号

  @override
  void initState() {
    _mobile = widget.mobile;
    print(">>>当前手机号长度：：${_mobile}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "修改手机号"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return DefaultTextStyle(
      style: TextStyle(color: t_primary, fontSize: Adapt.px(30)),
      child: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: Adapt.px(20)),
            child: Text("手机号"),
          ),
          // 修改手机号输入框
          CusRectField(
            hintText: "输入新手机号",
            keyboardType: TextInputType.phone,
            maxLength: 11,
          ),
          if (!CusRegExp.phone(_mobile))
            Padding(
              padding: EdgeInsets.only(top: Adapt.px(10), bottom: Adapt.px(50)),
              child: Text("请输入正确格式的手机号", style: TextStyle(color: Colors.red)),
            ),
          SizedBox(height: Adapt.px(80)),
          // 修改昵手机号
          _chMobile(),
        ],
      ),
    );
  }

  /// 修改用户手机号
  Widget _chMobile() {
    return CusRaisedBtn(
      text: "修改",
      onPressed: () async {
        if (_mobile == widget.mobile) {
          Navigator.pop(context);
          return;
        }
        var m = {"nick": _mobile};
      },
    );
  }
}
