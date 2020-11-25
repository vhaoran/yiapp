import 'package:yiapp/service/wsutil/ws_worker.dart';
import 'package:yiapp/model/login/login_result.dart';
import 'package:yiapp/service/api/api_base.dart';

/// 设置登录后的初始值
Future<bool> setLoginInfo(LoginResult r) async {
  ApiBase.login = true;
  ApiBase.uid = r.user_info.id;
  ApiBase.jwt = r.jwt; // 设置全局 jwt 值
  ApiBase.loginInfo = r;
  initWSChan(); // 初始化 web socket 连接
//  await initDB(); // 放在了验证登录位置
}
