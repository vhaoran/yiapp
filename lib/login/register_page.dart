import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_reg.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/service/api/api_login.dart';
import '../service/api/api_user.dart';
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
  var _mobileCon = TextEditingController(); // 手机号
  var _captchaCon = TextEditingController(); // 验证码
  var _pwdCon = TextEditingController(); // 注册密码
  List<String> _errs = List<String>(3); // 错误提示信息
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
      padding: EdgeInsets.only(left: Adapt.px(50), right: Adapt.px(50)),
      children: <Widget>[
        SizedBox(height: Adapt.px(140)),
        _mobileInput(), // 输入手机号
        _captchaInput(), // 输入验证码
        _pwdInput(), // 设置登录密码
        SizedBox(height: Adapt.px(60)),
        CusRaisedBtn(
          text: '注册',
          textColor: Colors.black,
          fontSize: 28,
          backgroundColor: Color(0xFFEE9972),
          pdVer: Adapt.px(15),
          onPressed: _doRegister,
        ),
        _userAgreement(), // 用户协议
      ],
    );
  }

  ///  手机号输入框
  Widget _mobileInput() {
    return TextField(
      maxLength: 11,
      controller: _mobileCon,
      autofocus: true,
      keyboardType: TextInputType.phone,
      style: TextStyle(color: t_gray, fontSize: Adapt.px(32)),
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        hintText: '请输入手机号',
        hintStyle: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
        errorText: _errs[0],
        errorStyle: TextStyle(fontSize: Adapt.px(26), color: t_yi),
        counterText: '',
        suffixIcon: _mobileCon.text.isNotEmpty && _mobileCon.text.length < 11
            ? IconButton(
                icon: Icon(
                  FontAwesomeIcons.timesCircle,
                  size: Adapt.px(32),
                  color: Colors.white38,
                ),
                onPressed: () => setState(() => _mobileCon.clear()),
              )
            : null,
        focusedBorder: cusUnderBorder(),
        errorBorder: cusUnderBorder(),
        focusedErrorBorder: cusUnderBorder(),
      ),
      onChanged: (value) {
        if (_errs[0] != null) {
          _errs[0] = null;
        }
        setState(() {});
      },
    );
  }

  /// 输入验证码
  Widget _captchaInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Adapt.px(40)),
      child: TextField(
        maxLength: 6,
        controller: _captchaCon,
        keyboardType: TextInputType.phone,
        style: TextStyle(color: t_gray, fontSize: Adapt.px(32)),
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          hintText: '验证码',
          hintStyle: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
          errorText: _errs[1],
          errorStyle: TextStyle(fontSize: Adapt.px(26), color: t_yi),
          counterText: '',
          focusedBorder: cusUnderBorder(),
          errorBorder: cusUnderBorder(),
          focusedErrorBorder: cusUnderBorder(),
          suffixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                child: Text(
                  "获取验证码",
                  style: TextStyle(fontSize: Adapt.px(28), color: t_gray),
                ),
                onTap: _getCaptchaID,
              ),
            ],
          ),
        ),
        onChanged: (value) {
          if (_errs[1] != null) {
            _errs[1] = null;
            setState(() {});
          }
        },
      ),
    );
  }

  /// 设置登录密码
  Widget _pwdInput() {
    return TextField(
      maxLength: 20,
      controller: _pwdCon,
      keyboardType: TextInputType.text,
      style: TextStyle(color: t_gray, fontSize: Adapt.px(32)),
      decoration: InputDecoration(
        hintText: '请设置登录密码 ( 6-20位大小写字母 )',
        hintStyle: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
        errorText: _errs[2],
        errorStyle: TextStyle(fontSize: Adapt.px(26), color: t_yi),
        counterText: '',
        suffixIcon: _pwdCon.text.isNotEmpty && _pwdCon.text.length < 20
            ? IconButton(
                icon: Icon(
                  FontAwesomeIcons.timesCircle,
                  size: Adapt.px(32),
                  color: Colors.white38,
                ),
                onPressed: () => setState(() => _pwdCon.clear()),
              )
            : null,
        focusedBorder: cusUnderBorder(),
        errorBorder: cusUnderBorder(),
        focusedErrorBorder: cusUnderBorder(),
      ),
      onChanged: (value) {
        if (_errs[2] != null) {
          _errs[2] = null;
        }
        setState(() {});
      },
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
      title: Text.rich(
        TextSpan(
          text: '我已阅读并同意',
          style: TextStyle(fontSize: Adapt.px(28), color: t_gray),
          children: [
            TextSpan(
              text: '《鸿运来用户协议》',
              style: TextStyle(fontSize: Adapt.px(28), color: Colors.lightBlue),
              // 手势（`gestures`）库的点击手势识别器（`TapGestureRecognizer`）类，识别点击手势。
              // 识别（`recognizer`）属性，一个手势识别器，它将接收触及此文本范围的事件。
              recognizer: TapGestureRecognizer()..onTap = _doAgree,
            ),
          ],
        ),
      ),
    );
  }

  /// 注册事件
  void _doRegister() async {
    setState(() {
      // 验证手机号
      _errs[0] = CusRegExp.phone(_mobileCon.text) ? null : '请输入正确的手机号';
      // 验证验证码(目前先做成仅验证输入的是不是6位数字）
      _errs[1] = CusRegExp.captcha(_captchaCon.text) ? null : '输入的验证码不正确';
      // 验证密码
      _errs[2] = (_pwdCon.text.length >= 6 && _pwdCon.text.length <= 20) &&
              CusRegExp.upLower(_pwdCon.text)
          ? null
          : '密码设置：6-20位字符大写字母、小写字母';
    });

    if (_errs.every((err) => err == null)) {
      _agree ? _submitData() : _doAgree();
    } else {
      print(">>>不满足注册的条件");
    }
  }

  /// 提交用户注册事件
  void _submitData() async {
    // 验证用户名(手机号)是否已存在
    if (_mobileCon.text.isNotEmpty) {
      try {
        bool exist = await ApiUser.userCodeExist(_mobileCon.text);
        print(">>>当前用户(手机号)是否已存在：$exist");
        _errs[0] = exist ? "当前手机号已注册" : null;
        setState(() {});
        if (exist) return;
      } catch (e) {
        print(">>>验证用户是否存在时发生错误: $e");
      }
    }
    try {
      Random random = Random();
      bool success = await ApiLogin.regUser(
        {
          "user_code": _mobileCon.text.trim(),
          "nick":
              "用户 ${random.nextInt(1000)}${random.nextInt(1000)}${random.nextInt(1000)}",
          "pwd": _pwdCon.text.trim(),
        },
      );
      print(">>>注册是否成功：$success");
      if (success) {
        CusToast.toast(context, text: "注册成功");
        Future.delayed(await Duration(milliseconds: 300))
            .then((value) => CusRoutes.pushReplacement(context, LoginPage()));
      }
      // 注册失败
      else {
        print("注册失败");
      }
    } catch (e) {
      print('------用户提交注册数据发生错误------：$e');
    }
  }

  /// 验证用户名(手机号)的存在性
  Future<void> verifyUserCode() async {
    if (CusRegExp.phone(_mobileCon.text)) {
      try {
        bool exist = await ApiUser.userCodeExist(_mobileCon.text);
        _errs[0] = exist ? "当前手机号已注册" : null;
        setState(() {});
        if (exist) return;
      } catch (e) {
        print(">>>验证用户是否存在时发生错误: $e");
      }
    }
  }

  /// 获取验证码
  void _getCaptchaID() async {
    print(">>>点了获取验证码");
    if (CusRegExp.phone(_mobileCon.text)) {
      try {
        // await ApiLogin.MobileCaptchaOfRegUser(_mobileCon.text);
      } catch (e) {
        print('------验证验证码是否正确时发生错误------：$e');
      }
    }
  }

  /// 用户是否同意协议
  void _doAgree() =>
      CusDialog.tip(context, title: _agree ? "这是用户协议、这是用户协议" : "请同意并勾选用户协议");
}
