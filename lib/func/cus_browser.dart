import 'package:url_launcher/url_launcher.dart';
import 'package:yiapp/cus/cus_log.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/26 16:50
// usage ：业务类型（充值、商城订单、大师订单、悬赏帖闪断帖、大师提现）
// ------------------------------------------------------

class CusBrowser {
  /// 打开浏览器
  static Future<void> launchIn(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(
          url,
          forceSafariVC: false,
          forceWebView: false,
          headers: <String, String>{'my_header_key': 'my_header_value'},
        );
      } else {
        Log.error("链接false，无法链接到网址$url}");
      }
    } catch (e) {
      Log.error("无法链接到网址$url，打开浏览器出现异常：$e");
    }
  }
}
