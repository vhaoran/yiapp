import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
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
  ];
}
