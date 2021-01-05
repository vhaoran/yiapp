import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/ui/mine/my_orders/complaints_order_page.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/5 上午9:23
// usage ：投诉订单记录（含处理中和处理过的）
// ------------------------------------------------------

class ComplaintsRecord extends StatefulWidget {
  ComplaintsRecord({Key key}) : super(key: key);

  @override
  _ComplaintsRecordState createState() => _ComplaintsRecordState();
}

class _ComplaintsRecordState extends State<ComplaintsRecord> {
  final List<String> _tabsName = ["处理中", "已处理"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabsName.length,
      child: Scaffold(
        appBar: CusAppBar(text: "投诉记录"),
        body: _body(),
        backgroundColor: primary,
      ),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        TabBar(
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: t_primary,
          labelPadding: EdgeInsets.only(bottom: 3),
          labelColor: t_primary,
          unselectedLabelColor: t_gray,
          tabs: List.generate(
            _tabsName.length,
            (i) => Text(_tabsName[i], style: TextStyle(fontSize: S.sp(16))),
          ),
        ),
        SizedBox(height: S.h(5)),
        Expanded(
            child: ScrollConfiguration(
          behavior: CusBehavior(),
          child: TabBarView(
            children: <Widget>[
              ComplaintsOrderPage(),
              ComplaintsOrderPage(isHis: true),
            ],
          ),
        )),
      ],
    );
  }
}
