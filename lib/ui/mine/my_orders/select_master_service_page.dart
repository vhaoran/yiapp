import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/bo/broker_master_cate.dart';
import 'package:yiapp/service/api/api_bo.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';
import 'package:yiapp/widget/master/master_service_item.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/12/25 上午11:07
// usage ：选择大师服务
// ------------------------------------------------------

class SelectMasterServicePage extends StatefulWidget {
  final int masterId;
  final dynamic yiOrderData;

  SelectMasterServicePage({this.masterId, this.yiOrderData, Key key})
      : super(key: key);

  @override
  _SelectMasterServicePageState createState() =>
      _SelectMasterServicePageState();
}

class _SelectMasterServicePageState extends State<SelectMasterServicePage> {
  var _future;
  List<BrokerMasterCate> _l = []; // 运营商下面大师的服务项目列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 用户获取运营商下面大师的服务列表
  _fetch() async {
    try {
      var m = {"master_id": widget.masterId};
      var l = await ApiBo.bmiPriceUserList(m);
      if (l != null) _l = l;
      setState(() {});
    } catch (e) {
      Log.error("用户点击一对一咨询大师后出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "约聊大师"),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          return _lv();
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[
        ..._l.map(
          (e) => MasterServiceItem(
            cate: e,
            isSelf: false,
            yiOrderData: widget.yiOrderData,
          ),
        ),
      ],
    );
  }
}
