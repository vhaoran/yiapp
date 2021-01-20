import 'package:flutter/foundation.dart';
import 'package:yiapp/model/dicts/broker_info.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/19 10:05
// usage ：运营商个人信息状态管理
// ------------------------------------------------------

class BrokerInfoState with ChangeNotifier, DiagnosticableTreeMixin {
  BrokerInfo _brokerInfo;

  BrokerInfo get brokerInfo => _brokerInfo;

  /// 初始化运营商信息
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
