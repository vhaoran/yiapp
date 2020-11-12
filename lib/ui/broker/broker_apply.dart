import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/complex/widgets/small/cus_loading.dart';
import 'package:yiapp/model/dicts/broker-apply.dart';
import 'package:yiapp/service/api/api-broker.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/14 10:10
// usage ：申请成为代理
// ------------------------------------------------------

class ApplyBrokerPage extends StatefulWidget {
  ApplyBrokerPage({Key key}) : super(key: key);

  @override
  _ApplyBrokerPageState createState() => _ApplyBrokerPageState();
}

class _ApplyBrokerPageState extends State<ApplyBrokerPage> {
  var _nameCtrl = TextEditingController(); // 设置代理名称
  var _serCodeCtrl = TextEditingController(); // 设置服务代码
  var _briefCtrl = TextEditingController(); // 设置简介
  String _nameErr; // 代理提示信息
  String _serCodeErr; // 服务代码提示信息
  String _briefErr; // 简介提示信息

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "申请代理"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    double space = Adapt.px(60);
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
      children: <Widget>[
        SizedBox(height: Adapt.px(60)),
        CusRectField(
          controller: _nameCtrl,
          hintText: "输入代理名称",
          errorText: _nameErr,
        ),
        SizedBox(height: space),
        CusRectField(
          controller: _serCodeCtrl,
          hintText: "输入六位数的服务代码",
          errorText: _serCodeErr,
          onlyNumber: true,
          maxLines: 6,
        ),
        SizedBox(height: space),
        CusRectField(
          controller: _briefCtrl,
          hintText: "自我简介",
          errorText: _briefErr,
          maxLines: 8,
        ),
        SizedBox(height: space),
        CusRaisedBtn(
          text: "我要申请",
          backgroundColor: Colors.blueGrey,
          onPressed: _doApply,
        ),
      ],
    );
  }

  /// 代理申请
  void _doApply() async {
    if (ApiState.isBrokerAdmin) {
      CusDialog.tip(context,
          title: "您已经是代理了", onApproval: () => Navigator.pop(context));
      return;
    }
    setState(() {
      // 验证输入内容
      _nameErr = _nameCtrl.text.isEmpty ? "代理名称不能为空" : null;
      if (_nameErr != null) return false;
      _serCodeErr = _serCodeCtrl.text.isEmpty ? "服务代码不能为空" : null;
      if (_serCodeErr != null) return false;
      _briefErr = _briefCtrl.text.isEmpty ? "自我简介不能为空" : null;
      if (_briefErr != null) return false;
    });
    // 符合要求
    if (_nameErr == null && _serCodeErr == null && _briefErr == null) {
      SpinKit.threeBounce(context);
      var m = {
        "name": _nameCtrl.text.trim(),
        "service_code": _serCodeCtrl.text.trim(),
        "brief": _briefCtrl.text.trim(),
      };
      try {
        BrokerApply res = await ApiBroker.brokerApplyHandIn(m);
        Debug.log("申请成为代理结果详情：${res.toJson()}");
        if (res != null) {
          Navigator.pop(context);
          CusDialog.tip(context, title: "申请已提交，请等待审核结果", onApproval: () {
            Navigator.pop(context);
          });
        }
      } catch (e) {
        Debug.logError("申请代理出现异常：$e");
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _serCodeCtrl.dispose();
    _briefCtrl.dispose();
    super.dispose();
  }
}
