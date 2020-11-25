import 'package:flutter/material.dart';
import 'package:yiapp/complex/class/debug_log.dart';
import 'package:yiapp/complex/const/const_color.dart';
import 'package:yiapp/complex/tools/adapt.dart';
import 'package:yiapp/complex/tools/cus_time.dart';
import 'package:yiapp/complex/type/bool_utils.dart';
import 'package:yiapp/complex/widgets/cus_complex.dart';
import 'package:yiapp/complex/widgets/flutter/cus_appbar.dart';
import 'package:yiapp/complex/widgets/flutter/cus_button.dart';
import 'package:yiapp/complex/widgets/flutter/cus_dialog.dart';
import 'package:yiapp/complex/widgets/flutter/cus_text.dart';
import 'package:yiapp/complex/widgets/flutter/cus_toast.dart';
import 'package:yiapp/complex/widgets/master/hehun_res_show.dart';
import 'package:yiapp/complex/widgets/small/cus_avatar.dart';
import 'package:yiapp/model/liuyaos/liuyao_result.dart';
import 'package:yiapp/model/orders/yiOrder-dart.dart';
import 'package:yiapp/model/orders/yiOrder-heHun.dart';
import 'package:yiapp/model/orders/yiOrder-liuyao.dart';
import 'package:yiapp/model/orders/yiOrder-sizhu.dart';
import 'package:yiapp/service/api/api-yi-order.dart';
import 'package:yiapp/service/api/api_base.dart';
import 'package:yiapp/service/api/api_yi.dart';
import 'package:yiapp/ui/fortune/daily_fortune/liu_yao/liuyao_symbol_res.dart';

// ------------------------------------------------------
// author：suxing
// date  ：2020/10/20 11:20
// usage ：单条大师订单详情
// ------------------------------------------------------

class MasterOrderDetail extends StatefulWidget {
  final String id;
  final String barName;
  final bool showUser;

  MasterOrderDetail({this.id, this.barName, this.showUser, Key key})
      : super(key: key);

  @override
  _MasterOrderDetailState createState() => _MasterOrderDetailState();
}

class _MasterOrderDetailState extends State<MasterOrderDetail> {
  var _future;
  var _order = YiOrder(); // 订单详情
  var _liuYaoRes = LiuYaoResult(); // 六爻结果详情
  List<int> _codes = []; // 六爻数组编码

  /// 获取单条订单详情
  _fetch() async {
    try {
      var res = widget.showUser
          ? await ApiYiOrder.yiOrderHisGet(widget.id)
          : await ApiYiOrder.yiOrderGet(widget.id);
      if (res != null) _order = res;
      if (widget.barName.contains("六爻")) {
        await _fetchLiuYao();
      }
    } catch (e) {
      Debug.logError("获取${widget.barName}订单详情出现异常：$e");
    }
  }

  /// 如果是六爻，获取六爻详情
  _fetchLiuYao() async {
    YiOrderLiuYao yao = _order.content;
    _codes = yao.yao_code.split('').map((e) => int.parse(e)).toList();
    var m = {
      "year": yao.year,
      "month": yao.month,
      "day": yao.day,
      "hour": yao.hour,
      "minute": yao.minute,
      "code": yao.yao_code,
      "male": yao.is_male ? 1 : 0,
    };
    Debug.log("将要查询的数据:$m");
    try {
      var res = await ApiYi.liuYaoQiGua(m);
      if (res != null) _liuYaoRes = res;
    } catch (e) {
      Debug.logError("六爻订单中查询六爻出现异常：$e");
    }
  }

  /// 大师完成订单
  void _doOrder() {
    CusDialog.normal(context, title: "确认该订单已完成了吗", onApproval: () async {
      try {
        bool ok = await ApiYiOrder.yiOrderComplete(_order.id);
        if (ok) {
          CusToast.toast(context, text: "确认成功");
          Navigator.of(context).pop("");
        }
      } catch (e) {
        Debug.logError("大师确认完成订单时出现异常：$e");
      }
    });
  }

  @override
  void initState() {
    _future = _fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CusAppBar(text: widget.barName),
      body: FutureBuilder(
        future: _future,
        builder: (context, snap) {
          if (!snapDone(snap)) {
            return Center(child: CircularProgressIndicator());
          }
          return _lv();
        },
      ),
      backgroundColor: primary,
    );
  }

  Widget _lv() {
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(height: 10),
          ..._avatarNick(), // 大师以及下单人的头像和昵称
          if (widget.barName.contains("六爻"))
            _buildLiuYao(),
          if (widget.barName.contains("四柱"))
            _buildSiZhu(),
          if (widget.barName.contains("合婚"))
            _buildHeHun(),
          _dividerCtr(),
          CusText("问题描述", t_primary, 30),
          SizedBox(height: 10),
          Text(
            _order.comment,
            style: TextStyle(color: t_gray, fontSize: Adapt.px(30)),
          ),
          SizedBox(height: 50),
          // 是大师本人订单,且可以让任何人看到(说明该订单已完成),则显示完成订单按钮
          if (_order.master_id == ApiBase.uid && !widget.showUser)
            CusRaisedBtn(
              text: "完成订单",
              onPressed: _doOrder,
              backgroundColor: Colors.blueGrey,
            ),
        ],
      ),
    );
  }

  /// 大师以及下单人的头像和昵称
  List<Widget> _avatarNick() {
//    LiuYaoRiqi t = _liuYaoRes.riqi;
    return <Widget>[
      Row(
        children: <Widget>[
          CusText("时间", t_primary, 30),
          SizedBox(width: Adapt.px(30)),
//          CusText("${t.year}年${t.month}月${t.day}日${t.hour}时${t.minute}分",
//              t_gray, 30),
          CusText(CusTime.ymd(_order.create_date), t_gray, 30),
        ],
      ),
      _dividerCtr(),
      // 大师不用看到自己的个人信息
      if (_order.master_id != ApiBase.uid) ...[
        // 大师信息
        CusText("大师信息", t_primary, 30),
        SizedBox(height: 10),
//        _dividerCtr(),
        Row(
          children: <Widget>[
            CusAvatar(url: _order.master_icon_ref, rate: 20), // 大师头像
            SizedBox(width: 20),
            CusText(_order.master_nick_ref, t_gray, 28), // 大师昵称
          ],
        ),
        _dividerCtr(),
      ],
      // 下单人不用看到自己的信息
      if (_order.uid != ApiBase.uid) ...[
        CusText("下单人信息", t_primary, 30),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            CusAvatar(url: _order.icon_ref, rate: 20), // 下单人头像
            SizedBox(width: 20),
            CusText(_order.nick_ref, t_gray, 28), // 下单人昵称
          ],
        ),
      ],
    ];
  }

  /// 显示六爻结果
  Widget _buildLiuYao() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CusText("六爻排盘结果", t_primary, 30),
        SizedBox(height: 15),
        LiuYaoSymRes(res: _liuYaoRes, codes: _codes),
      ],
    );
  }

  /// 显示四柱结果
  Widget _buildSiZhu() {
    YiOrderSiZhu siZhu = _order.content as YiOrderSiZhu;
    return Column(
      children: <Widget>[
        _dividerCtr(),
        SizedBox(height: Adapt.px(20)),
        Row(
          children: <Widget>[
            CusText("姓名：", t_primary, 30),
            CusText(siZhu.name, t_gray, 30),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Adapt.px(10)),
          child: Row(
            children: <Widget>[
              CusText("性别：", t_primary, 30),
              CusText(siZhu.is_male ? "男" : "女", t_gray, 30),
            ],
          ),
        ),
        Row(
          children: <Widget>[
            CusText("出生日期：", t_primary, 30),
            CusText("显示时间", t_gray, 30),
          ],
        ),
      ],
    );
  }

  /// 显示合婚结果
  Widget _buildHeHun() {
    YiOrderHeHun heHun = _order.content as YiOrderHeHun;
    return Column(
      children: <Widget>[
        HeHunResShow(name: heHun.name_male, sex: "男", time: "男生时间"),
        HeHunResShow(name: heHun.name_female, sex: "女", time: "女生时间"),
      ],
    );
  }

  /// 通用的 divider
  Widget _dividerCtr() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(thickness: 0.2, height: 0, color: t_gray),
    );
  }
}
