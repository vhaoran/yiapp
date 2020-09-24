import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/22 10:51
// usage ：混合公开的函数
// ------------------------------------------------------

///  用户是否已经登录过
Future<bool> hadLogin() async {
  if (await KV.getStr(kv_jwt) != null) {
    return true;
  }
  return false;
}

/// 是否本人发帖
bool isMe(int uid) => uid == ApiBase.uid ? true : false;
