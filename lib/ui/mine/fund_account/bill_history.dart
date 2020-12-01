import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/flutter/cus_text.dart';
import 'package:yiapp/ui/mine/fund_account/bill_pay_his.dart';
import 'package:yiapp/ui/mine/fund_account/bill_payget_his.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/24 15:30
// usage ：对账单历史（含支付和收款）
// ------------------------------------------------------

class BillHistoryPage extends StatefulWidget {
  BillHistoryPage({Key key}) : super(key: key);

  @override
  _BillHistoryPageState createState() => _BillHistoryPageState();
}

class _BillHistoryPageState extends State<BillHistoryPage> {
  List<String> _tabs = ["支付助手", "收款助手"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: CusAppBar(text: "对账单记录"),
        body: _co(),
        backgroundColor: primary,
      ),
    );
  }

  Widget _co() {
    return Column(
      children: <Widget>[
        TabBar(
          indicatorWeight: Adapt.px(6),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: t_primary,
          labelPadding: EdgeInsets.all(Adapt.px(8)),
          labelColor: t_primary,
          unselectedLabelColor: t_gray,
          tabs: List.generate(
            _tabs.length,
            (i) => CusText(_tabs[i], t_gray, 28),
          ),
        ),
        SizedBox(height: Adapt.px(15)),
        Expanded(
            child: TabBarView(
          children: <Widget>[
            BillPayHisPage(), // 支付记录历史
            BillPayGetHisPage(), // 收款记录历史
          ],
        )),
      ],
    );
  }
}
