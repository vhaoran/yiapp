import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_int.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/service/api/api-master.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/18 14:08
// usage ：启用/停用大师
// ------------------------------------------------------

class MasterEnable extends StatefulWidget {
  MasterEnable({Key key}) : super(key: key);

  @override
  _MasterEnableState createState() => _MasterEnableState();
}

class _MasterEnableState extends State<MasterEnable> {
  var _masterCtrl = TextEditingController();
  String _err; // 错误提示信息
  int _stat = m_enable; // 0 停用，1 启用

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "大师权限"),
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
          padding: EdgeInsets.only(top: Adapt.px(80), bottom: Adapt.px(60)),
          child: CusRectField(
            controller: _masterCtrl, // 大师 id 输入框
            hintText: "请输入大师 id",
            errorText: _err,
            formatter: true,
            fontSize: 32,
          ),
        ),
        Row(
          children: <Widget>[
            _selectCtr(m_enable, "启用"),
            SizedBox(width: Adapt.px(20)),
            _selectCtr(m_disable, "停用"),
          ],
        ),
        SizedBox(height: Adapt.px(80)),
        CusRaisedBtn(
          backgroundColor: Colors.blueGrey,
          borderRadius: 100,
          onPressed: _doSet, // 确定按钮
        ),
      ],
    );
  }

  /// 启用/停用大师
  void _doSet() async {
    if (_masterCtrl.text.isEmpty) {
      setState(() => _err = "大师 id 不能为空");
      return;
    }
    num id = num.parse(_masterCtrl.text);
    try {
      bool ok = await ApiMaster.masterSetEnable(id, _stat);
      String tip = _stat == 0 ? "禁用" : "启用";
      Debug.log("$tip大师结果：$ok");
      if (ok) {
        CusToast.toast(context, text: "$tip成功");
        Navigator.pop(context);
      }
    } catch (e) {
      Debug.logError("出现异常：$e");
    }
  }

  Widget _selectCtr(int value, String text) {
    return Row(
      children: <Widget>[
        Radio(
          value: value,
          groupValue: _stat,
          activeColor: t_ji,
          onChanged: (val) => setState(() => _stat = val),
        ),
        CusText(text, t_gray, 28),
      ],
    );
  }

  @override
  void dispose() {
    _masterCtrl.dispose();
    super.dispose();
  }
}
