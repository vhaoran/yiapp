import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/dicts/master_balance_res.dart';
import 'package:yiapp/service/api/api-account.dart';
import 'package:yiapp/ui/master/master_fund/bankcard_page.dart';
import 'package:yiapp/ui/master/master_fund/master_draw_money_add.dart';
import 'package:yiapp/ui/master/master_fund/master_draw_money_main.dart';
import 'package:yiapp/ui/master/master_bill_his.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/refresh_hf.dart';
import 'package:yiapp/widget/small/cus_box.dart';
import 'package:yiapp/ui/mine/fund_account/fund_list.dart';
import 'package:yiapp/ui/mine/fund_account/recharge_page.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/7 上午10:54
// usage ：大师资金账号主页
// ------------------------------------------------------

class MasterFundMain extends StatefulWidget {
  MasterFundMain({Key key}) : super(key: key);

  @override
  _MasterFundMainState createState() => _MasterFundMainState();
}

class _MasterFundMainState extends State<MasterFundMain> {
  var _future;
  num _balance = 0;
  String _err; // 获取余额出现问题

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 获取大师余额
  _fetch() async {
    try {
      MasterBalanceRes res = await ApiAccount.remainderMasterGet();
      if (res != null) _balance = res.remainder;
    } catch (e) {
      _err = "获取余额异常,请尝试刷新";
      Log.error("获取大师余额出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "资金账号管理"),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return _lv(context);
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv(context) {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: EasyRefresh(
        header: CusHeader(),
        onRefresh: () async {
          if (_err != null) _err = null;
          await _fetch();
          setState(() {});
        },
        child: ListView(
          children: <Widget>[
            if (_err != null)
              Container(
                alignment: Alignment.center,
                child: Text(
                  _err,
                  style: TextStyle(color: t_gray, fontSize: S.sp(15)),
                ),
              ),
            if (_err == null) ...[
              NormalBox(
                title: "余额",
                subtitle: "${_balance.toStringAsFixed(2)} 元",
                showBtn: false,
              ),
              NormalBox(
                title: "个人支付账号",
                onTap: () => CusRoute.push(context, FundListPage()),
              ),
              NormalBox(
                title: "对账单",
                onTap: () => CusRoute.push(context, MasterBillHisPage()),
              ),
              NormalBox(
                title: "银行卡",
                onTap: () => CusRoute.push(context, BankCardPage()),
              ),
              NormalBox(
                title: "充值",
                onTap: () => CusRoute.push(context, RechargePage(auto: false)),
              ),
              NormalBox(
                title: "提现",
                onTap: () => CusRoute.push(context, MasterDrawMoneyAdd()),
              ),
              NormalBox(
                title: "提现记录查询",
                onTap: () => CusRoute.push(context, MasterDrawMoneyMain()),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
