//import 'package:fluwx/fluwx.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/provider/user_state.dart';
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
// usage ：密码登录页面(默认登录方式)
// ------------------------------------------------------

class PwdLoginPage extends StatefulWidget {
  PwdLoginPage({Key key}) : super(key: key);

  @override
  _PwdLoginPageState createState() => _PwdLoginPageState();
}

class _PwdLoginPageState extends State<PwdLoginPage> {
  String _mobile = ""; // 登录手机号
  String _pwd = ""; // 鸿运密码
  bool _waiting = false; // 是否在过渡状态
  String _userErr; // 非手机号错误提示
  String _pwdErr; // 密码错误提示
  String _wx_code = ""; // 微信code
  var _future;

  @override
  void initState() {
    _future = _restore();
//    _weChatLoginInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_waiting) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      padding: EdgeInsets.only(
          left: Adapt.px(50), right: Adapt.px(50), top: Adapt.px(60)),
      color: fif_primary,
      child: FutureBuilder(
        future: _future,
        builder: (context, snap) => _lv(),
      ),
    );
  }

  Widget _lv() {
    return ListView(
      padding: EdgeInsets.only(top: 0),
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        _register(), // 注册
        SizedBox(height: Adapt.px(160)),
//        _welcomeCt("您好,"),
//        _welcomeCt("欢迎使用《鸿运来》"),
        _mobileInput(), // 手机号输入框
        _pwdInput(), // 密码输入框
        _forgetPwd(), // 忘记密码
        CusRaisedBtn(
          text: '登录',
          fontSize: 28,
          textColor: Colors.black,
          bgColor: Color(0xFFEE9972),
          onPressed: _doLogin,
          pdVer: Adapt.px(15),
          borderRadius: 50,
        ),
        SizedBox(height: Adapt.px(30)),
        _signInWithCtr(), // 第三方登录
      ],
    );
  }

  //-------从本地载入保存的用户名及口令数据-----------------------------------------
  _restore() async {
    _mobile = await KV.getStr("/login/user_code") ?? "";
    _pwd = await KV.getStr("/login/pwd") ?? "";
    print(">>>本地的_user_code:$_mobile");
    print(">>>本地的_pwd:$_pwd");
  }

  /// 请求登录
  void _doLogin() async {
    print(">>>_user_code：$_mobile");
    print(">>>_pwd：$_pwd");
    if (_pwd.isEmpty || _mobile.isEmpty) {
      _pwdErr = "手机号或者密码不能为空";
      setState(() {});
      return;
    }
    // 鸿运号是否存在，存在再登录
    bool exist = await ApiUser.userCodeExist(_mobile);
    if (exist) {
      print(">>>存在该账号");
      var m = {
        "user_code": _mobile.trim(),
        "pwd": _pwd.trim(),
        "is_mobile": false,
        "chart_key": "aaaaa",
        "chart_value": "3333",
      };

      try {
        var r = await ApiLogin.Login(m);
        if (r != null) {
          await KV.setStr("/login/user_code", _mobile);
          await KV.setStr("/login/pwd", _pwd);
          await setLoginInfo(r);
          //------------------------------------------------
          print("-----------after setLoginInfo-----------");
          CusRoutes.push(context, HomePage());
          // Routes.toHomePage(context);
          print("-----------after toHomePage-----------");

          context.read<UserInfoState>().initUserInfo(r.user_info);
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
    return TextField(
      controller: TextEditingController.fromValue(
        TextEditingValue(
          text: _mobile,
          selection: TextSelection.fromPosition(
            TextPosition(
                affinity: TextAffinity.downstream, offset: _mobile.length),
          ),
        ),
      ),
      keyboardType: TextInputType.text,
      maxLength: 11,
      style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
      decoration: InputDecoration(
        hintText: "请输入手机号",
        hintStyle: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
        errorText: _userErr,
        errorStyle: TextStyle(fontSize: Adapt.px(26)),
        counterText: '',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black45),
        ),
      ),
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      onChanged: (value) {
        _mobile = value;
        _clearErr();
      },
    );
  }

  /// 密码输入框
  Widget _pwdInput() {
    return TextField(
      controller: TextEditingController.fromValue(
        TextEditingValue(
          text: _pwd,
          selection: TextSelection.fromPosition(
            TextPosition(
                affinity: TextAffinity.downstream, offset: _pwd.length),
          ),
        ),
      ),
      keyboardType: TextInputType.text,
      maxLength: 20,
      style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
      decoration: InputDecoration(
        hintText: "请输入登录密码",
        hintStyle: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
        errorText: _pwdErr,
        errorStyle: TextStyle(fontSize: Adapt.px(27), color: t_red),
        counterText: '',
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black45),
        ),
      ),
      onChanged: (value) {
        _pwd = value;
        _clearErr();
      },
    );
  }

  /// 第三方登录
  Widget _signInWithCtr() {
    return Container(
        padding: EdgeInsets.only(top: Adapt.screenH() / 5),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Divider(thickness: 1, height: 0, color: Colors.grey),
                ),
                Text(
                  '    第三方登录    ',
                  style: TextStyle(color: t_gray),
                ),
                Expanded(
                  child: Divider(thickness: 1, height: 0, color: Colors.grey),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(FontAwesomeIcons.weixin, color: Colors.green),
                  onPressed: () {
//              _wxLogin();
                  },
                ),
              ],
            ),
          ],
        ));
  }

  /// 忘记密码组件
  Widget _forgetPwd() {
    return Container(
      padding: EdgeInsets.only(top: Adapt.px(20), bottom: Adapt.px(80)),
      alignment: Alignment.centerRight,
      child: InkWell(
        child: Text(
          '忘记密码',
          style: TextStyle(fontSize: Adapt.px(24), color: t_gray),
        ),
        onTap: () => CusToast.toast(context, text: '忘记密码待做', showChild: false),
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

  /// 你好，欢迎使用鸿运
  Widget _welcomeCt(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: Adapt.px(34),
        fontWeight: FontWeight.w500,
        color: t_gray,
      ),
    );
  }

  /// 清空错误提示
  void _clearErr() {
    if (_userErr != null || _pwdErr != null) {
      _userErr = _pwdErr = null;
      setState(() {});
      return;
    }
  }

  /// 注册按钮
  Widget _register() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          onTap: () => CusRoutes.push(context, RegUserPage()),
          child: Text(
            "新用户注册",
            style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
          ),
        ),
      ],
    );
  }
}
