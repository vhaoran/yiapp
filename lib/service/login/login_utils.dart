import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/service/storage_util/sqlite/sqlite_init.dart';
import 'package:yiapp/service/wsutil/ws_worker.dart';
import 'package:yiapp/model/login/login_result.dart';
import 'package:yiapp/service/api/api_base.dart';

Future<bool> setLoginInfo(LoginResult r) async {
  ApiBase.login = true;
  ApiBase.uid = r.user_info.id;
  ApiBase.jwt = r.jwt; // 设置全局 jwt 值
  ApiBase.loginInfo = r;

  ApiState.isMaster = r.is_master;
  ApiState.isAdmin = r.is_admin;
  ApiState.isBrokerAdmin = r.is_broker_admin;
  ApiState.broker_id = r.user_info.broker_id;
  ApiState.isVip = r.user_info.broker_id > 0 ? true : false;

  initWSChan(); // 初始化 web socket 连接
//  await initDB(); // 放在了验证登录位置
}
