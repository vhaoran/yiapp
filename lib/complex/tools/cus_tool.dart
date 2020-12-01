import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/func/const/const_int.dart';
import 'package:yiapp/util/regex/regex_func.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/24 11:37
// usage ：自定义混合工具类
// ------------------------------------------------------

class CusTool {
  /// 处理性别
  static String sex(int sex) {
    switch (sex) {
      case female:
        return '女';
      case male:
        return '男';
      default:
        return "保密";
    }
  }

  /// 返回字符串中所有的大写字母
  static String AZ(String str) {
    List<String> l =
        str.trim().split('').where((e) => RegexUtil.upChar(e)).toList();
    String val = "";
    l.forEach((e) => val += e);
    return val;
  }

  // 返回字符串中的所有数字
  static List<String> retainNum(String str) {
    List<String> l = str.trim().split('');
    l.retainWhere((e) => RegexUtil.onlyNum(e));
    Debug.log("当前的l：$l");
    return l;
  }

  /// 不够两位数的补0，比如 8:4 to 08:04
  static String padLeft(dynamic data) {
    if (data is num) {
      return data.toString().padLeft(2, "0");
    } else if (data is String) {
      return data.padLeft(2, "0");
    }
    return "转换格式异常";
  }
}
