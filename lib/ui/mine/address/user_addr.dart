import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yiapp/func/debug_log.dart';
import 'package:yiapp/func/const/const_color.dart';
import 'package:yiapp/func/adapt.dart';
import 'package:yiapp/func/cus_route.dart';
import 'package:yiapp/func/bool_utils.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/model/complex/address_result.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_user.dart';
import 'package:yiapp/ui/mine/address/add_or_ch.dart';
import 'package:yiapp/ui/mine/address/addr_item.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/9/8 15:24
// usage ：用户的收货地址
// ------------------------------------------------------

class UserAddressPage extends StatefulWidget {
  final bool event;

  UserAddressPage({this.event: false, Key key}) : super(key: key);

  @override
  _UserAddressPageState createState() => _UserAddressPageState();
}

class _UserAddressPageState extends State<UserAddressPage> {
  var _future;
  List<AddressResult> _l; // 地址信息列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 获取地址信息列表以及默认收件地址
  _fetch() async {
    try {
      var res = await ApiUser.userAddrList(ApiBase.uid);
      if (res != null) _l = res;
    } catch (e) {
      _l = [];
      Debug.logError("暂未添加收货地址：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(
        text: "我的收货地址",
        actions: <Widget>[
          FlatButton(
            child: Text(
              "添加新地址",
              style: TextStyle(color: t_gray, fontSize: Adapt.px(28)),
            ),
            onPressed: () => CusRoute.push(context, AddChAddrPage()).then(
              (val) {
                if (val != null) _refresh();
              },
            ),
          )
        ],
      ),
      body: _bodyCtr(),
      backgroundColor: primary,
    );
  }

  Widget _bodyCtr() {
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (!snapDone(snap)) {
          return Center(child: CircularProgressIndicator());
        }
        if (_l.isEmpty) {
          return Center(child: CusText("暂未添加收货地址", t_gray, 30));
        }
        return ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: Adapt.px(10)),
          children: List.generate(
            _l.length,
            (i) => AddrItem(
                res: _l[i],
                onChanged: _refresh,
                onAddr: (val) {
                  if (val != null && widget.event) {
                    Navigator.of(context).pop(val);
                  }
                }),
          ),
        );
      },
    );
  }

  /// 刷新数据
  void _refresh() async {
    await _fetch();
    setState(() {});
  }
}
