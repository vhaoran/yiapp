import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/provider/user_state.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import '../../../service/api/api_user.dart';
import 'package:provider/provider.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/7 17:59
// usage ：修改用户昵称
// ------------------------------------------------------

class ChUserNick extends StatefulWidget {
  final String nick;

  ChUserNick({this.nick, Key key}) : super(key: key);

  @override
  _ChUserNickState createState() => _ChUserNickState();
}

class _ChUserNickState extends State<ChUserNick> {
  var _nickCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          _chNick(),
        ],
      ),
    );
  }

  /// 修改用户昵称
  Widget _chNick() {
    return CusRaisedBtn(
      text: "修改",
      onPressed: () async {
        var m = {"nick": _nickCtrl.text};
        try {
          bool ok = await ApiUser.ChUserInfo(m);
          print(">>>修改用户昵称结果：$ok");
          if (ok) {
            context.read<UserInfoState>().chNick(_nickCtrl.text);
            CusToast.toast(context, text: "修改成功");
            Navigator.pop(context);
          }
        } catch (e) {
          print("<<<修改用户昵称出现异常：$e");
        }
      },
    );
  }
}
