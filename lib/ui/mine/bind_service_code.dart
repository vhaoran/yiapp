import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/util/regex/regex_func.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/model/login/login_result.dart';
import 'package:yiapp/service/api/api-broker.dart';
import 'package:yiapp/service/api/api_login.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import 'package:yiapp/ui/home/home_page.dart';
import 'package:yiapp/ui/home/login_verify.dart';
import 'package:yiapp/ui/mine/personal_info/bind_usercode_pwd.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/18 19:04
// usage ：绑定邀请码
// ------------------------------------------------------

class BindSerCodePage extends StatefulWidget {
  BindSerCodePage({Key key}) : super(key: key);

  @override
  _BindSerCodePageState createState() => _BindSerCodePageState();
}

class _BindSerCodePageState extends State<BindSerCodePage> {
  var _codeCtrl = TextEditingController(); // 邀请码输入
  String _err; // 提示信息

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "绑定运营商"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
      children: <Widget>[
        SizedBox(height: 5),
        Text(
          "绑前须知",
          style: TextStyle(color: t_primary, fontSize: 17),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: RichText(
            text: TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: "1、绑定运营商前需要您已绑定手机号，已设置登录密码，若您暂未设置，请",
                  style: TextStyle(fontSize: 16, color: t_gray),
                ),
                TextSpan(
                  text: " 点此设置。",
                  style: TextStyle(fontSize: 16, color: Colors.lightBlue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      CusRoute.push(context, BindUserCodePwd());
                    },
                ),
              ],
            ),
          ),
        ),
        Text(
          "2、每个运营商都有自己的邀请码，邀请码为六位数字。",
          style: TextStyle(color: t_gray, fontSize: 17),
        ),
        SizedBox(height: 30),
        CusRectField(
          controller: _codeCtrl,
          hintText: "请输入运营商的邀请码",
          maxLength: 6,
          onlyNumber: true,
          isClear: true,
          autofocus: false,
        ),
        SizedBox(height: Adapt.px(50)),
        CusRaisedBtn(
          text: "确定",
          backgroundColor: Colors.blueGrey,
          onPressed: _verify,
        ),
      ],
    );
  }

  /// 验证
  void _verify() async {
    // 绑定前先查看手机号是否已绑定，密码是否已修改，方便绑定成功后的自动重新登录
    var user = await LoginDao(glbDB).readUserByUid();
    bool isMobile = RegexUtil.isMobile(user.user_code);
    // 没有设置手机号和密码，不满足绑定运营商条件
    if (!isMobile) {
      Log.info("未绑定手机号和密码");
      CusDialog.normal(
        context,
        title: "您暂未设置手机号和密码",
        textAgree: "现在绑定",
        fnDataApproval: "",
        onThen: () => CusRoute.push(context, BindUserCodePwd()),
      );
    }
    // 满足绑定运营商条件，可以绑定
    else {
      _err = null;
      if (_codeCtrl.text.length < 6) {
        _err = "邀请码必须是六位数字";
      }
      setState(() {});
      if (_err != null) {
        CusToast.toast(context, text: _err);
        return;
      }
      Log.info("已绑定手机号和密码，当前手机号：${user.user_code}");
      _doBind(user.user_code);
    }
  }

  /// 游客绑定邀请码
  void _doBind(String user_code) async {
    try {
      bool ok = await ApiBroker.serviceCodeBind(_codeCtrl.text.trim());
      Log.info("绑定运营商结果：$ok");
      if (ok) {
        CusToast.toast(context, text: "绑定成功，即将为你重新登录", milliseconds: 2000);
        SpinKit.threeBounce(context);
        await Future.delayed(Duration(milliseconds: 2000));
        String pwd = await KV.getStr(kv_tmp_pwd);
        var m = {"user_code": user_code, "pwd": pwd};
        LoginResult login = await ApiLogin.login(m);
        if (login != null) {
          await LoginVerify.init(login, context);
          await KV.remove(kv_tmp_pwd); // 自动登录成功后，清除本地临时密码
          Navigator.pop(context); // 退出loading页面
          CusRoute.pushReplacement(context, HomePage());
        }
      }
    } catch (e) {
      if (e.toString().contains("没有找到对应的邀请码")) {
        setState(() => _err = "不存在该邀请码");
      }
      Log.error("绑定运营商出现异常：$e");
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }
}
