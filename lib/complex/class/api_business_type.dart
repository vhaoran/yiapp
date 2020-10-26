import 'package:url_launcher/url_launcher.dart';
import 'package:yiapp/complex/const/const_string.dart';
import 'package:yiapp/service/api/api-pay.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'debug_log.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/26 16:50
// usage ：业务类型
// ------------------------------------------------------

/// [b_type] 业务类型 [acc_type] 支付类型 [trade_no] 订单号 [amt] 金额

class ApiBType {
  /// 充值
  static recharge({int acc_type, num amt}) {
    String trade_no = "${ApiBase.uid}"; // 充值订单号传uid
    func(b_recharge, acc_type, trade_no, amt);
  }

  /// 商城订单付款
  static bPOrder({int acc_type, String trade_no, num amt}) {
    func(b_p_order, acc_type, trade_no, amt);
  }

  /// 大师订单付款
  static bYiOrder({int acc_type, String trade_no, num amt}) {
    func(b_yi_order, acc_type, trade_no, amt);
  }

  /// 悬赏帖付款
  static bBbsPrize({int acc_type, String trade_no, num amt}) {
    func(b_bbs_prize, acc_type, trade_no, amt);
  }

  /// 闪断帖付款
  static bBbsVie({int acc_type, String trade_no, num amt}) {
    func(b_bbs_vie, acc_type, trade_no, amt);
  }

  /// 大师提现
  static masterDrawMoney({int acc_type, String trade_no, num amt}) {
    func(b_master_draw_money, acc_type, trade_no, amt);
  }

  static func(String b_type, int acc_type, String trade_no, num amt) {
    String url = ApiPay.PayReqURL(b_type, acc_type, trade_no, amt);
    if (url != null) _launchInBrowser(url);
  }

  /// 打开浏览器
  static Future<void> _launchInBrowser(String url) async {
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
}
