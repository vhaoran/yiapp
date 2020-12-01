import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/util/regex/regex_func.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/model/dicts/broker-apply.dart';
import 'package:yiapp/service/api/api-broker.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import 'package:yiapp/ui/mine/personal_info/bind_usercode_pwd.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 10:10
// usage ：申请成为运营商
// ------------------------------------------------------

class ApplyBrokerPage extends StatefulWidget {
  ApplyBrokerPage({Key key}) : super(key: key);

  @override
  _ApplyBrokerPageState createState() => _ApplyBrokerPageState();
}

class _ApplyBrokerPageState extends State<ApplyBrokerPage> {
  var _nameCtrl = TextEditingController(); // 运营商名称
  var _codeCtrl = TextEditingController(); // 邀请码
  var _briefCtrl = TextEditingController(); // 运营商简介
  String _err; // 错误提示信息

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "申请运营商"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 15),
      children: <Widget>[
        SizedBox(height: 5),
        Text(
          "申请须知",
          style: TextStyle(color: t_primary, fontSize: 17),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: RichText(
            text: TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: "1、申请成为运营商前需要您已绑定手机号，已设置登录密码，若您暂未设置，请",
                  style: TextStyle(fontSize: 16, color: t_gray),
                ),
                TextSpan(
                  text: " 点此设置",
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
          "2、邀请码为自定义的 6 位数字，用户通过邀请码绑定对应运营商",
          style: TextStyle(fontSize: 16, color: t_gray),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "申请信息",
            style: TextStyle(color: t_primary, fontSize: 17),
          ),
        ),
        CusRectField(
          controller: _nameCtrl,
          hintText: "输入运营商名称",
          maxLength: 8,
          onlyChinese: true,
          autofocus: false,
        ),
        SizedBox(height: 15),
        CusRectField(
          controller: _codeCtrl,
          hintText: "输入邀请码",
          onlyNumber: true,
          maxLength: 6,
          autofocus: false,
        ),
        SizedBox(height: 20),
        CusRectField(
          controller: _briefCtrl,
          hintText: "请如实填写您的个人简介，以便我们尽快审核你的资料，限制300字以内",
          maxLines: 8,
          maxLength: 300,
          autofocus: false,
        ),
        SizedBox(height: 20),
        CusRaisedBtn(
          text: "我要申请",
          backgroundColor: Colors.blueGrey,
          onPressed: _verify,
        ),
      ],
    );
  }

  /// 申请运营商前的验证
  void _verify() async {
    // 如果已经是运营商，不能再次申请
    if (CusRole.is_broker_admin) {
      CusDialog.tip(context,
          title: "您已经是运营商", onApproval: () => Navigator.pop(context));
      return;
    }
    // 申请前先查看手机号是否已绑定，密码是否已修改
    var user = await LoginDao(glbDB).readUserByUid();
    bool isMobile = RegexUtil.isMobile(user.user_code);
    // 没有设置手机号和密码
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
    // 已设置手机号和密码
    else {
      setState(() {
        _err = null;
        // 验证输入内容
        if (_nameCtrl.text.isEmpty)
          _err = "运营商名称不能为空";
        else if (_codeCtrl.text.length < 6)
          _err = "邀请码必须为 6 位数字";
        else if (_briefCtrl.text.isEmpty) _err = "自我简介不能为空";
      });
      // 不符合要求
      if (_err != null) {
        CusToast.toast(context, text: _err);
        return;
      }
      // 符合要求，开始申请运营商
      _doApply();
    }
  }

  /// 运营商申请
  void _doApply() async {
    var m = {
      "name": _nameCtrl.text.trim(),
      "service_code": _codeCtrl.text.trim(),
      "brief": _briefCtrl.text.trim(),
    };
    try {
      BrokerApply res = await ApiBroker.brokerApplyHandIn(m);
      Log.info("申请成为运营商结果详情：${res.toJson()}");
      if (res != null) {
        SpinKit.threeBounce(context);
        await Future.delayed(Duration(milliseconds: 1000));
        Navigator.pop(context);
        CusDialog.tip(context, title: "申请已提交，请等待审核结果", onApproval: () {
          Navigator.pop(context);
        });
      }
    } catch (e) {
      Log.error("申请运营商出现异常：$e");
      setState(() {
        if (e.toString().contains("已存在对代理名称的申请")) {
          _err = "运营商名称已被占用";
        } else if (e.toString().contains("已存在对服务代码申请")) {
          _err = "邀请码已被占用";
        }
        CusToast.toast(context, text: _err);
        return;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _briefCtrl.dispose();
    super.dispose();
  }
}
