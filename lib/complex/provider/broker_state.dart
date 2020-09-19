import 'package:flutter/foundation.dart';
import 'package:yiapp/model/dicts/broker-info.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/model/login/userInfo.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/19 10:05
// usage ：代理个人信息状态管理
// ------------------------------------------------------

class BrokerInfoState with ChangeNotifier, DiagnosticableTreeMixin {
  BrokerInfo _brokerInfo;

  BrokerInfo get brokerInfo => _brokerInfo;

  /// 初始化代理信息
  void init(BrokerInfo info) {
    _brokerInfo = info;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty('brokerList', []));
  }
}
