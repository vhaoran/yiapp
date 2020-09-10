import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_reg.dart';
import 'package:yiapp/complex/widgets/flutter/com_input.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/9 15:45
// usage ：添加新地址
// ------------------------------------------------------

class AddAddrPage extends StatefulWidget {
  AddAddrPage({Key key}) : super(key: key);

  @override
  _AddAddrPageState createState() => _AddAddrPageState();
}

class _AddAddrPageState extends State<AddAddrPage> {
  var _userCtrl = TextEditingController(); // 收件人
  var _mobileCtrl = TextEditingController(); // 手机号
  var _addrCtrl = TextEditingController(); // 地址
  String _userErr; // 收件人错误提示信息
  String _mobileErr; // 手机号错误提示信息
  String _addrErr; // 地址错误信息提示

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        text: "添加收货地址",
        actions: <Widget>[
          FlatButton(
            child: CusText("保存", Colors.orangeAccent, 28),
            onPressed: () {
              print(">>>输入的手机号：${_mobileCtrl.text}");
              if (!CusRegExp.phone(_mobileCtrl.text)) {
                _mobileErr = "请输入正确的手机号";
              } else {
                print(">>>是正确的手机号}");
              }
              if (_userCtrl.text.isEmpty) {
                _userErr = "收件人不能为空";
              }
              setState(() {});
            },
          ),
        ],
      ),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(50)),
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        SizedBox(height: Adapt.px(100)),
        ComTextField(
          controller: _userCtrl,
          hintText: "收件人",
          errorText: _userErr,
          autofocus: true,
          spacing: 30,
        ),
        ComTextField(
          controller: _mobileCtrl,
          hintText: "手机号码",
          maxLength: 11,
          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          errorText: _mobileErr,
        ),
        SizedBox(height: Adapt.px(100)),
      ],
    );
  }

  /// 手机号输入框
  Widget _mobileInput() {
    return Container(
      color: fif_primary,
      alignment: Alignment.center,
      child: TextField(
        style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
        controller: _mobileCtrl,
        maxLength: 11,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          hintText: "手机号码",
          hintStyle: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
          contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
          counterText: "",
          suffix: _mobileCtrl.text.isNotEmpty && _mobileCtrl.text.length < 11
              ? IconButton(
                  icon: Icon(
                    FontAwesomeIcons.timesCircle,
                    size: Adapt.px(32),
                    color: Colors.white38,
                  ),
                  onPressed: () => setState(() => _mobileCtrl.clear()),
                )
              : null,
          border: InputBorder.none,
        ),
        onChanged: (val) {
          if (_mobileErr != null) _mobileErr = null;
          setState(() {});
        },
      ),
    );
  }

  /// 收货人输入框
  Widget _userInput() {
    return Card(
      elevation: 0,
      color: fif_primary,
      margin: EdgeInsets.only(bottom: Adapt.px(2)),
      child: TextField(
        style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
        controller: _userCtrl,
        decoration: InputDecoration(
          hintText: "收货人",
          hintStyle: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
          errorText: _mobileErr,
          contentPadding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
          counterText: "",
          suffix: _userCtrl.text.isNotEmpty && _userCtrl.text.length < 11
              ? IconButton(
                  icon: Icon(
                    FontAwesomeIcons.timesCircle,
                    size: Adapt.px(32),
                    color: Colors.white38,
                  ),
                  onPressed: () => setState(() => _userCtrl.clear()),
                )
              : null,
          border: InputBorder.none,
        ),
        onChanged: (val) {
          if (_mobileErr != null) _mobileErr = null;
          setState(() {});
        },
      ),
    );
  }

  /// 清空输入的信息组件
  Widget _clearInput(TextEditingController editingCtrl, {int maxLength}) {
    bool show =
        editingCtrl.text.isNotEmpty && editingCtrl.text.length < maxLength;
    if (show) {
      return IconButton(
        icon: Icon(
          FontAwesomeIcons.timesCircle,
          size: Adapt.px(32),
          color: Colors.white38,
        ),
        onPressed: () => setState(() => editingCtrl.clear()),
      );
    }
    return null;
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    super.dispose();
  }
}
