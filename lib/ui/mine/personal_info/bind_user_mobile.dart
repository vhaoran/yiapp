import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/ui/provider/user_state.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/util/regex/regex_func.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_button.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/flutter/rect_field.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/service/api/api_user.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/10 17:06
// usage ：绑定手机号
// ------------------------------------------------------

class BindUserMobile extends StatefulWidget {
  BindUserMobile({Key key}) : super(key: key);

  @override
  _BindUserMobileState createState() => _BindUserMobileState();
}

class _BindUserMobileState extends State<BindUserMobile> {
  var _mobileCtrl = TextEditingController(); // 绑定的手机号
  String _err; // 错误提示信息

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "绑定手机号"),
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
          SizedBox(height: Adapt.px(60)),
          CusRectField(
            controller: _mobileCtrl,
            hintText: "输入手机号",
            errorText: _err,
            prefixText: "+86  ",
            keyboardType: TextInputType.phone,
            onlyNumber: true,
            isClear: true,
            maxLength: 11,
          ),
          SizedBox(height: Adapt.px(80)),
          // 修改昵手机号
          CusBtn(text: "修改", onPressed: _chMobile),
        ],
      ),
    );
  }

  /// 绑定用户手机号
  void _chMobile() async {
    _err = null;
    if (_mobileCtrl.text.isEmpty || !RegexUtil.isMobile(_mobileCtrl.text)) {
      _err = "请输入正确的手机号";
      setState(() {});
      return;
    }
    if (_err == null) {
      SpinKit.threeBounce(context);
      var m = {"user_code": _mobileCtrl.text.trim()};
      try {
        bool ok = await ApiUser.ChUserInfo(m);
        Log.info("绑定手机号结果：$ok");
        if (ok) {
          Navigator.pop(context);
          context.read<UserInfoState>()?.chUserCode(_mobileCtrl.text);
          bool update = await LoginDao(glbDB).updateUserCode(_mobileCtrl.text);
          if (update) {
            CusToast.toast(context, text: "绑定成功");
            Navigator.pop(context);
          }
        }
      } catch (e) {
        Log.error("绑定用户手机号出现异常：$e");
      }
    }
  }

  @override
  void dispose() {
    _mobileCtrl.dispose();
    super.dispose();
  }
}
