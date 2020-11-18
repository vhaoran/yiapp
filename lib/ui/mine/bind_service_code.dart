import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_reg.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/login/login_page.dart';
import 'package:yiapp/model/login/cus_login_res.dart';
import 'package:yiapp/service/api/api-broker.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import 'package:yiapp/ui/mine/personal_info/bind_usercode_pwd.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/18 19:04
// usage ：绑定推荐码(由代理提供)
// ------------------------------------------------------

class BindSerCodePage extends StatefulWidget {
  BindSerCodePage({Key key}) : super(key: key);

  @override
  _BindSerCodePageState createState() => _BindSerCodePageState();
}

class _BindSerCodePageState extends State<BindSerCodePage> {
  var _codeCtrl = TextEditingController(); // 推荐码输入
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
                  style: TextStyle(fontSize: 17, color: t_gray),
                ),
                TextSpan(
                  text: " 点此设置。",
                  style: TextStyle(fontSize: 17, color: Colors.lightBlue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      CusRoutes.push(context, BindUserCodePwd());
                    },
                ),
              ],
            ),
          ),
        ),
        Text(
          "2、每个运营商都有自己的推荐码，推荐码为六位数字。",
          style: TextStyle(color: t_gray, fontSize: 17),
        ),
        SizedBox(height: 30),
        CusRectField(
          controller: _codeCtrl,
          hintText: "请输入推荐码",
          errorText: _err,
          maxLength: 6,
          onlyNumber: true,
          isClear: true,
          autofocus: false,
        ),
        SizedBox(height: Adapt.px(50)),
        CusRaisedBtn(
          text: "确定",
          backgroundColor: Colors.blueGrey,
          onPressed: _doBind,
        ),
      ],
    );
  }

  /// 游客绑定推荐码
  void _doBind() async {
    // 绑定前先查看手机号是否已绑定，密码是否已修改，为了后面的重新登录做准备
    CusLoginRes res = await LoginDao(glbDB).readUserByUid();
    bool isMobile = CusRegExp.phone(res.user_code);
    if (!isMobile) {}
    print(">>>当前手机号：${res.user_code}");
    // 可以绑定
    if (isMobile) {
      setState(() {
        _err = null;
        if (_codeCtrl.text.isEmpty) {
          _err = "推荐码不能为空";
        } else if (_codeCtrl.text.length < 6) {
          _err = "推荐码必须是六位数字";
        }
      });
      if (_err != null) return;
      try {
        bool ok = await ApiBroker.serviceCodeBind(_codeCtrl.text.trim());
        Debug.log("绑定代理结果：$ok");
        if (ok) {
          CusToast.toast(context, text: "绑定成功，请重新登录", milliseconds: 1500);
          CusRoutes.push(context, LoginPage());
        }
      } catch (e) {
        if (e.toString().contains("没有找到对应的推荐码")) {
          setState(() => _err = "不存在该推荐码");
        }
        Debug.logError("绑定代理出现异常：$e");
      }
    }
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
  }
}
