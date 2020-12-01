import 'package:yiapp/func/const/const_string.dart';
import 'package:yiapp/model/free/chegong_result.dart';
import 'package:yiapp/model/free/daxian_result.dart';
import 'package:yiapp/model/free/guandi_result.dart';
import 'package:yiapp/model/free/guanyin_result.dart';
import 'package:yiapp/model/free/lvzu_result.dart';
import 'package:yiapp/model/free/mazu_result.dart';
import 'package:yiapp/model/free/yuelao_result.dart';
import 'package:yiapp/model/free/birth_result.dart';
import 'package:yiapp/model/free/blood_result.dart';
import 'package:yiapp/model/free/con_result.dart';
import 'package:yiapp/model/free/zodiac_result.dart';
import 'package:yiapp/model/complex/zhou_gong_res.dart';
import 'api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/26 11:29
// usage ：免费功能的路由，如配对 (星座、生肖)，周公解梦等
// ------------------------------------------------------

class ApiFree {
  /// 星座配对
  static Future<ConResult> conMatch(Map<String, dynamic> m) async {
    var url = "/yi/cms/ConMatch";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => ConResult.fromJson(m));
  }

  /// 生肖配对
  static Future<ZodiacResult> shengXiaoMatch(Map<String, dynamic> m) async {
    var url = "/yi/cms/ShengXiaoMatch";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => ZodiacResult.fromJson(m));
  }

  /// 血型配对
  static Future<BloodResult> bloodMatch(Map<String, dynamic> m) async {
    var url = "/yi/cms/BloodMatch";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => BloodResult.fromJson(m));
  }

  /// 生日配对
  static Future<BirthResult> shengRiMatch(Map<String, dynamic> m) async {
    var url = "/yi/cms/ShengRiMatch";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => BirthResult.fromJson(m));
  }

  /// 黄大仙灵签
  static Future<DaXianResult> daXianDraw(Map<String, dynamic> m) async {
    var url = "/yi/cms/DaXianDraw";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => DaXianResult.fromJson(m));
  }

  /// 关帝灵签
  static Future<GuanDiResult> guanDiDraw(Map<String, dynamic> m) async {
    var url = "/yi/cms/GuanDiDraw";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => GuanDiResult.fromJson(m));
  }

  /// 观音灵签
  static Future<GuanYinResult> guanYinDraw(Map<String, dynamic> m) async {
    var url = "/yi/cms/GuanYinDraw";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => GuanYinResult.fromJson(m));
  }

  /// 妈祖灵签
  static Future<MaZuResult> maZuDraw(Map<String, dynamic> m) async {
    var url = "/yi/cms/MaZuDraw";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => MaZuResult.fromJson(m));
  }

  /// 月老灵签
  static Future<YueLaoResult> yueLaoDraw(Map<String, dynamic> m) async {
    var url = "/yi/cms/YueLaoDraw";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => YueLaoResult.fromJson(m));
  }

  /// 车公灵签
  static Future<CheGongResult> cheGongDraw(Map<String, dynamic> m) async {
    var url = "/yi/cms/CheGongDraw";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => CheGongResult.fromJson(m));
  }

  /// 吕祖灵签
  static Future<LvZuResult> lvZuDraw(Map<String, dynamic> m) async {
    var url = "/yi/cms/LvZuDraw";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => LvZuResult.fromJson(m));
  }

  /// 周公解梦
  static Future<List<ZhouGongRes>> dreamSearch(String key_words) async {
    var url = w_yi_cms + "DreamSearch";
    var data = {"key_words": key_words};
    return await ApiBase.postList(
        url, data, (l) => l.map((x) => ZhouGongRes.fromJson(x)).toList(),
        enableJwt: true);
  }
}
