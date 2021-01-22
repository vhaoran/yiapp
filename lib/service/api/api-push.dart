//
import 'package:mobpush_plugin/mobpush_plugin.dart';

import 'api_base.dart';

class ApiPush {
  static const String pre = "/yi/user/";

  /// 完成订单结贴--用于大师操作
  static Future<bool> pushRegist(String regID) async {
    var url = pre + "PushRegist";
    var data = {"reg_id": regID};

    // setPushReceiver();

    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }
  //注销原来的注册信息，不需要参数
  static Future<bool> pushUnRegist() async {
    var url = pre + "PushUnRegist";
    var data = {"data": "data"};

    // setPushReceiver();

    return await ApiBase.postValue<bool>(url, data, enableJwt: true);
  }

  static preparePush() {
    setPushReceiver();
    setPushIcon();
  }

  static setPushReceiver() {
    MobpushPlugin.addPushReceiver((data) {
      print(" =================push on receive: ${data.toString()}");
    }, (e) {
      print(" ================= ****** push on receive error: $e");
    });
  }

  static setPushIcon() {
    MobpushPlugin.setNotifyIcon("assets/images/b.png");
  }
}
