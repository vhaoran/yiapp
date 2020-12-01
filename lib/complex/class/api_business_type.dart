import 'package:url_launcher/url_launcher.dart';
import '../../func/debug_log.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/26 16:50
// usage ：业务类型（充值、商城订单、大师订单、悬赏帖闪断帖、大师提现）
// ------------------------------------------------------

/// [b_type] 业务类型 [acc_type] 支付类型 [trade_no] 订单号 [amt] 金额

class ApiBrowser {
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
        throw "无法链接到网址$url}";
      }
    } catch (e) {
      Debug.logError("无法链接到网址$url，打开浏览器出现异常：$e");
    }
  }

  /// 用静态的方法封装 ApiPay.PayReqURL ,会报异常信息
  /// params:{"ip":"","uid":,等}
  /// err 验证失效，不存在重复记录
}
