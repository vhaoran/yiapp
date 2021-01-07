import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/ui/master/master_spending_his.dart';
import 'package:yiapp/util/adapt.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'master_earnings_his.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/7 上午11:08
// usage ：大师对账单历史（含收益和退款）
// ------------------------------------------------------

class MasterBillHisPage extends StatefulWidget {
  MasterBillHisPage({Key key}) : super(key: key);

  @override
  _MasterBillHisPageState createState() => _MasterBillHisPageState();
}

class _MasterBillHisPageState extends State<MasterBillHisPage> {
  List<String> _tabs = ["收益", "支出"];

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
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: t_primary,
          labelPadding: EdgeInsets.all(4),
          labelColor: t_primary,
          unselectedLabelColor: t_gray,
          tabs: List.generate(
            _tabs.length,
            (i) => Text(
              _tabs[i],
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
          ),
        ),
        SizedBox(height: Adapt.px(15)),
        Expanded(
            child: TabBarView(
          children: <Widget>[
            MasterEarningsHisPage(), // 大师收益记录历史
            MasterSpendingHisPage(), // 大师退款记录历史
          ],
        )),
      ],
    );
  }
}
