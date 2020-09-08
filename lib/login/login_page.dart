import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/provider/user_state.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/service/login/login_utils.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/service/api/api_login.dart';
import '../service/api/api_user.dart';
import 'package:yiapp/ui/home/home_page.dart';
import 'package:provider/provider.dart';
import 'register_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/20 15:17
// usage ：登录页面
// ------------------------------------------------------

class LoginPage extends StatefulWidget {
  final bool showDefault; // 是否在登录页面显示返回上一个页面按钮

  LoginPage({this.showDefault: false, Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _mobileCon = TextEditingController(); // 登录手机号
  var _pwdCon = TextEditingController(); // 鸿运密码
  bool _waiting = false; // 是否在过渡状态
  String _userErr; // 非手机号错误提示
  String _pwdErr; // 密码错误提示
  String _wx_code = ""; // 微信code
  var _future;

  @override
  void initState() {
//    _future = _restore();
//    _weChatLoginInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_waiting) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: CusAppBar(
        showLeading: false,
        showDefault: widget.showDefault,
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
        // 手机号输入框
        _mobileInput(),
        // 密码输入框
        _pwdInput(),
        // 忘记密码
        Container(
          padding: EdgeInsets.only(top: Adapt.px(20), bottom: Adapt.px(80)),
          alignment: Alignment.centerRight,
          child: InkWell(
            child: Text(
              '忘记密码',
              style: TextStyle(fontSize: Adapt.px(24), color: t_gray),
            ),
            onTap: () =>
                CusToast.toast(context, text: '忘记密码待做', showChild: false),
          ),
        ),
        CusRaisedBtn(
          text: '登录',
          fontSize: 28,
          textColor: Colors.black,
          backgroundColor: Color(0xFFEE9972),
          onPressed: _doLogin,
          pdVer: Adapt.px(15),
          borderRadius: 50,
        ),
      ],
    );
  }

  /// 请求登录
  void _doLogin() async {
    print(">>>_user_code：${_mobileCon.text}");
    print(">>>_pwd：${_pwdCon.text}");
    if (_pwdCon.text.isEmpty || _mobileCon.text.isEmpty) {
      _pwdErr = "手机号或者密码不能为空";
      setState(() {});
      return;
    }
    // 鸿运号是否存在，存在再登录
    bool exist = await ApiUser.userCodeExist(_mobileCon.text);
    if (exist) {
      print(">>>存在该账号");
      var m = {
        "user_code": _mobileCon.text.trim(),
        "pwd": _pwdCon.text.trim(),
        "is_mobile": false,
        "chart_key": "aaaaa",
        "chart_value": "3333",
      };

      try {
        var r = await ApiLogin.login(m);
        if (r != null) {
          await KV.setStr(kv_user_code, _mobileCon.text);
          await KV.setStr(kv_pwd, _pwdCon.text);
          await KV.setStr(kv_jwt, r.jwt);
          await setLoginInfo(r);
          ApiBase.isGuest = false;
          CusRoutes.pushReplacement(context, HomePage());
          context.read<UserInfoState>().init(r.user_info);
          print(">>>登录成功");
        }
      } catch (e) {
        print("<<<登录出现异常：$e");
        _pwdErr = "密码错误";
        setState(() {});
      }
    } else {
      _userErr = "账号不存在";
      setState(() {});
    }
  }

  /// 手机号输入框
  Widget _mobileInput() {
    return Padding(
      padding: EdgeInsets.only(top: Adapt.px(160), bottom: Adapt.px(40)),
      child: TextField(
        controller: _mobileCon,
        keyboardType: TextInputType.phone,
        maxLength: 11,
        style: TextStyle(color: t_gray, fontSize: Adapt.px(32)),
        autofocus: true,
        decoration: InputDecoration(
          hintText: "请输入手机号",
          hintStyle: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
          errorText: _userErr,
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
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (_userErr != null) {
            _userErr = null;
          }
          setState(() {});
        },
      ),
    );
  }

  /// 密码输入框
  Widget _pwdInput() {
    return TextField(
      controller: _pwdCon,
      keyboardType: TextInputType.text,
      maxLength: 20,
      style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
      decoration: InputDecoration(
        hintText: "请输入登录密码",
        hintStyle: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
        errorText: _pwdErr,
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
        if (_userErr != null) {
          _userErr = null;
        }
        setState(() {});
      },
    );
  }

  /// 忘记密码
  Widget _forgetPwd() {
    return Container(
      padding: EdgeInsets.only(top: Adapt.px(20), bottom: Adapt.px(80)),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            child: Text(
              '忘记密码',
              style: TextStyle(fontSize: Adapt.px(24), color: t_gray),
            ),
            onTap: () =>
                CusToast.toast(context, text: '忘记密码待做', showChild: false),
          ),
        ],
      ),
    );
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
    _mobileCon.dispose();
    _pwdCon.dispose();
    super.dispose();
  }
}
