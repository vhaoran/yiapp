import 'package:yiapp/const/con_int.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/26 21:22
// usage ：switch 工具类
// ------------------------------------------------------

class SwitchUtil {
  /// 显示帖子类型
  static String contentType(int type) {
    if (type == post_liuyao) return "六爻";
    if (type == post_sizhu) return "四柱";
    if (type == post_hehun) return "合婚";
    return "其他";
  }

  /// 符号，老阴、老阳显示 X 和 O，少阴少阳不显示
  static String xoSymbol(int code) {
    if (code == lao_yin) return "X"; // 老阴
    return "O"; // 老阴
  }
}
