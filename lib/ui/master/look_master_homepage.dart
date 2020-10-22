import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/dicts/master-info.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/ui/master/look_master_base_data.dart';
import 'package:yiapp/ui/master/master_info_home.dart';

import 'master_order/master_complete_orders.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/8/17 17:18
// usage ：用户查看大师主页
// ------------------------------------------------------

class LookMasterHomePage extends StatefulWidget {
  final int master_id;

  LookMasterHomePage({this.master_id, Key key}) : super(key: key);

  @override
  _LookMasterHomePageState createState() => _LookMasterHomePageState();
}

class _LookMasterHomePageState extends State<LookMasterHomePage> {
  var _future;
  var _m = MasterInfo();
  List<String> _tabs = ["主页", "服务", "历史订单"];

  @override
  void initState() {
    _future = _fetch();
    Debug.log("进了大师主页");
    super.initState();
  }

  _fetch() async {
    try {
      var res = await ApiMaster.masterInfoGet(widget.master_id);
      if (res != null) _m = res;
    } catch (e) {
      Debug.logError("获取大师信息出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        body: FutureBuilder(
          future: _future,
          builder: (context, snap) {
            if (!snapDone(snap)) {
              return Center(child: CircularProgressIndicator());
            }
            return _co();
          },
        ),
        backgroundColor: primary,
      ),
    );
  }

  Widget _co() {
    return Column(
      children: <Widget>[
        LookMasterBaseData(info: _m), // 大师基本资料
        Container(
          color: ter_primary,
          child: TabBar(
            indicatorWeight: Adapt.px(6),
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: t_primary,
            labelPadding: EdgeInsets.all(Adapt.px(8)),
            labelColor: t_primary,
            unselectedLabelColor: t_gray,
            tabs: List.generate(
              _tabs.length,
              (index) => Text(
                _tabs[index],
                style: TextStyle(fontSize: Adapt.px(28)),
              ),
            ),
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: CusBehavior(),
            child: TabBarView(
              children: [
                MasterInfoHome(), // 主页
                CusText("服务", t_gray, 28),
                MasterCompletedOrders(master_id: widget.master_id), // 大师已完成订单
//                CusText("订单", t_gray, 28),
              ],
            ),
          ),
        )
      ],
    );
  }
}
