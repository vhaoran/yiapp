import 'package:flutter/foundation.dart';
import 'package:yiapp/model/login/userInfo.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/20 16:20
// usage ：用户个人信息状态管理
// ------------------------------------------------------

class UserInfoState with ChangeNotifier, DiagnosticableTreeMixin {
  UserInfo _userInfo;

  UserInfo get userInfo => _userInfo;

  /// 初始化用户信息
  void init(UserInfo info) {
    _userInfo = info;
    notifyListeners();
  }

  /// 修改昵称
  void chNick(String nick) {
    _userInfo.nick = nick;
    notifyListeners();
  }

  /// 修改头像地址
  void chIcon(String icon) {
    _userInfo.icon = icon;
    notifyListeners();
  }

  /// 修改性别
  void chSex(num sex) {
    _userInfo.sex = sex;
    notifyListeners();
  }

  /// 修改出生日期
  void chBirth(num year, month, day) {
    _userInfo
      ..birth_year = year
      ..birth_month = month
      ..birth_day = day;
    notifyListeners();
  }

  /// 绑定手机号
  void bindMobile(String user_code) {
    _userInfo.user_code = user_code;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty('addrList', []));
  }
}
