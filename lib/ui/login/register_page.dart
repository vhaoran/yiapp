import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/util/regex/regex_func.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/under_field.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/ui/login/agreement_page.dart';
import 'package:yiapp/service/api/api_login.dart';
import '../../service/api/api_user.dart';
import 'login_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/21 09:40
// usage ：用户注册
// ------------------------------------------------------

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var _mobileCtrl = TextEditingController(); // 手机号输入框
  var _nickCtrl = TextEditingController(); // 昵称输入框
  var _pwdCtrl = TextEditingController(); // 密码输入框
  String _err; // 弹框提示错误信息
  String _mobileErr; // 手机号错误提示
  bool _agree = true; // 是否同意用户协议

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(backGroundColor: fif_primary),
      body: _lv(),
      backgroundColor: fif_primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 25),
      children: <Widget>[
        SizedBox(height: 40),
        // 手机号
        CusUnderField(
          controller: _mobileCtrl,
          hintText: "输入手机号",
          errorText: _mobileErr,
          onlyNumber: true,
          isClear: true,
          maxLength: 11,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Adapt.px(40)),
          child: CusUnderField(
            controller: _nickCtrl,
            hintText: "输入汉字昵称",
            onlyChinese: true,
            maxLength: 6,
          ),
        ),
        // 登录密码
        CusUnderField(
          controller: _pwdCtrl,
          hintText: "设置登录密码 (6-20位大小写字母)",
          maxLength: 20,
          onlyLetter: true,
        ),
        SizedBox(height: 40),
        CusRaisedButton(
          child: Text("注册"),
          onPressed: _verify,
          backgroundColor: Color(0xFFEE9972),
          radius: 50,
        ),
        _userAgreement(), // 用户协议
      ],
    );
  }

  /// 用户协议
  Widget _userAgreement() {
    return CheckboxListTile(
      value: this._agree,
      onChanged: (value) => setState(() => this._agree = value),
      controlAffinity: ListTileControlAffinity.leading,
      checkColor: t_gray,
      activeColor: Colors.blueGrey,
      title: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14, color: t_gray),
          children: <InlineSpan>[
            TextSpan(text: '我已阅读并同意'),
            TextSpan(
              text: '《鸿运来用户协议》',
              style: TextStyle(fontSize: Adapt.px(28), color: Colors.lightBlue),
              // 手势（`gestures`）库的点击手势识别器（`TapGestureRecognizer`）类，识别点击手势。
              // 识别（`recognizer`）属性，一个手势识别器，它将接收触及此文本范围的事件。
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  CusRoute.push(context, AgreementPage());
                },
            ),
          ],
        ),
      ),
    );
  }

  /// 验证是否满足注册条件
  void _verify() async {
    setState(() {
      _err = null;
      if (!RegexUtil.isMobile(_mobileCtrl.text)) {
        _err = "请输入正确的手机号";
      } else if (_nickCtrl.text.isEmpty) {
        _err = "昵称不能为空";
      } else if (_pwdCtrl.text.length < 6) {
        _err = "密码最少6位";
      }
    });
    if (_err != null) {
      CusToast.toast(context, text: _err);
      return;
    }
    if (_agree) {
      // 如果满足注册条件并勾选了用户协议，则先验证用户名(手机号)存在性
      try {
        bool exist = await ApiUser.userCodeExist(_mobileCtrl.text);
        if (exist) {
          _mobileErr = "当前手机号已注册";
          setState(() {});
        } else {
          _doRegister();
        }
      } catch (e) {
        Log.error("注册时验证手机号存在性出现异常: $e");
      }
    } else {
      CusDialog.tip(context, title: "请同意并勾选用户协议");
    }
  }

  /// 注册
  void _doRegister() async {
    SpinKit.threeBounce(context);
    var m = {
      "user_code": _mobileCtrl.text.trim(),
      "nick": _nickCtrl.text.trim(),
      "pwd": _pwdCtrl.text.trim(),
    };
    try {
      bool ok = await ApiLogin.regUser(m);
      if (ok) {
        Navigator.pop(context);
        CusToast.toast(context, text: "注册成功，请登录");
        await KV.setStr(kv_tmp_pwd, _pwdCtrl.text);
        await Future.delayed(Duration(milliseconds: 1000));
        CusRoute.pushReplacement(context, LoginPage());
      }
      // 注册失败
      else {
        CusDialog.tip(context, title: "注册失败，请重新注册");
      }
    } catch (e) {
      Log.error("注册出现异常：$e");
    }
  }

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _nickCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }
}
