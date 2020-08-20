import 'package:yiapp/model/msg/msg_body.dart';
import 'api_base.dart';

class ApiMsg {
  //判断用户编码是否存在
  static Future<MsgBody> SendMsg(Map<String, dynamic> m) async {
    //http://{{host}}/msg/SendMsg
    var url = "/msg/SendMsg";
    var data = m;
    return await ApiBase.postObj(url, data, (m) {
      return MsgBody.fromJson(m);
    }, enableJwt: true);
  }

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

  //群聊消息历史---分页查询
  static MsgHisGroupPage(Map<String, dynamic> pb) async {
    var url = "/msg/MsgHisGroupPage";
    return await ApiBase.postPage<MsgBody>(url, pb, (m) => MsgBody.fromJson(m));
  }

  //私聊消息历史---分页查询
  static MsgHisPrivatePage(Map<String, dynamic> pb) async {
    // http://{{host}}/msg/MsgHisPrivatePage
    var url = "/msg/MsgHisPrivatePage";
    return await ApiBase.postPage<MsgBody>(url, pb, (m) => MsgBody.fromJson(m));
  }
}
