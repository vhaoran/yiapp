import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:yiapp/const/con_color.dart';
import 'package:yiapp/const/con_int.dart';
import 'package:yiapp/cus/cus_log.dart';
import 'package:yiapp/cus/cus_route.dart';
import 'package:yiapp/model/pagebean.dart';
import 'package:yiapp/model/pays/draw_money_res.dart';
import 'package:yiapp/service/api/api-account.dart';
import 'package:yiapp/ui/master/master_fund/master_draw_money_content.dart';
import 'package:yiapp/util/screen_util.dart';
import 'package:yiapp/widget/cus_button.dart';
import 'package:yiapp/widget/cus_complex.dart';
import 'package:yiapp/widget/flutter/cus_dialog.dart';
import 'package:yiapp/widget/flutter/cus_toast.dart';
import 'package:yiapp/widget/refresh_hf.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2021/1/8 下午4:52
// usage ：大师审批中的和已处理的提现单据
// ------------------------------------------------------

class MasterDrawMoneyPage extends StatefulWidget {
  final bool hadDraw; // 是否已经提现（false:审批中，true：已审批）

  MasterDrawMoneyPage({this.hadDraw: false, Key key}) : super(key: key);

  @override
  _MasterDrawMoneyPageState createState() => _MasterDrawMoneyPageState();
}

class _MasterDrawMoneyPageState extends State<MasterDrawMoneyPage>
    with AutomaticKeepAliveClientMixin {
  var _future;
  int _pageNo = 0;
  int _rowsCount = 0;
  final int _rowsPerPage = 10; // 默认每页查询个数
  List<DrawMoneyRes> _l = []; // 已完成列表

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  /// 大师分页查询提现订单
  _fetch() async {
    if (_pageNo * _rowsPerPage > _rowsCount) return;
    _pageNo++;
    var m = {
      "page_no": _pageNo,
      "rows_per_page": _rowsPerPage,
      "sort": {"create_date": -1},
    };
    widget.hadDraw
        ? await _fetchDrawMoneyHisPage(m)
        : await _fetchDrawMoneyPage(m);
  }

  /// 分页获取审批中的大师提现订单
  _fetchDrawMoneyPage(Map<String, dynamic> m) async {
    try {
      PageBean pb = await ApiAccount.masterDrawMoneyPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as DrawMoneyRes).toList();
      Log.info("总的审批中的大师提现订单个数：$_rowsCount");
      l.forEach((src) {
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      setState(() {});
      Log.info("当前已查询审批中的大师提现订单个数：${_l.length}");
    } catch (e) {
      Log.error("查询审批中的大师提现订单出现异常：$e");
    }
  }

  /// 分页获取已审批的大师提现订单
  _fetchDrawMoneyHisPage(Map<String, dynamic> m) async {
    try {
      PageBean pb = await ApiAccount.masterDrawMoneyHisPage(m);
      if (_rowsCount == 0) _rowsCount = pb.rowsCount ?? 0;
      var l = pb.data.map((e) => e as DrawMoneyRes).toList();
      Log.info("总的已审批大师提现订单个数：$_rowsCount");
      l.forEach((src) {
        var dst = _l.firstWhere((e) => src.id == e.id, orElse: () => null);
        if (dst == null) _l.add(src);
      });
      setState(() {});
      Log.info("当前已查询已审批的大师提现订单个数：${_l.length}");
    } catch (e) {
      Log.error("查询已审批的大师提现订单出现异常：$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        return ScrollConfiguration(
          behavior: CusBehavior(),
          child: EasyRefresh(
            header: CusHeader(),
            footer: CusFooter(),
            onLoad: () async => await _fetch(),
            onRefresh: () async => await _refresh(),
            child: _lv(),
          ),
        );
      },
    );
  }

  Widget _lv() {
    return ListView(
      children: <Widget>[
        if (_l.isEmpty)
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 200),
            child: Text(
              "暂无订单",
              style: TextStyle(color: t_gray, fontSize: S.sp(15)),
            ),
          ),
        ..._l.map(
          (e) => InkWell(
            onTap: () => CusRoute.push(
              context,
              MasterDrawMoneyContent(hadDraw: widget.hadDraw, id: e.id),
            ),
            child: _itemCover(e),
          ),
        ),
      ],
    );
  }

  /// 提现订单封面
  Widget _itemCover(DrawMoneyRes res) {
    var tGray = TextStyle(color: t_gray, fontSize: S.sp(15));
    var tJi = TextStyle(color: t_ji, fontSize: S.sp(25));
    return Card(
      color: fif_primary,
      margin: EdgeInsets.all(2),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  "提现",
                  style: TextStyle(color: t_primary, fontSize: S.sp(15)),
                ),
                Spacer(),
                _dynamicView(res), // 动态显示提现状态
              ],
            ),
            SizedBox(height: S.h(20)),
            Row(
              children: <Widget>[
                Text("-${res.amt}", style: tJi), // 提现金额
                Text(" 元", style: tJi),
                Spacer(),
                Text("税金：${res.tax} 元", style: tGray), // 税金
              ],
            ),
            SizedBox(height: S.h(20)),
            Container(
              alignment: Alignment.centerRight,
              child: Text(res.create_date, style: tGray), // 申请提现时间
            ),
          ],
        ),
      ),
    );
  }

  /// 动态显示提现状态
  Widget _dynamicView(DrawMoneyRes res) {
    // 如果审批中的，则显示取消申请提现按钮
    if (!widget.hadDraw) {
      return SizedBox(
        height: S.h(25),
        width: S.w(60),
        child: CusRaisedButton(
          child: Text("取消"),
          backgroundColor: Colors.lightBlue,
          borderRadius: 100,
          onPressed: () => _doCancelDrawMoney(res.id),
        ),
      );
    }
    // 如果是已审批的，分为自己取消的、审核不通过的、审核通过的
    else {
      if (res.stat == draw_cancel) {
        bool canceled = res.reject_reason == "个人原因";
        Color color = canceled ? t_gray : btn_red;
        // 自己取消的或者被驳回的
        return Text(
          canceled ? "已取消" : "已驳回",
          style: TextStyle(color: color, fontSize: S.sp(15)),
        );
      }
      // 审核通过的
      else if (res.stat == draw_ok) {
        return Text(
          "审核通过",
          style: TextStyle(color: Colors.lightBlue, fontSize: S.sp(15)),
        );
      }
      return SizedBox.shrink();
    }
  }

  /// 取消提现申请
  void _doCancelDrawMoney(String id) {
    CusDialog.normal(
      context,
      title: "确定取消此次提现吗",
      onApproval: () async {
        try {
          bool ok = await ApiAccount.masterDrawMoneyCancel(id);
          if (ok) {
            CusToast.toast(context, text: "取消成功");
            await _refresh();
          }
        } catch (e) {
          Log.error("取消提现申请出现异常：$e");
        }
      },
    );
  }

  /// 刷新数据
  _refresh() async {
    _pageNo = _rowsCount = 0;
    _l.clear();
    setState(() {});
    await _fetch();
  }

  @override
  bool get wantKeepAlive => true;
}
