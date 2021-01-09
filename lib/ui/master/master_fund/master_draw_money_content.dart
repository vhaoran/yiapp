import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/pays/draw_money_res.dart';
import 'package:yiapp/service/api/api-account.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
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
  DrawMoneyRes _res; // 提现单据

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
                "~单据找不到了",
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
    var tGray = TextStyle(color: t_gray, fontSize: S.sp(15));
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: S.w(15)),
        children: <Widget>[
          SizedBox(height: S.h(10)),
          Text("提现信息", style: TextStyle(color: t_primary, fontSize: S.sp(16))),
          SizedBox(height: S.h(5)),
          Text("提现人：${_res.master_nick}", style: tGray),
          Text("金额：${_res.amt} 元", style: tGray),
          Text("税金：${_res.tax} 元", style: tGray),
          Text("时间：${_res.create_date}", style: tGray),
          Divider(height: 20, thickness: 0.2, color: t_gray),
          Text("账户信息", style: TextStyle(color: t_primary, fontSize: S.sp(16))),
          SizedBox(height: S.h(5)),
          Text("账户持有者：${_res.card.full_name}", style: tGray),
          Text("开户行名称：${_res.card.bank_name}", style: tGray),
          Text("银行卡号：${_res.card.card_code}", style: tGray),
          Divider(height: 20, thickness: 0.2, color: t_gray),
          Text("订单状态", style: TextStyle(color: t_primary, fontSize: S.sp(16))),
          SizedBox(height: S.h(5)),
          // 动态显示订单状态
          _drawStat(),
        ],
      ),
    );
  }

  /// 动态显示订单状态
  Widget _drawStat() {
    if (_res.stat == draw_await) {
      return Text(
        "审批中",
        style: TextStyle(color: t_gray, fontSize: S.sp(15)),
      );
    } else if (_res.stat == draw_cancel) {
      bool canceled = _res.reject_reason == "个人原因";
      // 自己取消的或者被驳回的
      if (canceled) {
        return Text(
          "已取消",
          style: TextStyle(color: t_gray, fontSize: S.sp(15)),
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "已被驳回，原因如下",
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
            Text(
              _res.reject_reason,
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
          ],
        );
      }
    }
    // 审核通过的
    else if (_res.stat == draw_pass) {
      return Text(
        "当前提现单已审核通过",
        style: TextStyle(color: Colors.lightBlue, fontSize: S.sp(15)),
      );
    }
    return SizedBox.shrink();
  }
}
