import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_reg.dart';
import 'package:yiapp/complex/widgets/flutter/under_field.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/model/complex/address_result.dart';
import 'package:yiapp/service/api/api_user.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/9 15:45
// usage ：添加新地址、修改旧地址的共用页面
// ------------------------------------------------------

class AddChAddrPage extends StatefulWidget {
  final AddressResult res;

  AddChAddrPage({this.res, Key key}) : super(key: key);

  @override
  _AddChAddrPageState createState() => _AddChAddrPageState();
}

class _AddChAddrPageState extends State<AddChAddrPage> {
  var _userCtrl = TextEditingController(); // 收件人
  var _mobileCtrl = TextEditingController(); // 手机号
  var _addrCtrl = TextEditingController(); // 地址
  String _userErr; // 收件人错误提示信息
  String _mobileErr; // 手机号错误提示信息
  String _addrErr; // 地址错误信息提示
  bool _isAdd = true; // 是否为添加新地址

  @override
  void initState() {
    _isAdd = widget.res == null ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarCtr(),
      body: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(50)),
        children: <Widget>[
          SizedBox(height: Adapt.px(100)),
          ..._inputs(), // 输入框
        ],
      ),
      backgroundColor: primary,
    );
  }

  /// 添加收货地址
  void _doAddAddr() async {
    var m = {
      "contact": _userCtrl.text.trim(),
      "mobile": _mobileCtrl.text,
      "address": _addrCtrl.text,
    };
    try {
      var res = await ApiUser.userAddrAdd(m);
      print(">>>添加收件地址结果：${res.toJson()}");
      if (res != null) {
        CusToast.toast(context, text: "添加成功");
        Navigator.pop(context);
      }
    } catch (e) {
      print("<<<添加收件地址出现异常：$e");
    }
  }

  /// 修改收货地址
  void _doChAddr() async {
    var m = {
      "id": widget.res.id,
      "M": {
        "contact_person": _userCtrl.text.trim(),
        "mobile": _mobileCtrl.text,
        "detail": _addrCtrl.text,
      },
    };
    try {
      bool ok = await ApiUser.userAddrCh(m);
      print(">>>修改 id 为 ${widget.res.id} 的地址结果：$ok");
      if (ok) {
        CusToast.toast(context, text: "修改成功");
        Navigator.pop(context);
      }
    } catch (e) {
      print("<<<修改收件地址出现异常：$e");
    }
  }

  /// 输入框
  List<Widget> _inputs() {
    return <Widget>[
      CusUnderField(
        controller: _userCtrl, // 收货人输入框
        hintText: "收货人",
        errorText: _userErr,
        autofocus: _isAdd,
        fromValue: _isAdd ? null : widget.res.contact_person,
      ),
      CusUnderField(
        controller: _mobileCtrl, // 手机号输入框
        hintText: "手机号码",
        errorText: _mobileErr,
        maxLength: 11,
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        fromValue: _isAdd ? null : widget.res.mobile,
      ),
      CusUnderField(
        controller: _addrCtrl, // 地址输入框
        hintText: "详细地址（确保地址可用）",
        maxLines: 3,
        errorText: _addrErr,
        fromValue: _isAdd ? null : widget.res.detail,
      ),
    ];
  }

  Widget _appBarCtr() {
    return CusAppBar(
      text: _isAdd ? "添加收货地址" : "编辑收货地址",
      actions: <Widget>[
        FlatButton(
          child: CusText("保存", Colors.orangeAccent, 28),
          onPressed: () {
            setState(() {
              _userErr = _userCtrl.text.isEmpty ? "收货人不能为空" : null;
              if (_userErr != null) return;
              _mobileErr =
                  !CusRegExp.phone(_mobileCtrl.text) ? "请输入正确的手机号" : null;
              if (_mobileErr != null) return;
              _addrErr = _addrCtrl.text.isEmpty ? "地址不能为空" : null;
              if (_addrErr != null) return;
            });
            if (_userErr == null && _mobileErr == null && _addrErr == null) {
              print(">>>收货人：${_userCtrl.text}");
              print(">>>手机号：${_mobileCtrl.text}");
              print(">>>详细地址：${_addrCtrl.text}");
              _isAdd ? _doAddAddr() : _doChAddr();
            }
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _userCtrl.dispose();
    _mobileCtrl.dispose();
    _addrCtrl.dispose();
    super.dispose();
  }
}
