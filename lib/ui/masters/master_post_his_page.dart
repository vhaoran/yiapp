import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/ui/masters/prize/master_prize_his_main.dart';
import 'package:yiapp/ui/masters/vie/master_vie_his_main.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/23 上午10:31
// usage ：大师已完成帖子订单
// ------------------------------------------------------

class MasterPostHisPage extends StatefulWidget {
  MasterPostHisPage({Key key}) : super(key: key);

  @override
  _MasterPostHisPageState createState() => _MasterPostHisPageState();
}

class _MasterPostHisPageState extends State<MasterPostHisPage> {
  final List<String> _tabs = ["悬赏帖", "闪断帖"];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: CusAppBar(text: "已完成"),
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
              MasterPrizeHisMain(), // 大师已完成悬赏帖订单
              MasterVieHisMain(), // 大师已完成闪断帖订单
            ],
          ),
        ),
      ],
    );
  }
}
