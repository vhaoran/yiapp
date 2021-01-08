import 'package:flutter/material.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/model/pays/master_business_month.dart';
import 'package:yiapp/service/api/api-account.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_appbar.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/7 下午2:59
// usage ：大师月度对账单
// ------------------------------------------------------

class MasterMonthPage extends StatefulWidget {
  final DateTime time;

  MasterMonthPage({this.time, Key key}) : super(key: key);

  @override
  _MasterMonthPageState createState() => _MasterMonthPageState();
}

class _MasterMonthPageState extends State<MasterMonthPage> {
  var _future;
  MasterMonthRes _res; // 大师月度账单结果

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 分页查询大师月度账单，但根据条件，只获取某年某月的信息
  _fetch() async {
    var m = {
      "page_no": 1,
      "rows_per_page": 1,
      "where": {
        "uid": ApiBase.uid, // uid 为12的有数据
        "year": widget.time.year,
        "month": widget.time.month,
      },
    };
    try {
      PageBean pb = await ApiAccount.businessMasterMonthPage(m);
      if (pb != null) {
        var l = pb.data.map((e) => e as MasterMonthRes).toList();
        if (l != null && l.isNotEmpty) {
          _res = l.first;
          Log.info(
              "${widget.time.year}年${widget.time.month}月账单详情：${_res.toJson()}");
        }
        setState(() {});
      }
    } catch (e) {
      Log.error("分页查询大师月度账单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: "${widget.time.year}年${widget.time.month}月账单"),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          }
          if (_res == null)
            return Center(
              child: Text(
                "当月暂无账单",
                style: TextStyle(color: t_gray, fontSize: S.sp(15)),
              ),
            );
          return ScrollConfiguration(
            behavior: CusBehavior(),
            child: _lv(),
          );
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget  _lv() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: S.w(10)),
      children: <Widget>[
        SizedBox(height: S.h(10)),
        _detailItem(
          title: "大师订单",
          amt: _res.amt_yi_order,
          profit: _res.profit_yi_order,
          refund: _res.amt_yi_order_r,
          qtyRefund: _res.qty_yi_order_r,
          qty: _res.qty_yi_order,
        ),
        _detailItem(
          title: "悬赏帖",
          amt: _res.amt_bbs_prize,
          profit: _res.profit_bbs_prize,
          qty: _res.qty_bbs_prize,
        ),
        _detailItem(
          title: "闪断帖",
          amt: _res.amt_bbs_vie,
          profit: _res.profit_bbs_vie,
          qty: _res.qty_bbs_vie,
        ),
        _detailItem(
          title: "提现",
          amt: _res.amt_draw_money,
          qty: _res.qty_draw_money,
        ),
      ],
    );
  }

  /// 账单详情
  Widget _detailItem({String title, num amt, profit, qty, refund, qtyRefund}) {
    var tGray = TextStyle(color: t_gray, fontSize: S.sp(15));
    var space = 80;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title, // 标题
          style: TextStyle(color: t_primary, fontSize: S.sp(15)),
        ),
        SizedBox(height: S.h(3)),
        Row(
          children: <Widget>[
            Text("总额： ", style: tGray), // 订单总额度
            Text("$amt 元", style: tGray),
          ],
        ),
        if (profit != null)
          Row(
            children: <Widget>[
              Text("利润： ", style: tGray), // 订单纯利润
              Text("$profit 元", style: tGray),
            ],
          ),
        // 大师订单显示退款个数和退款额度
        if (refund != null) ...[
          Row(
            children: <Widget>[
              Text("退款： ", style: tGray), // 大师订单退款总数
              Text("$refund 元", style: tGray),
            ],
          ),
          Row(
            children: <Widget>[
              Text("退款个数： ", style: tGray), // 大师订单退款个数
              Text("$qtyRefund 个", style: tGray),
              SizedBox(width: S.w(space)),
            ],
          ),
        ],
        Row(
          children: <Widget>[
            Text("订单总数： ", style: tGray), // 订单总数
            Text("$qty 个", style: tGray),
          ],
        ),
        Divider(height: 20, thickness: 0.2, color: t_gray),
      ],
    );
  }
}
