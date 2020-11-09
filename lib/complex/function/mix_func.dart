import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/22 10:51
// usage ：混合公开的函数
// ------------------------------------------------------

/// 根据本地是否存储的有 token ，判断用户是否已经登录过
Future<bool> jwtToken() async {
  if (await KV.getStr(kv_jwt) != null) {
    return true;
  }
  return false;
}
