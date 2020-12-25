import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/model/orders/yiOrder-heHun.dart';
import 'package:yiapp/model/orders/yiOrder-liuyao.dart';
import 'package:yiapp/model/orders/yiOrder-sizhu.dart';

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
    if (code == lao_yang) return "O"; // 老阳
    return ""; // 少阴、少阳
  }

  /// 大师服务项目类型
  static String serviceType(int type) {
    if (type == ming_yun) return "性格命运分析";
    if (type == shi_ye) return "事业";
    if (type == hun_yin) return "婚姻";
    if (type == cai_yun) return "财运";
    if (type == jian_kang) return "健康";
    if (type == shou_xiang) return "手相";
    if (type == mian_xiang) return "面相";
    if (type == mo_gu) return "摸骨";
    if (type == qi_ming) return "起名";
    if (type == hun_jia) return "婚丧嫁娶吉日";
    if (type == he_hun) return "合婚";
    return "";
  }

  /// 大师订单类型
  static String orderType(m) {
    if (m is YiOrderLiuYao) return "六爻订单";
    if (m is YiOrderSiZhu) return "四柱订单";
    if (m is YiOrderHeHun) return "合婚订单";
    return "";
  }
}
