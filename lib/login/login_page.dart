import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_reg.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/flutter/under_field.dart';
import 'package:yiapp/complex/widgets/small/cus_loading.dart';
import 'package:yiapp/model/login/cus_login_res.dart';
import 'package:yiapp/model/login/login_result.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_login.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import 'package:yiapp/ui/home/home_page.dart';
import 'package:yiapp/ui/home/login_verify.dart';
import '../service/api/api_user.dart';
import 'register_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/20 15:17
// usage ：登录页面
// ------------------------------------------------------

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _mobileCtrl = TextEditingController(); // 登录手机号
  var _pwdCtrl = TextEditingController(); // 鸿运密码
  String _mobileErr; // 非手机号错误提示
  String _pwdErr; // 密码错误提示
  String _err; // 错误提示信息
  var _future;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        showLeading: false,
        backGroundColor: fif_primary,
        actions: <Widget>[_registerBtn()],
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) => _lv(),
      ),
      backgroundColor: fif_primary,
    );
  }

  Widget _lv() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(50)),
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        SizedBox(height: Adapt.px(100)),
        // 手机号输入框
        CusUnderField(
          controller: _mobileCtrl,
          hintText: "请输入手机号",
          errorText: _mobileErr,
          keyboardType: TextInputType.phone,
          maxLength: 11,
          autofocus: true,
          formatter: true,
        ),
        SizedBox(height: Adapt.px(50)),
        // 密码输入框
        CusUnderField(
          controller: _pwdCtrl,
          hintText: "请输入登录密码",
          fromValue: "suxing", // 测试时的默认密码
          errorText: _pwdErr,
          maxLength: 20,
          onlyLetter: true,
        ),
        SizedBox(height: Adapt.px(40)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // 游客登录
            InkWell(
              child: Text(
                '游客登录',
                style: TextStyle(fontSize: Adapt.px(24), color: t_gray),
              ),
              onTap: _guestLogin,
            ),
            SizedBox(width: Adapt.px(30)),
            // 忘记密码
//            InkWell(
//              child: Text(
//                '忘记密码',
//                style: TextStyle(fontSize: Adapt.px(24), color: t_gray),
//              ),
//              onTap: () =>
//                  CusToast.toast(context, text: '忘记密码待做', showChild: false),
//            ),
          ],
        ),
        SizedBox(height: Adapt.px(60)),
        CusRaisedBtn(
          text: '登录',
          fontSize: 28,
          textColor: Colors.black,
          backgroundColor: Color(0xFFEE9972),
          onPressed: _doLogin,
          borderRadius: 50,
        ),
      ],
    );
  }

  /// 游客登录
  void _guestLogin() async {
    CusDialog.normal(
      context,
      title: "登录提示",
      subTitle: "您以游客登录后看到的非本产品的全部功能，解锁更多功能请绑定您的运营商",
      textAgree: "登录",
      fnDataApproval: "",
      onThen: () async {
        CusLoginRes res = await LoginDao(glbDB).readGuest();
        if (ApiBase.jwt == res.jwt) {
          // 直接跳转到首页即可，无须更换账号
          Debug.log("目前登录的就是游客账号");
        } else {
          Debug.log("切换账号");
          LoginVerify.init(LoginResult.from(res), context);
        }
        SpinKit.threeBounce(context, text: "正在登录，请稍等...");
        await Future.delayed(Duration(milliseconds: 1000));
        Navigator.pop(context);
        CusRoutes.pushReplacement(context, HomePage());
      },
    );
  }

  /// 请求登录
  void _doLogin() async {
    setState(() {
      _err = _mobileErr = _pwdErr = null;
      if (!CusRegExp.phone(_mobileCtrl.text)) {
        _err = "请输入正确的手机号";
      } else if (_pwdCtrl.text.length < 6) {
        _err = "密码由6-20位大小写字母组成";
      }
    });
    if (_err != null) {
      CusToast.toast(context, text: _err);
      return;
    }
    LoginResult login; // 最终传递的登录结果
    // 在登录界面登录鸿运来，直接请求即可，不需要判断本地数据库是否已存在，否则无法保证数据最新
    try {
      bool exist = await ApiUser.userCodeExist(_mobileCtrl.text);
      if (exist) {
        Debug.log("存在该账号");
        var m = {
          "user_code": _mobileCtrl.text.trim(),
          "pwd": _pwdCtrl.text.trim(),
        };
        try {
          login = await ApiLogin.login(m);
          if (login != null) {
            await LoginVerify.init(login, context);
            SpinKit.threeBounce(context, text: "正在登录，请稍等...");
            await Future.delayed(Duration(milliseconds: 1000));
            Navigator.pop(context);
            CusRoutes.pushReplacement(context, HomePage());
          }
        } catch (e) {
          Debug.logError("登录出现异常：$e");
          _pwdErr = "密码错误";
          setState(() {});
        }
      } else {
        _mobileErr = "账号不存在";
        setState(() {});
      }
    } catch (e) {
      Debug.logError("判断用户是否存在出现异常：$e");
    }
  }

  /// 注册按钮
  Widget _registerBtn() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: Adapt.px(30)),
      child: InkWell(
        onTap: () => CusRoutes.push(context, RegisterPage()),
        child: Text(
          "新用户注册",
          style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }
}
