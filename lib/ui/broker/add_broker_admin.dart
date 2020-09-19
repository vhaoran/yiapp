//import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:yiapp/complex/class/debug_log.dart';
//import 'package:yiapp/complex/const/const_color.dart';
//import 'package:yiapp/complex/tools/adapt.dart';
//import 'package:yiapp/complex/type/bool_utils.dart';
//import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
//import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
//import 'package:yiapp/model/login/userInfo.dart';
//import 'package:yiapp/model/pagebean.dart';
//import 'package:yiapp/service/api/api-broker.dart';
//import 'package:yiapp/service/api/api_base.dart';
//import 'package:yiapp/ui/broker/broker_item.dart';
//
//// ------------------------------------------------------
//// author：suxing
//// date  ：2020/9/19 15:10
//// usage ：添加代理管理员页面
//// ------------------------------------------------------
//
//class BrokerAdminAddPage extends StatefulWidget {
//  BrokerAdminAddPage({Key key}) : super(key: key);
//
//  @override
//  _BrokerAdminAddPageState createState() => _BrokerAdminAddPageState();
//}
//
//class _BrokerAdminAddPageState extends State<BrokerAdminAddPage> {
//  var _future;
//  int _pageNo = 0;
//  int _rowsCount = 0;
//  List<UserInfo> _l = []; // 代理管理员列表
//
//  @override
//  void initState() {
//    _future = _fetch();
//    super.initState();
//  }
//
//  _fetch() async {
//    if (_pageNo * 20 > _rowsCount) return; // 默认每页查询20条
//    _pageNo++;
//    var m = {"page_no": _pageNo, "rows_per_page": 20};
//    try {
//      PageBean pb = await ApiBroker.brokerUserInfoPage(m);
//      if (_rowsCount == 0) _rowsCount = pb.rowsCount;
//      var l = pb.data.map((e) => e as UserInfo).toList();
//      Debug.log("总的代理管理员个数：$_rowsCount");
//      l.forEach((src) {
//        // 在原来的基础上继续添加新的数据
//        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
//        if (dst == null) _l.add(src);
//        _l.removeWhere((e) => e.id == ApiBase.uid); // 移除代理人自己
//      });
//      Debug.log("当前已查询多少条数据：${_l.length}");
//    } catch (e) {
//      Debug.logError("分页查询代理管理员出现异常：$e");
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: CusAppBar(text: "添加代理管理员"),
//      body: FutureBuilder(
//        future: _future,
//        builder: (context, snap) {
//          if (!snapDone(snap)) {
//            return Center(child: CircularProgressIndicator());
//          }
//          if (_l.isEmpty) {
//            return Center(child: CusText("你现在还没有代理", t_gray, 28));
//          }
//          return ListView(
//            physics: BouncingScrollPhysics(),
//            children: <Widget>[
//              SizedBox(height: Adapt.px(15)),
//              ..._l.map((e) => BrokerUserItem(u: e)),
//            ],
//          );
//        },
//      ),
//      backgroundColor: primary,
//    );
//  }
//}
