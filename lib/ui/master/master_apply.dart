import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/regex/regex_func.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
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
      padding: EdgeInsets.symmetric(horizontal: S.w(20)),
      children: <Widget>[
        SizedBox(height: S.h(5)),
        Text(
          "申请须知",
          style: TextStyle(color: t_primary, fontSize: S.sp(18)),
        ),
        Text(
          "申请成为大师前需要您已绑定手机号，已设置登录密码",
          style: TextStyle(color: t_gray, fontSize: S.sp(16), height: S.h(1.4)),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: S.h(5)),
          child: Text(
            "个人简介",
            style: TextStyle(color: t_primary, fontSize: S.sp(18)),
          ),
        ),
        CusRectField(
          controller: _briefCtrl,
          hintText: "请如实填写您的个人简介，以便我们尽快审核你的资料，限制300字以内",
          maxLines: 7,
          maxLength: 300,
          autofocus: false,
        ),
        SizedBox(height: S.h(30)),
        CusBtn(
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
      Log.info("未绑定手机号和密码");
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
          CusDialog.tip(context, title: "申请已提交，请等待审核结果");
        }
      } catch (e) {
        Navigator.pop(context);
        String tip;
        if (e.toString().contains("不能再第二次提交")) {
          tip = "你已经提交过申请，请等待审核结果";
        } else if (e.toString().contains("存在大师订单")) {
          tip = "你有未处理完的大师订单，暂无法申请";
        } else if (e.toString().contains("存在悬赏贴订单")) {
          tip = "你有未处理完的悬赏贴，暂无法申请";
        } else if (e.toString().contains("存在闪断贴订单")) {
          tip = "你有未处理完的闪断贴，暂无法申请";
        } else if (e.toString().contains("存在商城订单")) {
          tip = "你有未处理完的商城订单，暂无法申请";
        }
        if (tip != null) {
          CusDialog.tip(context, title: tip);
        }
        Log.error("uid为 ${ApiBase.uid} 申请大师出现异常：$e");
      }
    }
  }
}
