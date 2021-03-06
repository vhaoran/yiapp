import 'package:yiapp/model/msg/msg-notify-his.dart';
import 'package:yiapp/model/msg/msg-yiorder.dart';
import 'api_base.dart';

class ApiMsg {
  static final String pre = "/yi/msg/";

  static Future<bool> OnLineNotify() async {
    var url = pre + "OnLineNotify";
    var data = {"k": "v"};
    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  /// 大师订单--消息分页查询
  static yiOrderMsgHisPage(Map<String, dynamic> m) async {
    var url = pre + "YiOrderMsgHisPage";
    var data = m;
    return await ApiBase.postPage(url, data, (m) => MsgYiOrder.fromJson(m));
  }

  /// 大师订单--发消息 适用于大师和用户，必须有对应的订单号，且订单没有关闭
  static Future<MsgYiOrder> yiOrderMsgSend(Map<String, dynamic> m) async {
    var url = pre + "YiOrderMsgSend";
    var data = m;
    return await ApiBase.postObj(url, data, (m) {
      return MsgYiOrder.fromJson(m);
    }, enableJwt: true);
  }

  //---------大师聊天消息 ack---------------------------------------
  static Future<bool> yiOrderMsgAck(List<String> l) async {
    var url = pre + "YiOrderMsgAck";
    var data = {
      "id_list": l,
    };

    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //---------大师聊天消息 ack--//未来考虑实现为服务-------------------------------------
  static Future<bool> yiOrderMsgAckService(String id) async {
    try {
      return yiOrderMsgAck([id]);
    } catch (e) {
      print("***error---ApiMsg.yiOrderMsgAckService:" + e.toString());
    }
  }

  //----系统通知消息----分页查询------------
  static notifyMsgPage(Map<String, dynamic> pb) async {
    var url = pre + "NotifyMsgPage";
    return await ApiBase.postPage(url, pb, (m) => MsgNotifyHis.fromJson(m));
  }

  //---------系统 通知消息 ack---------------------------------------
  static Future<bool> notifyMsgAck(List<String> l) async {
    var url = pre + "NotifyMsgAck";
    var data = {
      "id_list": l,
    };

    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  //未来考虑实现为服务
  static Future<bool> notifyMsgAckService(String id) async {
    try {
      return notifyMsgAck([id]);
    } catch (e) {
      print("***error,file: " + e.toString());
      return false;
    }
  }
}
