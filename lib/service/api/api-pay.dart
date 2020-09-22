import 'api_base.dart';

class ApiPay {
  /*
  * b_type: 业务类型,
  *  p_order   商城订单付款
	// yi_order  大师订单付款
	// bbs_prize 悬赏贴付款
	// bbs_vie   闪断贴付款
	// recharge 充值,充值时不需要传入trade_no
	// master_draw_money 大师提现
  * acc_type: 0:支付宝 1：微信
  * tradeNo: 订单号，根据业务类型分别为 uuid
  * amt :金额，保留现位小数
  *
  * 本函数只生成url,
  * url请在内转的浏览器端执行,get方式。
  * */
  static String PayReqURL(
      String b_type, int acc_type, String trade_no, num amt) {
    var jwt = ApiBase.jwt;
    var host = ApiBase.host;

    String url = "http://$host/yi/trade/PayReq?"
        "Jwt=$jwt&"
        "b_type=$b_type&"
        "acc_type=$acc_type&"
        "trade_no=$trade_no&"
        "amt=$amt";
    return url;
  }
}
