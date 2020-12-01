import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:yiapp/ui/provider/broker_state.dart';
import 'package:yiapp/ui/provider/master_state.dart';
import 'user_state.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/20 16:23
// usage ：自定义的 Provider 状态管理类
// ------------------------------------------------------

class CusProvider {
  static List<SingleChildWidget> providers = [
    // 用户个人信息状态管理
    ChangeNotifierProvider(create: (_) => UserInfoState()),
    // 大师个人信息状态管理
    ChangeNotifierProvider(create: (_) => MasterInfoState()),
    // 运营商个人信息状态管理
    ChangeNotifierProvider(create: (_) => BrokerInfoState()),
  ];
}
