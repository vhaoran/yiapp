import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/global/def_data.dart';
import 'package:yiapp/ui/provider/user_state.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/util/regex/regex_func.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/util/temp/cus_tool.dart';
import 'package:yiapp/widget/small/cus_avatar.dart';
import 'package:yiapp/widget/small/cus_box.dart';
import 'package:yiapp/widget/cus_time_picker/time_picker.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_bottom_sheet.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/small/cus_loading.dart';
import 'package:yiapp/ui/login/login_page.dart';
import 'package:yiapp/model/login/userInfo.dart';
import 'package:yiapp/service/api/api_image.dart';
import 'package:yiapp/service/storage_util/sqlite/login_dao.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import 'package:yiapp/ui/mine/address/user_addr.dart';
import 'package:yiapp/ui/mine/personal_info/bind_usercode_pwd.dart';
import '../../../service/api/api_user.dart';
import 'package:yiapp/ui/mine/personal_info/ch_nick.dart';
import 'package:provider/provider.dart';
import 'package:yiapp/ui/mine/personal_info/ch_sex.dart';

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
  UserInfo _u = UserInfo();

  @override
  Widget build(BuildContext context) {
    _u = context.watch<UserInfoState>().userInfo ?? defaultUser;
    return Scaffold(
      appBar: CusAppBar(text: '个人信息'),
      body: _lv(),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        SizedBox(height: Adapt.px(20)),
        MidWidgetBox(
          title: "头像", // 头像
          child: CusAvatar(url: _u.icon ?? "", size: 40, circle: true),
          onTap: () => CusBottomSheet(
            context,
            OnFile: (file) {
              _doChIcon(file);
              setState(() {});
            },
          ),
        ),
        NormalBox(
          title: "昵称", // 昵称
          subtitle: _u.nick,
          onTap: () => CusRoute.push(context, ChUserNick(nick: _u.nick)),
        ),
        NormalBox(
          title: "性别", // 性别
          subtitle: CusTool.sex(_u.sex),
          onTap: () => CusRoute.push(context, ChUserSex(sex: _u.sex)),
        ),
        NormalBox(
          title: "出生日期", // 出生日期
          subtitle: _u.birth_year == 0
              ? "${_u.created_at}" // 默认注册时间
              : "${_u.birth_year} 年 ${CusTool.padLeft(_u.birth_month)} 月"
                  " ${CusTool.padLeft(_u.birth_day)} 日",
          onTap: _doChBirth,
        ),
        NormalBox(
          title: "手机号码", // 手机号码
          showBtn: RegexUtil.isMobile(_u.user_code) ? false : true,
          subtitle: RegexUtil.isMobile(_u.user_code) ? _u.user_code : "绑定手机",
          subFn: RegexUtil.isMobile(_u.user_code)
              ? null
              : () => CusRoute.push(context, BindUserCodePwd()),
        ),
        // 出生地点
//        NormalBox(
//          title: "出生地点",
//          subtitle:
//              _u.country.isEmpty ? "请选择出生地点" : "${_u.province}省 ${_u.city}市",
//          subFn: _u.country.isEmpty ? null : null,
//        ),
        // 我的收货地址
        if (CusRole.is_vip)
          NormalBox(
            title: "我的收货地址",
            onTap: () => CusRoute.push(context, UserAddressPage()),
          ),
        SizedBox(height: Adapt.px(50)),
        SingleTextBox(
          title: "退出登录",
          onTap: () => CusDialog.normal(
            context,
            title: "您确定退出当前账号吗?",
            fnDataApproval: "",
            onThen: () => CusRoute.push(context, LoginPage()),
          ),
        ),
      ],
    );
  }

  /// 修改头像地址
  void _doChIcon(File file) async {
    if (file == null) return;
    SpinKit.threeBounce(context);
    try {
      String key = await ApiImage.uploadQiniu(file);
      String url = await ApiImage.GetVisitURL(key);
      Log.info("这里的key是：$key,url是：$url");
      var m = {"icon": url};
      bool ok = await ApiUser.ChUserInfo(m);
      if (ok) {
        context.read<UserInfoState>().chIcon(url);
        bool update = await LoginDao(glbDB).updateIcon(url);
        if (update) {
          CusToast.toast(context, text: "修改成功");
          Navigator.pop(context);
        }
        Log.info("存储头像到数据库结果：$update");
      }
    } catch (e) {
      Log.error("修改用户头像出现异常：$e");
    }
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
          Log.info("修改出生日期结果：$ok");
          if (ok) {
            context
                .read<UserInfoState>()
                ?.chBirth(date.year, date.month, date.day);
            bool update = await LoginDao(glbDB)
                .updateBirth(date.year, date.month, date.day);
            if (update) {
              CusToast.toast(context, text: "修改成功");
            }
          }
        } catch (e) {
          Log.error("修改出生日期出现异常：$e");
        }
      },
    );
  }
}
