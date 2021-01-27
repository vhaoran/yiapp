import 'package:uuid/uuid.dart';
import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/cus/cus_log.dart';
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

  /// 根据摇卦的数组转换为传递给服务器的字符串格式
  static String yaoCode(List<int> l) {
    if (l.isNotEmpty) {
      String yaoCode = "";
      l.forEach((e) => yaoCode += e.toString());
      return yaoCode;
    }
    return "";
  }

  /// 字符串六爻代码转换为摇卦的数组
  static List<int> yaoCodeList(String yaoCode) {
    if (yaoCode.isNotEmpty) {
      List<int> l = [];
      List<String> codes = yaoCode.split('');
      codes.forEach((e) => l.add(int.parse(e)));
      return l.reversed.toList(); // 反序显示
    }
    return List<int>();
  }

  static String newUUID() {
    var uuid = Uuid();
    return uuid.v4();
  }

  /// 检查本地的求测大师的数据，有的话清理
  static Future<void> checkLocalY() async {
    String data = await KV.getStr(kv_order);
    if (data != null) {
      bool remove = await KV.remove(kv_order);
      Log.info("移除本地求测大师数据结果：$remove");
    } else {
      Log.info("没有本地本地求测大师数据，无需清理");
    }
  }
}
