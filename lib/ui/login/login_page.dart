import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/under_field.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/model/login/cus_login_res.dart';
import 'package:yiapp/model/login/login_result.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_login.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import 'package:yiapp/ui/home/home_page.dart';
import 'package:yiapp/ui/home/login_verify.dart';
import '../../service/api/api_user.dart';
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
  var _future;
  bool _hidePwd = true; // 是否隐藏密码，默认隐藏
  bool _expand = false; // 是否展示历史账号
  GlobalKey _globalKey = GlobalKey(); //用来标记控件
  // 所有登录用户(不包括游客，默认游客账户可用游客登录功能)，用于切换账号
  List<SqliteLoginRes> _l = [];
  SqliteLoginRes _curLogin; // 当前登录用户

  @override
  void initState() {
    _future = _loadData();
    super.initState();
  }

  _loadData() async {
    try {
      /// 获取所有用户信息
      var l = await LoginDao(glbDB).readAll();
      if (l != null && l.isNotEmpty) {
        // 去掉游客账号
        _l = l.where((e) => !e.user_code.contains("guest")).toList();
        // 默认加载上次登录的账号（不算游客）
        var res = await LoginDao(glbDB).readUserByUid();
        if (!res.user_code.contains("guest") && res != null) {
          _curLogin = res;
        }
      }
    } catch (e) {
      Log.error("登录页面获取用户信息出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: CusAppBar(
        showLeading: false,
        backGroundColor: fif_primary,
        actions: <Widget>[_registerBtn()],
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return _lv();
        },
      ),
      backgroundColor: fif_primary,
    );
  }

  Widget _lv() {
    final double space = S.w(25);
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: space),
          child: Flex(
            direction: Axis.vertical,
            children: [
              SizedBox(height: S.h(60)),
              // 手机号输入框
              CusUnderField(
                controller: _mobileCtrl,
                hintText: "请输入用户名",
                fromValue: _curLogin == null ? null : _curLogin.user_code,
                errorText: _mobileErr,
                isClear: false,
                key: _globalKey,
                suffixIcon: InkWell(
                  onTap: () {
                    // 如果账号个数大于1或者唯一一个账号跟当前账号不一样才弹出历史账号
                    if (_l.length > 1 ||
                        (_l.length == 1 && _l.first.uid != _curLogin.uid)) {
                      _expand = !_expand;
                      setState(() {});
                    }
                  },
                  child: _expand
                      ? Icon(Icons.arrow_drop_up, color: Colors.red)
                      : Icon(Icons.arrow_drop_down, color: Colors.grey),
                ),
              ),
              SizedBox(height: Adapt.px(50)),
              // 密码输入框
              CusUnderField(
                controller: _pwdCtrl,
                hintText: "请输入登录密码",
                errorText: _pwdErr,
                fromValue: "123456",
                isClear: false,
                obscureText: _hidePwd,
                suffixIcon: InkWell(
                  onTap: () => setState(() => _hidePwd = !_hidePwd),
                  child: Icon(
                    Icons.remove_red_eye,
                    color: _hidePwd ? Colors.grey : Colors.lightBlue,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // 游客登录
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        '游客登录',
                        style: TextStyle(fontSize: Adapt.px(24), color: t_gray),
                      ),
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
              Container(
                width: S.screenW() - 2 * space,
                child: CusRaisedButton(
                  child: Text("登录"),
                  onPressed: _doLogin,
                  borderRadius: 50,
                  backgroundColor: Color(0xFFEE9972),
                ),
              ),
            ],
          ),
        ),
        Offstage(
          child: _buildListView(),
          offstage: !_expand,
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
        SqliteLoginRes res = await LoginDao(glbDB).readGuest();
        if (ApiBase.jwt == res.jwt) {
          // 直接跳转到首页即可，无须更换账号
          Log.info("目前登录的就是游客账号");
        } else {
          Log.info("切换账号");
          LoginVerify.init(LoginResult.from(res), context);
        }
        SpinKit.threeBounce(context, text: "正在登录，请稍等...");
        await Future.delayed(Duration(milliseconds: 1000));
        Navigator.pop(context);
        CusRoute.pushReplacement(context, HomePage());
      },
    );
  }

  /// 请求登录
  void _doLogin() async {
    Log.info("当前登录信息：账号：${_mobileCtrl.text} 密码：${_pwdCtrl.text}");
    if (_mobileCtrl.text.trim().isEmpty || _pwdCtrl.text.trim().isEmpty) {
      CusToast.toast(context, text: "账号或者密码不能为空");
      return;
    }
    setState(() {
      _mobileErr = _pwdErr = null;
    });
    LoginResult login; // 最终传递的登录结果
    // 在登录界面登录鸿运来，直接请求即可，不需要判断本地数据库是否已存在，否则无法保证数据最新
    try {
      bool exist = await ApiUser.userCodeExist(_mobileCtrl.text);
      if (exist) {
        Log.info("存在该账号");
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
            CusRoute.pushReplacement(context, HomePage());
          }
        } catch (e) {
          Log.error("登录出现异常：$e");
          _pwdErr = "密码错误";
          setState(() {});
        }
      } else {
        _mobileErr = "账号不存在";
        setState(() {});
      }
    } catch (e) {
      Log.error("判断用户是否存在出现异常：$e");
    }
  }

  /// 注册按钮
  Widget _registerBtn() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(right: Adapt.px(30)),
      child: InkWell(
        onTap: () => CusRoute.push(context, RegisterPage()),
        child: Text(
          "新用户注册",
          style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
        ),
      ),
    );
  }

  ///构建历史账号ListView
  Widget _buildListView() {
    if (_expand) {
      List<Widget> children = _buildItems();
      if (children.length > 0) {
        RenderBox renderObject = _globalKey.currentContext.findRenderObject();
        final position = renderObject.localToGlobal(Offset.zero);
        double screenW = MediaQuery.of(context).size.width;
        double currentW = renderObject.paintBounds.size.width;
        // double currentH = renderObject.paintBounds.size.height;
        double margin = (screenW - currentW) / 2;
        double offsetY = position.dy;
        double itemHeight = 45;
        double dividerHeight = 0;
        return Container(
          decoration: BoxDecoration(
            color: tip_bg,
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Colors.lightBlue, width: 2),
          ),
          child: ListView(itemExtent: itemHeight, children: children),
          width: currentW,
          height: (children.length * itemHeight +
              (children.length - 1) * dividerHeight),
          margin: EdgeInsets.fromLTRB(
              margin, offsetY - itemHeight + S.h(20), margin, 0),
        );
      }
    }
    return null;
  }

  /// 构建历史记录items
  List<Widget> _buildItems() {
    List<Widget> list = List();
    for (int i = 0; i < _l.length; i++) {
      list.add(InkWell(
        onTap: () {
          setState(() {
            _mobileCtrl.text = _l[i].user_code;
            _expand = false;
            // 选择完账号后，光标移动到最后
            _mobileCtrl.selection = TextSelection.fromPosition(
              TextPosition(offset: _mobileCtrl.text.length),
            );
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Color(0XFF302F4F), width: 0)),
          ),
          padding: EdgeInsets.only(left: S.w(10)),
          alignment: Alignment.centerLeft,
          child: Text(_l[i].nick, style: TextStyle(fontSize: S.sp(16))),
        ),
      ));
    }
    return list;
  }

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }
}
