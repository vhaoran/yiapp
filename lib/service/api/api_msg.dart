import 'package:yiapp/model/msg/msg_body.dart';
import 'api_base.dart';

class ApiMsg {
  static Future<bool> AckMsg(List l) async {
    // http://{{host}}/msg/AckMsg
    var url = "/msg/AckMsg";
    var data = {"msg_ids": l};
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  static Future<bool> OnLineNotify() async {
    var url = "/msg/OnLineNotify";
    var data = {"aaaa": "aaa"};
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }
}
