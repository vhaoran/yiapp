import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/22 10:51
// usage ：混合公开的函数
// ------------------------------------------------------

///  用户是否已经登录过
Future<bool> hadLogin() async {
  if (await KV.getStr("/login/user_code") != null &&
      await KV.getStr("/login/pwd") != null) {
    return true;
  }
  return false;
}
