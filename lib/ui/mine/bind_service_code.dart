import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/service/api/api-broker.dart';

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
  var _codeCtrl = TextEditingController(); // 设置推荐码
  String _err; // 提示信息

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "绑定代理"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: Adapt.px(40), bottom: Adapt.px(25)),
          child: CusText("输入推荐码", t_primary, 30),
        ),
        CusRectField(
          controller: _codeCtrl,
          errorText: _err,
          onlyNumber: true,
        ),
        SizedBox(height: Adapt.px(90)),
        CusRaisedBtn(
          text: "绑定",
          backgroundColor: Colors.blueGrey,
          onPressed: _doBind,
        ),
      ],
    );
  }

  /// 绑定推荐码
  void _doBind() async {
    if (ApiState.isBroker) {
      CusDialog.tip(context,
          title: "您已经绑定过代理了", onApproval: () => Navigator.pop(context));
      return;
    }
    setState(() {
      _err = _codeCtrl.text.isEmpty ? "推荐码不能为空" : null;
      if (_err != null) return;
    });
    if (_err == null) {
      try {
        bool ok = await ApiBroker.serviceCodeBind(_codeCtrl.text.trim());
        Debug.log("绑定代理结果：$ok");
        if (ok) {
          CusToast.toast(context, text: "绑定成功");
          Navigator.pop(context);
        }
      } catch (e) {
        if (e.toString().contains("没有找到对应的推荐码")) {
          setState(() => _err = "不存在该推荐码");
        }
        Debug.logError("绑定代理出现异常：$e");
      }
    }
  }
}
