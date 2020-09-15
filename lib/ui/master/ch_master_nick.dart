import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/provider/master_state.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/service/api/api-master.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/15 16:07
// usage ：修改大师昵称
// ------------------------------------------------------

class ChMasterNick extends StatefulWidget {
  final String nick;
  final int id; // 该 id 为获取大师信息中的 id，不是 uid

  ChMasterNick({this.nick, this.id, Key key}) : super(key: key);

  @override
  _ChMasterNickState createState() => _ChMasterNickState();
}

class _ChMasterNickState extends State<ChMasterNick> {
  var _nickCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(">>>这里的id:${widget.id}");
    return Scaffold(
      appBar: CusAppBar(text: "修改昵称"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return DefaultTextStyle(
      style: TextStyle(color: t_primary, fontSize: Adapt.px(30)),
      child: ListView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: Adapt.px(30)),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: Adapt.px(20)),
            child: Text("昵称"),
          ),
          // 修改昵称输入框
          CusRectField(
            controller: _nickCtrl,
            fromValue: widget.nick,
            hintText: "输入昵称",
            maxLength: 8,
          ),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(20), bottom: Adapt.px(130)),
            child: Text("限制2-8个字"),
          ),
          // 修改昵称
          CusRaisedBtn(
            text: "修改",
            onPressed: _doChNick,
          ),
        ],
      ),
    );
  }

  /// 修改大师昵称
  void _doChNick() async {
    if (_nickCtrl.text.trim() == widget.nick) {
      Navigator.pop(context);
      return;
    }
    var m = {
      "id": widget.id,
      "M": {"nick": _nickCtrl.text.trim()}
    };
    try {
      bool ok = await ApiMaster.masterInfoCh(m);
      print(">>>修改大师昵称结果：$ok");
      if (ok) {
        context.read<MasterInfoState>().chNick(_nickCtrl.text);
        CusToast.toast(context, text: "修改成功");
        Navigator.pop(context);
      }
    } catch (e) {
      print("<<<修改大师昵称出现异常：$e");
    }
  }
}
