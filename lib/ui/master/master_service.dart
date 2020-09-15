import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/dicts/master-cate.dart';
import 'package:yiapp/service/api/api-master.dart';
import 'package:yiapp/service/api/api_base.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/15 18:46
// usage ：大师服务页面
// ------------------------------------------------------

class MasterServicePage extends StatefulWidget {
  MasterServicePage({Key key}) : super(key: key);

  @override
  _MasterServicePageState createState() => _MasterServicePageState();
}

class _MasterServicePageState extends State<MasterServicePage> {
  var _future;
  List<MasterCate> _l; // 获取大师项目列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      var res = await ApiMaster.masterItemList(ApiBase.uid);
      print(">>>第一个大师项目列表数据：${res.first.toJson()}");
      if (res != null) _l = res;
    } catch (e) {
      _l = [];
      print("<<<获取大师项目列表出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List.from([1,3]);
    return Scaffold(
      appBar: CusAppBar(
        text: "大师服务",
        actions: <Widget>[
          FlatButton(
            child: Text(
              "添加新服务",
              style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
            ),
//            onPressed: () => CusRoutes.push(context, AddChAddrPage()).then(
//              (val) => _refresh(),
//            ),
            onPressed: () {},
          )
        ],
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, snap) {
            if (!snapDone(snap)) {
              return Center(child: CircularProgressIndicator());
            }
            if (_l.isEmpty) {
              return Center(child: CusText("暂未添加项目", t_gray, 30));
            }
            return _lv();
          }),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[],
    );
  }
}
