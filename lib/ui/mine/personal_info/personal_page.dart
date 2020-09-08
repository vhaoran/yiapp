import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/provider/user_state.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_routes.dart';
import 'package:yiapp/complex/tools/cus_tool.dart';
import 'package:yiapp/complex/widgets/cus_avatar.dart';
import 'package:yiapp/complex/widgets/cus_box.dart';
import 'package:yiapp/complex/widgets/cus_time_picker/time_picker.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/login/login_page.dart';
import 'package:yiapp/model/login/userInfo.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_user.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';
import 'package:yiapp/ui/mine/personal_info/address/user_address.dart';
import 'package:yiapp/ui/mine/personal_info/ch_nick.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/ui/mine/personal_info/ch_sex.dart';
import 'package:provider/provider.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/24 10:49
// usage ：个人信息（头像、昵称、性别、手机号等）
// ------------------------------------------------------

class PersonalPage extends StatefulWidget {
  PersonalPage({Key key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  UserInfo _u;

  @override
  Widget build(BuildContext context) {
    _u = ApiBase.login
        ? context.watch<UserInfoState>().userInfo ?? defaultUser
        : defaultUser;
    return Scaffold(
      appBar: CusAppBar(text: '个人信息'),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          ..._areaTop(), // 头像、昵称、性别、手机号码
          ..._areaBottom(), // 出生日期、出生地点、退出登录、我的收货地址
        ],
      ),
      backgroundColor: primary,
    );
  }

  /// 头像、昵称、性别、手机号码
  List<Widget> _areaTop() {
    return <Widget>[
      SizedBox(height: Adapt.px(20)),
      MidWidgetBox(
        title: "头像",
        child: CusAvatar(url: _u.icon?.substring(16), size: 40, circle: true),
      ),
      NormalBox(
        title: "昵称",
        subtitle: _u.nick,
        onTap: () => CusRoutes.push(context, ChUserNick(nick: _u.nick)),
      ),
      NormalBox(
        title: "性别",
        subtitle: CusTool.sex(_u.sex),
        onTap: () => CusRoutes.push(context, ChUserSex(sex: _u.sex)),
      ),
      NormalBox(title: "手机号码", subtitle: _u.user_code),
    ];
  }

  /// 出生日期、出生地点、退出登录、我的收货地址
  List<Widget> _areaBottom() {
    return <Widget>[
      NormalBox(
        title: "出生日期",
        subtitle: "${_u.birth_year} 年 ${CusTool.padLeft(_u.birth_month)} 月"
            " ${CusTool.padLeft(_u.birth_day)} 日",
        onTap: _doChBirth,
      ),
      NormalBox(title: "出生地点", subtitle: "${_u.province}省 ${_u.city}市"),
      NormalBox(
        title: "我的收货地址",
        onTap: () => CusRoutes.push(context, UserAddressPage()),
      ),
      SizedBox(height: Adapt.px(50)),
      SingleTextBox(
        title: "退出登录",
        onTap: () =>
            CusDialog.err(context, title: "您确定退出当前账号吗?", onApproval: () async {
          await KV.clear();
          CusRoutes.push(context, LoginPage());
        }),
      ),
    ];
  }

  /// 修改出生日期
  void _doChBirth() {
    TimePicker(
      context,
      onConfirm: (date) async {
        if (date == null) return;
        var m = {
          "birth_year": date.year,
          "birth_month": date.month,
          "birth_day": date.day,
        };
        try {
          bool ok = await ApiUser.ChUserInfo(m);
          print(">>>修改出生日期结果：$ok");
          if (ok) {
            context
                .read<UserInfoState>()
                ?.chBirth(date.year, date.month, date.day);
            CusToast.toast(context, text: "修改成功");
          }
        } catch (e) {
          print("<<<修改出生日期出现异常：$e");
        }
      },
    );
  }
}
