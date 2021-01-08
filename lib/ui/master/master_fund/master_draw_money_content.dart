import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/pays/draw_money_res.dart';
import 'package:yiapp/service/api/api-account.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/8 下午5:31
// usage ：单条大师提现的内容
// ------------------------------------------------------

class MasterDrawMoneyContent extends StatefulWidget {
  final bool hadDraw;
  final String id;

  MasterDrawMoneyContent({this.hadDraw: false, this.id, Key key})
      : super(key: key);

  @override
  _MasterDrawMoneyContentState createState() => _MasterDrawMoneyContentState();
}

class _MasterDrawMoneyContentState extends State<MasterDrawMoneyContent> {
  var _future;
  DrawMoneyRes _res;

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  _fetch() async {
    try {
      var res = widget.hadDraw
          ? await ApiAccount.masterDrawMoneyHisGet(widget.id) // 获取审批中的提现单据
          : await ApiAccount.masterDrawMoneyGet(widget.id); // 获取已审批的提现单据
      if (res != null) _res = res;
    } catch (e) {
      Log.error("获取审批中的提现单据出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "提现单据"),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (_res == null) {
            return Center(
              child: Text(
                "",
                style: TextStyle(color: t_gray, fontSize: S.sp(15)),
              ),
            );
          }
          return _lv();
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[],
    );
  }
}
