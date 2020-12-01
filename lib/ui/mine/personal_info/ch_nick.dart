import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/ui/provider/user_state.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import '../../../service/api/api_user.dart';

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
            child: Text("最多8个字"),
          ),
          // 修改昵称
          CusRaisedBtn(text: "修改", onPressed: _chNick),
        ],
      ),
    );
  }

  /// 修改用户昵称
  void _chNick() async {
    if (_nickCtrl.text.isEmpty) {
      CusToast.toast(context, text: "昵称不能为空");
      return;
    }
    var m = {"nick": _nickCtrl.text};
    try {
      bool ok = await ApiUser.ChUserInfo(m);
      Log.info("修改用户昵称结果：$ok");
      if (ok) {
        context.read<UserInfoState>().chNick(_nickCtrl.text);
        bool update = await LoginDao(glbDB).updateNick(_nickCtrl.text);
        Log.info("本地更改存储nick结果：$update");
        if (update) {
          CusToast.toast(context, text: "修改成功");
          Navigator.pop(context);
        }
      }
    } catch (e) {
      Log.error("修改用户昵称出现异常：$e");
    }
  }
}
