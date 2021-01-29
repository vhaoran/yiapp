import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/ui/masters/refund/master_refund_doing_list.dart';
import 'package:yiapp/ui/masters/refund/master_refund_his_list.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/29 下午7:15
// usage ：大师处理中、已处理的投诉记录
// ------------------------------------------------------

class MasterRefundMainPage extends StatefulWidget {
  MasterRefundMainPage({Key key}) : super(key: key);

  @override
  _MasterRefundMainPageState createState() => _MasterRefundMainPageState();
}

class _MasterRefundMainPageState extends State<MasterRefundMainPage> {
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
              MasterRefundDoingList(), // 大师处理中的投诉订单
              MasterRefundHisList(),// 大师已完成的投诉订单
            ],
          ),
        )),
      ],
    );
  }
}
