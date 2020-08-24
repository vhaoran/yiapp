//import 'package:fluwx/fluwx.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/provider/user_state.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/service/login/login_utils.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/service/api/api_login.dart';
import 'package:yiapp/service/api/api_user.dart';
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
        _mobileInput(), // 手机号输入框
        _pwdInput(), // 密码输入框
        _forgetPwd(), // 忘记密码
        CusRaisedBtn(
          text: '登录',
          fontSize: 28,
          textColor: Colors.black,
          backgroundColor: Color(0xFFEE9972),
          onPressed: _doLogin,
          pdVer: Adapt.px(15),
          borderRadius: 50,
        ),
        // _signInWithCtr(), // 第三方登录
      ],
    );
  }

  //-------从本地载入保存的用户名及口令数据-----------------------------------------
//  _restore() async {
//    _mobile = await KV.getStr("/login/user_code") ?? "";
//    _pwd = await KV.getStr("/login/pwd") ?? "";
//    print(">>>本地的_user_code:$_mobile");
//    print(">>>本地的_pwd:$_pwd");
//  }

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
          CusRoutes.pushReplacement(context, HomePage());
          context.read<UserInfoState>().init(r.user_info);
          print(">>>登录成功");
        }
      } catch (e) {
        print("*****${e.tloString()}");
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
          focusedBorder: inputBorder(),
          errorBorder: inputBorder(),
          focusedErrorBorder: inputBorder(),
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
        focusedBorder: inputBorder(),
        errorBorder: inputBorder(),
        focusedErrorBorder: inputBorder(),
      ),
      onChanged: (value) {
        if (_userErr != null) {
          _userErr = null;
        }
        setState(() {});
      },
    );
  }

  /// 第三方登录
//  Widget _signInWithCtr() {
//    return Container(
//        padding: EdgeInsets.only(top: Adapt.screenH() / 5),
//        child: Column(
//          children: <Widget>[
//            Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Expanded(
//                  child: Divider(thickness: 1, height: 0, color: Colors.grey),
//                ),
//                Text(
//                  '    第三方登录    ',
//                  style: TextStyle(color: t_gray),
//                ),
//                Expanded(
//                  child: Divider(thickness: 1, height: 0, color: Colors.grey),
//                ),
//              ],
//            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                IconButton(
//                  icon: Icon(FontAwesomeIcons.weixin, color: Colors.green),
//                  onPressed: () {
////              _wxLogin();
//                  },
//                ),
//              ],
//            ),
//          ],
//        ));
//  }

  /// 忘记密码组件
  Widget _forgetPwd() {
    return Container(
      padding: EdgeInsets.only(top: Adapt.px(20), bottom: Adapt.px(80)),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
//          InkWell(
//            child: Text(
//              '游客登录',
//              style: TextStyle(fontSize: Adapt.px(24), color: t_gray),
//            ),
//            onTap: () {
//              CusDialog.normal(
//                context,
//                title: "登录提示",
//                textAgree: "登录",
//                subTitle: "游客登录方式仅供用户体验使用，无法保证您的账号安全，可能存在账号丢失的风险，建议使用其它登录方式",
//                onApproval: () {
//                  print(">>>dianle");
////                  CusRoutes.pushReplacement(context, RegisterPage());
//                  CusRoutes.push(context, LoginPage());
//                  print(">>>fdfddaf11");
//                },
//              );
//            },
//          ),
          SizedBox(width: Adapt.px(40)),
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

  //------weChat Login------------------------------------------
//  _weChatLoginInit() {
//    final String APP_ID = "wx1a5150d9e8cd17f2";
//    registerWxApi(appId: APP_ID);
//    //add listener
//    weChatResponseEventHandler.distinct((a, b) => a == b).listen((ret) {
//      if (!(ret is WeChatAuthResponse)) {
//        _waiting = false;
//        return;
//      }
//      var res = ret as WeChatAuthResponse;
//      _wx_code = res.code;
//      print("state :${res.state} \n code:${res.code}");
//      print("state :${(res as WeChatAuthResponse).toString()} ");
//      if (_wx_code.length > 0) {
//        ApiLogin.WXLogin(_wx_code).then((v) {
//          print("#### loginResult ${v.toJson().toString()}");
//          setLoginInfo(v).then((b) {
////            Routes.toHomePage(context);
//            CusRoutes.push(context, HomePage());
//          }).catchError((e) {
//            setState(() {
//              _waiting = false;
//            });
//            CusDialog.err(context, title: '微信登录出错', subTitle: '$e');
//          });
//        }).catchError((e) {
//          setState(() {
//            _waiting = false;
//          });
//          CusDialog.err(context, title: '微信登录出错', subTitle: '$e');
//        });
//      }
//    });
//  }

  /// 登录微信
//  void _wxLogin() async {
//    print(">>>dddd");
//    var b = await sendWeChatAuth(
//        scope: "snsapi_userinfo", state: "wechat_sdk_demo_test");
//    setState(() {
//      _waiting = true;
//    });
//  }

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
