import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/complex/provider/user_state.dart';
import 'package:yiapp/complex/tools/su_regexp.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/flutter/rect_field.dart';
import 'package:yiapp/service/api/api_user.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/18 19:23
// usage ：游客身份时，设置手机号和密码
// ------------------------------------------------------

class BindUserCodePwd extends StatefulWidget {
  BindUserCodePwd({Key key}) : super(key: key);

  @override
  _BindUserCodePwdState createState() => _BindUserCodePwdState();
}

class _BindUserCodePwdState extends State<BindUserCodePwd> {
  var _mobileCtrl = TextEditingController();
  var _pwdCtrl = TextEditingController();
  String _err; // 弹框提示错误信息
  String _mobileErr; // 手机号错误提示

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "设置手机号、密码"),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 25),
        children: <Widget>[
          SizedBox(height: 40),
          CusRectField(
            controller: _mobileCtrl,
            hintText: "请输入手机号",
            errorText: _mobileErr,
            onlyNumber: true,
            isClear: true,
            maxLength: 11,
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, bottom: 40),
            child: CusRectField(
              controller: _pwdCtrl,
              hintText: "设置登录密码 (6-20位大小写字母)",
              onlyLetter: true,
              isClear: true,
              maxLength: 20,
            ),
          ),
          CusRaisedBtn(
            text: "确定",
            onPressed: _verify,
            backgroundColor: Colors.blueGrey,
          ),
        ],
      ),
    );
  }

  /// 验证设置条件、检测手机号存在性
  void _verify() async {
    // 判断是否已绑定过手机号和密码
    var user = await LoginDao(glbDB).readUserByUid();
    if (await SuRegExp.isMobile(user.user_code)) {
      CusDialog.tip(
        context,
        title: "您已绑定过手机号和密码",
        onApproval: () => Navigator.pop(context),
      );
    } else {
      setState(() {
        _err = _mobileErr = null;
        if (!SuRegExp.isMobile(_mobileCtrl.text)) {
          _err = "请输入正确的手机号";
        } else if (_pwdCtrl.text.length < 6) {
          _err = "密码最少6位";
        }
      });
      if (_err != null) {
        CusToast.toast(context, text: _err);
        return;
      }
      // 如果满足设置条件，则先验证用户名(手机号)存在性
      try {
        bool exist = await ApiUser.userCodeExist(_mobileCtrl.text);
        if (exist) {
          _mobileErr = "当前手机号已存在";
          setState(() {});
        } else {
          _doBind();
        }
      } catch (e) {
        Debug.logError("设置用户手机号、密码出现异常：$e");
      }
    }
  }

  void _doBind() async {
    var m = {"user_code": _mobileCtrl.text, "pwd": _pwdCtrl.text};
    try {
      bool success = await ApiUser.bindUserCodeAndPwd(m);
      if (success) {
        CusToast.toast(context, text: "设置成功");
        // 临时将输入的密码保存到本地，方便后面自动重新登录
        bool ok = await KV.setStr(kv_tmp_pwd, _pwdCtrl.text);
        Debug.log("存储本地临时pwd结果：$ok");
        if (ok) {
          context.read<UserInfoState>()?.chUserCode(_mobileCtrl.text);
          bool update = await LoginDao(glbDB).updateUserCode(_mobileCtrl.text);
          Debug.log("更新本地手机号结果：$update");
          Navigator.pop(context);
        }
      }
    } catch (e) {
      Debug.logError("设置手机号和密码出现异常：$e");
    }
  }

  @override
  void dispose() {
    _mobileCtrl.dispose();
    _pwdCtrl.dispose();
    super.dispose();
  }
}
