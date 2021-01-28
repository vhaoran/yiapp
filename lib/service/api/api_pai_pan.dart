import 'package:yiapp/const/con_string.dart';
import 'package:yiapp/model/liuyaos/liuyao_result.dart';
import 'package:yiapp/model/sizhu/sizhu_result.dart';
import 'api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/28 下午4:21
// usage ：六爻排盘、四柱排盘
// ------------------------------------------------------

class ApiPaiPan {
  /// 六爻排盘
  static Future<LiuYaoResult> liuYaoQiGua(Map<String, dynamic> m) async {
    var url = w_yi_user + "LiuYaoQiGua";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => LiuYaoResult.fromJson(m));
  }

  /// 四柱排盘
  static Future<SiZhuResult> paiBaZi(Map<String, dynamic> m) async {
    var url = w_yi_user + "PaiBaZi";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => SiZhuResult.fromJson(m));
  }
}
