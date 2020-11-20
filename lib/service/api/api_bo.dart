import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/model/bo/price_level_res.dart';
import 'api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/11/20 10:52
// usage ：bo 路由
// ------------------------------------------------------

class ApiBo {
  /// 用户查看，运营商悬赏帖收费标准
  static Future<List<PriceLevelRes>> brokerPriceLevelPrizeUserList() async {
    var url = w_yi_user + "BrokerPriceLevelPrizeUserList";
    var data = Map<String, dynamic>();
    return await ApiBase.postList(
        url, data, (l) => l.map((x) => PriceLevelRes.fromJson(x)).toList(),
        enableJwt: true);
  }
}
