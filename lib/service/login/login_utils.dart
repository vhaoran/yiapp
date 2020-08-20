import 'package:yiapp/service/wsutil/ws_worker.dart';
import 'package:yiapp/model/login/login_result.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/storage_util/sq_init.dart';

Future<bool> setLoginInfo(LoginResult r) async {
  ApiBase.login = true;
  ApiBase.uid = r.user_info.id;

  // save user_code and pwd

  //设置全局的jwt值
  ApiBase.jwt = r.jwt;
  ApiBase.loginInfo = r;
  initWSChan();
  await initDB();
}
