import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/complex/widgets/small/cus_loading.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/service/api/api_base.dart';

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
        Padding(
          padding: EdgeInsets.only(top: Adapt.px(30), bottom: Adapt.px(20)),
          child: CusText("个人简介", t_primary, 30),
        ),
        CusRectField(
          controller: _briefCtrl,
          errorText: _err,
          pdHor: 20,
          maxLines: 7,
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
    if (_briefCtrl.text.isEmpty) {
      _err = "个人简介不能为空";
      setState(() {});
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
