import 'package:yiapp/complex/tools/api_state.dart';
import 'package:yiapp/service/wsutil/ws_worker.dart';
import 'package:yiapp/model/login/login_result.dart';
import 'package:yiapp/service/api/api_base.dart';

Future<bool> setLoginInfo(LoginResult r) async {
  ApiBase.login = true;
  ApiBase.uid = r.user_info.id;
  ApiState.broker_id = r.user_info.broker_id;
  ApiState.isMaster = r.is_master;
  ApiState.isAdmin = r.is_admin;
  ApiState.isBrokerAdmin = r.is_broker_admin;
  ApiState.isBroker = r.user_info.broker_id > 0 ? true : false;
  // save user_code and pwd

  //设置全局的jwt值
  ApiBase.jwt = r.jwt;
  ApiBase.loginInfo = r;
  initWSChan(); // 初始化 web socket 连接
  //await initDB();
}
