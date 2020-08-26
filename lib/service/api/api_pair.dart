import 'package:yiapp/model/pair/ConResult.dart';
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
}
