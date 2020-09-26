import 'package:yiapp/complex/const/const_int.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/26 21:22
// usage ：switch 类
// ------------------------------------------------------

class YiSwitch {
  /// 显示帖子类型
  static String contentType(int content_type) {
    String str = "";
    switch (content_type) {
      case post_liuyao: // 六爻
        str = "六爻";
        break;
      case post_sizhu: // 四柱
        str = "四柱";
        break;
      case he_hun: // 合婚
        str = "合婚";
        break;
      default:
        str = "未知";
    }
    return str;
  }

  /// 符号，老阴、老阳显示 X 和 O，少阴少阳不显示
  static String xoSymbol(int code) {
    String str;
    switch (code) {
      case lao_yin: // 老阴
        str = "X";
        break;
      case lao_yang: // 老阳
        str = "O";
        break;
      default:
        str = "";
        break;
    }
    return str;
  }
}
