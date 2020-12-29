//
import 'api_base.dart';

class ApiPush {
  static const String pre = "/yi/user/";

  /// 完成订单结贴--用于大师操作
  static Future<bool> pushRegist(String regID) async {
    var url = pre + "PushRegist";
    var data = {"reg_id": regID};

    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }
}
