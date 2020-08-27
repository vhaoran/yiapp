import 'package:yiapp/model/pair/blood_result.dart';
import 'package:yiapp/model/pair/con_result.dart';
import 'package:yiapp/model/pair/zodiac_result.dart';
import 'api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/26 11:29
// usage ：配对 (星座、生肖、血型、生日)
// ------------------------------------------------------

class ApiPair {
  /// 星座配对
  static Future<ConResult> conMatch(Map<String, dynamic> m) async {
    var url = "/cms/ConMatch";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => ConResult.fromJson(m));
  }

  /// 生肖配对
  static Future<ZodiacResult> shengXiaoMatch(Map<String, dynamic> m) async {
    var url = "/cms/ShengXiaoMatch";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => ZodiacResult.fromJson(m));
  }

  /// 血型配对
  static Future<BloodResult> bloodMatch(Map<String, dynamic> m) async {
    var url = "/cms/BloodMatch";
    var data = m;
    return await ApiBase.postObj(url, data, (m) => BloodResult.fromJson(m));
  }
}
