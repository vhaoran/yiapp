import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/ui/master/master_fund/master_draw_money_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/8 下午4:50
// usage ：大师提现订单
// ------------------------------------------------------

class MasterDrawMoneyMain extends StatefulWidget {
  MasterDrawMoneyMain({Key key}) : super(key: key);

  @override
  _MasterDrawMoneyMainState createState() => _MasterDrawMoneyMainState();
}

class _MasterDrawMoneyMainState extends State<MasterDrawMoneyMain> {
  final List<String> _tabs = ["审批中", "已审批"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: CusAppBar(text: "提现记录"),
        body: _bodyCtr(),
        backgroundColor: primary,
      ),
    );
  }

  Widget _bodyCtr() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabBar(
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: t_primary,
          labelPadding: EdgeInsets.only(bottom: 3),
          labelColor: t_primary,
          unselectedLabelColor: t_gray,
          tabs: List.generate(
            _tabs.length,
            (i) => Text(_tabs[i],
                style: TextStyle(color: t_gray, fontSize: S.sp(16))),
          ),
        ),
        SizedBox(height: S.h(5)),
        Expanded(
          child: TabBarView(
            children: [
              MasterDrawMoneyPage(), // 审批中的大师提现订单
              MasterDrawMoneyPage(hadDraw: true), // 已审批的大师提现订单
            ],
          ),
        ),
      ],
    );
  }
}
