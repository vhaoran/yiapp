import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/util/regex/regex_func.dart';
import 'package:yiapp/func/cus_route.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/complex/widgets/small/cus_loading.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import 'package:yiapp/ui/mine/personal_info/bind_usercode_pwd.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 10:04
// usage ：申请成为大师
// ------------------------------------------------------

class ApplyMasterPage extends StatefulWidget {
  ApplyMasterPage({Key key}) : super(key: key);

  @override
  _ApplyMasterPageState createState() => _ApplyMasterPageState();
}

class _ApplyMasterPageState extends State<ApplyMasterPage> {
  var _briefCtrl = TextEditingController(); // 个人简介
  String _err; // 错误提示信息

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "申请大师"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(40)),
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
                  text: "申请成为大师前需要您已绑定手机号，已设置登录密码，若您暂未设置，请",
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
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: CusText("个人简介", t_primary, 30),
        ),
        CusRectField(
          controller: _briefCtrl,
          hintText: "请如实填写您的个人简介，以便我们尽快审核你的资料，限制300字以内",
          pdHor: 20,
          maxLines: 7,
          maxLength: 300,
          autofocus: false,
        ),
        SizedBox(height: Adapt.px(60)),
        CusRaisedBtn(
          text: "我要申请",
          backgroundColor: Colors.blueGrey,
          onPressed: _doApply,
        ),
      ],
    );
  }

  /// 大师申请
  void _doApply() async {
    // 申请前先查看手机号是否已绑定，密码是否已修改
    var user = await LoginDao(glbDB).readUserByUid();
    bool isMobile = RegexUtil.isMobile(user.user_code);
    // 没有设置手机号和密码
    if (!isMobile) {
      Debug.log("未绑定手机号和密码");
      CusDialog.normal(
        context,
        title: "您暂未设置手机号和密码",
        textAgree: "现在绑定",
        fnDataApproval: "",
        onThen: () => CusRoute.push(context, BindUserCodePwd()),
      );
    } else {
      setState(() {
        _err = null;
        if (_briefCtrl.text.isEmpty) {
          _err = "个人简介不能为空";
        }
      });
      if (_err != null) {
        CusToast.toast(context, text: _err);
        return;
      }
      SpinKit.threeBounce(context);
      var m = {
        "info": {
          "uid": ApiBase.uid,
          "brief": _briefCtrl.text.trim(),
        },
      };
      try {
        String res = await ApiMaster.masterInfoApplyHandIn(m);
        if (res != null && res.isNotEmpty) {
          Navigator.pop(context);
          CusDialog.tip(context, title: "申请已提交，请等待审核结果", onApproval: () {
            Navigator.pop(context);
          });
        }
      } catch (e) {
        if (e.toString().contains("不能再第二次提交")) {
          CusDialog.tip(context, title: "您已经提交过申请，请等待审核结果", onApproval: () {
            Navigator.pop(context);
          });
        }
        Debug.logError("uid为 ${ApiBase.uid} 申请大师出现异常：$e");
      }
    }
  }
}
