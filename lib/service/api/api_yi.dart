import 'package:yiapp/model/liuyaos/liuyao_result.dart';
import 'api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/4 11:43
// usage ：鸿运中关于周易的路由
// ------------------------------------------------------

class ApiYi {
  /// 六爻排盘
  static Future<LiuYaoResult> liuYaoQiGua(Map<String, dynamic> m) async {
    var url = "/yi/user/LiuYaoQiGua";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => LiuYaoResult.fromJson(m));
  }
}
