import 'package:uuid/uuid.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_role.dart';
import 'package:yiapp/service/storage_util/prefs/kv_storage.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/1 下午2:19
// usage ：综合工具
// ------------------------------------------------------

class UsUtil {
  /// bool 转 num
  static num toInt(bool val) {
    return val ? 1 : 0;
  }

  /// num 转 bool
  static bool toBool(num val) {
    return val == 1 ? true : false;
  }

  static String newUUID() {
    var uuid = Uuid();
    return uuid.v4();
  }
}
