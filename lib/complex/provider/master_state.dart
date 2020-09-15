import 'package:flutter/foundation.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/model/login/userInfo.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/15 14:50
// usage ：大师个人信息状态管理
// ------------------------------------------------------

class MasterInfoState with ChangeNotifier, DiagnosticableTreeMixin {
  MasterInfo _masterInfo;

  MasterInfo get masterInfo => _masterInfo;

  /// 初始化用户信息
  void init(MasterInfo info) {
    _masterInfo = info;
    notifyListeners();
  }

  /// 修改昵称
  void chNick(String nick) {
    _masterInfo.nick = nick;
    notifyListeners();
  }

  /// 修改头像地址
  void chIcon(String icon) {
    _masterInfo.icon = icon;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty('masterList', []));
  }
}
